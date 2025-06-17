$uri = "https://esi.evetech.net/latest/status/"
try {
    $resp = Invoke-RestMethod -Uri $uri  -Method Get -ErrorAction Stop
    Write-Host "EVE Online Server Status: Online"
    write-host "Players - $($resp.players)"
    write-host "Start Time - $($resp.start_time)"
}
catch {
    Write-Host "Failed to retrieve server status: $($_.Exception.Message)"
}   