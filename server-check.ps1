$uri = "https://esi.evetech.net/latest/status/"
try {
    $resp = Invoke-RestMethod -Uri $uri -Headers @{ "User-Agent" = "MyEsiApp (email@example.com)" } -TimeoutSec 10
    Write-Host "🎮 EVE Server is ONLINE"
    Write-Host "Players: $($resp.players)"
    Write-Host "Server Version: $($resp.server_version)"
    Write-Host "VIP-mode: $($resp.vip)"
}
catch {
    Write-Host "⚠️ Could not reach EVE ESI endpoint:" $_.Exception.Message -ForegroundColor Red
}
