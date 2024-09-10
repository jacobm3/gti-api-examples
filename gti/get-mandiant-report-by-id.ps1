# Retrieves Mandiant report JSON by report ID.

$REPORT = if ($args[0]) { $args[0] } else { "24-10019694" }
if (-not $env:GTIKEY) { Write-Host "GTIKEY is missing"; exit 1 }

Invoke-RestMethod -Uri "https://www.virustotal.com/api/v3/mati/report/$REPORT" `
    -Method Get `
    -Headers @{ 'x-apikey' = $env:GTIKEY }
