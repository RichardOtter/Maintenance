
$PSVersionTable

$limit = 20
$min=0

While ($min -lt $limit)
{
Start-Sleep -Seconds 60
$min=$min + 1
Write-Host $min
}




