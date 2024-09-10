# Retrieves Mandiant report JSON by report ID and extracts files information.

$REPORT = if ($args[0]) { $args[0] } else { "24-10019694" }
if (-not $env:GTIKEY) { Write-Host "GTIKEY is missing"; exit 1 }

$reportData = Invoke-RestMethod -Uri "https://www.virustotal.com/api/v3/mati/report/$REPORT" `
    -Method Get `
    -Headers @{ 'x-apikey' = $env:GTIKEY }

$reportData.data.attributes.files | ConvertTo-Json # Outputs the files information as JSON
