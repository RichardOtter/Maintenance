$IconCachePath = "$env:localappdata\Microsoft\Windows\Explorer\iconcache*"
Stop-Process -processname explorer
Remove-Item -path $IconCachePath -force -verbose
Start-Process explorer
