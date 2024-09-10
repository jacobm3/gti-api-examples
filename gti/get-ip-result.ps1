if (-not $env:GTIKEY) { 
    Write-Host "GTIKEY is missing"
    exit 1 
}

$IPADDR = if ($args[0]) { 
    $args[0] 
} else { 
    "124.195.255.12"
}

Invoke-RestMethod -Uri "https://www.virustotal.com/api/v3/ip_addresses/$IPADDR" `
    -Method Get `
    -Headers @{ 'x-apikey' = $env:GTIKEY } 
