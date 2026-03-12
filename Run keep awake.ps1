param(
    [Parameter(Mandatory = $true)]
    [string]$ScriptPath,

    [switch]$SleepAfter
)

# --- Resolve and validate ---
if (-not (Test-Path $ScriptPath)) {
    Write-Error "File not found: $ScriptPath"
    exit 1
}

$ScriptPath = (Resolve-Path $ScriptPath).Path
$ext = [IO.Path]::GetExtension($ScriptPath).ToLower()

# --- Save current AC sleep timeout ---
$origStandby = powercfg /query SCHEME_CURRENT SUB_SLEEP STANDBYIDLE |
    Select-String "Current AC Power Setting Index" |
    ForEach-Object { ($_ -split ":")[1].Trim() }

# --- Disable AC sleep while running ---
powercfg -change -standby-timeout-ac 0 | Out-Null

$exitCode = 0

try {

    if ($ext -in ".cmd", ".bat") {

        #
        # --- Launch ONE real interactive CMD window using /c ---
        #

        $psi = New-Object System.Diagnostics.ProcessStartInfo
        $psi.FileName        = "cmd.exe"
        $psi.Arguments       = "/c `"$ScriptPath`""
        $psi.UseShellExecute = $true
        $psi.WindowStyle     = "Normal"

        # Start the real console window
        $proc = [System.Diagnostics.Process]::Start($psi)

        # Wait for THAT window to close
        while (-not $proc.HasExited) {
            Start-Sleep -Seconds 1
            $proc.Refresh()
        }

        $exitCode = 0
    }
    elseif ($ext -eq ".ps1") {

        #
        # --- Run PS1 normally ---
        #

        $proc = Start-Process powershell.exe `
            -ArgumentList "-NoProfile","-ExecutionPolicy","Bypass","-File",$ScriptPath `
            -PassThru -Wait

        $exitCode = $proc.ExitCode
    }
    else {
        Write-Error "Unsupported extension: $ext (only .cmd, .bat, .ps1)"
        $exitCode = 1
    }

}
finally {

    # --- Restore original AC sleep timeout ---
    if ($origStandby) {
        powercfg -change -standby-timeout-ac $origStandby | Out-Null
    }

    # --- Optional: sleep after completion ---
    if ($SleepAfter -and $exitCode -eq 0) {
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.Application]::SetSuspendState("Suspend", $false, $false) | Out-Null
    }

    exit $exitCode
}
