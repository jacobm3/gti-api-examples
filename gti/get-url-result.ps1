# Note - URLs must be base64 encoded for submission

if (-not $env:GTIKEY) { Write-Host "GTIKEY is missing"; exit 1 }

$URL = if ($args[0]) { $args[0] } else { "docs.google.com/drawings/d/1z_z_7I2eVf9ZmwBzEuPTIBRzDhMJmBYF0nWoPtkbE2c/edit" }

# VT API wants URL base64 encoded without any trailing padding
$B64URL = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($URL)) -replace '='

Invoke-RestMethod -Uri "https://www.virustotal.com/api/v3/urls/$B64URL" `
    -Method Get `
    -Headers @{ 'x-apikey' = $env:GTIKEY } 
