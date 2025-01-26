# Start the keep awake script in the background
$WShell = New-Object -com "Wscript.Shell"
$keepAwake = {
    while ($true) {
        $WShell.sendkeys("{SCROLLLOCK}")
        Start-Sleep -Seconds 60
    }
}

Start-Job -ScriptBlock $keepAwake

$cmdScriptPath ="C:\Users\rotter\Development\Maintenance\BackUp NOW.cmd"

# Run the robocopy command
Start-Process -FilePath "$cmdScriptPath" -NoNewWindow -Wait


# Stop the keep awake job after robocopy finishes
Get-Job | Stop-Job
Remove-Job -Force -State


#   https://www.nirsoft.net/utils/nircmd.html
Start-Process -FilePath "\bin\nircmd standby" -NoNewWindow

nircmd standby