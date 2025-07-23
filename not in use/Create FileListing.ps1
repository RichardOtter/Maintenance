# Generate recursive directory and file listings
# with both creation and modification times

$timestamp = Get-Date -Format "yyyyMMdd_HHmm"

$rootPath = "C:\Users\rotter\Genealogy"
$outputFile = "C:\Users\rotter\Genealogy\File Listings\File_Listings (" + $timestamp + ").txt"

# keep awake untill done
Start-Process -FilePath "C:\Program Files\PowerToys\PowerToys.Awake.exe" -ArgumentList "--use-parent-pid" -NoNewWindow

Add-Content -Path $outputFile -Value "`r`n"

Get-ChildItem -Path $rootPath -Directory -Recurse | ForEach-Object {
    $dir = $_.FullName
    Add-Content -Path $outputFile -Value "Directory: $dir"
    Get-ChildItem -Path $dir | Select-Object Name, Length, CreationTime, LastWriteTime | Format-Table -AutoSize | Out-String | Add-Content -Path $outputFile
    Add-Content -Path $outputFile -Value "`r`n"
}