# Start the keep awake script in the background
$WShell = New-Object -com "Wscript.Shell"
$keepAwake = {
    while ($true) {
        $WShell.sendkeys("{SCROLLLOCK}")
        Start-Sleep -Seconds 60
    }
}

Start-Job -ScriptBlock $keepAwake

$cmdScriptPath = "C:\Users\rotter\Development\Maintenance\Update 2TB SSD for backup.cmd"

# Run the robocopy command
Start-Process -FilePath "$cmdScriptPath" -NoNewWindow -Wait


# Stop the keep awake job after robocopy finishes
Get-Job | Stop-Job
Remove-Job -Force -State

