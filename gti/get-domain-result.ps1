if (-not $env:GTIKEY) { 
    Write-Host "GTIKEY is missing"
    exit 1 
}

$DOMAIN = if ($args[0]) { $args[0] } else { "serak.top" }

Invoke-RestMethod -Uri "https://www.virustotal.com/api/v3/domains/$DOMAIN" `
  -Method Get `
  -Headers @{ 'x-apikey' = $env:GTIKEY }
