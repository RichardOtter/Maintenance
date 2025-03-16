
# Parameter is the command  script to run
param($ScriptToRun)

$ScriptToRun


# Start the keep awake script in the background
$WShell = New-Object -com "Wscript.Shell"
$keepAwake = {
    while ($true) {
        $WShell.sendkeys("{SCROLLLOCK}")
        Start-Sleep -Seconds 60
    }
}
Start-Job -ScriptBlock $keepAwake

$scriptType=[System.IO.Path]::GetExtension($ScriptToRun)

if( ".ps1" -eq $scriptType) {
	Start-Process -FilePath "powershell.exe" -ArgumentList "-File `"$ScriptToRun`"" -NoNewWindow -Wait
}
elseif( ".cmd" -eq $scriptType -or ".bat" -eq $scriptType)
{
	Start-Process -FilePath "$ScriptToRun" -Wait -NoNewWindow
}
else
{
	Write-Host "The script type is not supported." -ForegroundColor Red
	exit
}

# Stop the keep awake job after cmd script finishes
Get-Job | Stop-Job
Get-Job | Remove-Job -Force

Write-Host "The ccmd script is done." -ForegroundColor Green

