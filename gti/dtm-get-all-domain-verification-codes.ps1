if (-not $env:GTIKEY) { 
    Write-Host "GTIKEY is missing"
    exit 1 
}

Invoke-RestMethod -Uri 'https://www.virustotal.com/api/v3/dtm/settings/domains/txt_record' `
  -Method Get `
  -Headers @{ 'x-apikey' = $env:GTIKEY }
