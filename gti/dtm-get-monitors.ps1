if (-not $env:GTIKEY) { 
    Write-Host "GTIKEY is missing"
    exit 1 
}

if (-not $args[0]) {
    Write-Host "Monitor ID is missing. Usage: script.ps1 <monitor_id>"
    exit 1
}

$monitorId = $args[0]

Invoke-RestMethod -Uri "https://www.virustotal.com/api/v3/dtm/monitors/$monitorId" `
  -Method Get `
  -Headers @{ 'x-apikey' = $env:GTIKEY }
