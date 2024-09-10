if (-not $env:GTIKEY) { 
    Write-Host "GTIKEY is missing"
    exit 1 
}

$HASH = if ($args[0]) { 
    $args[0] 
} else { 
    "131ae13512a7931484b5e53e1ec92031d6ae014c947e82deaab4e742350d7c42" 
}

Invoke-RestMethod -Uri "https://www.virustotal.com/api/v3/files/$HASH" `
    -Method Get `
    -Headers @{ 'x-apikey' = $env:GTIKEY } 
