[CmdletBinding()]
param(
    [string]$ClientID = "your-client-id",
    [string]$ClientSecret = "your-secret",
    [string]$RedirectUri = "https://your.app/callback",
    [string]$Scopes = "publicData"
)

$state = [guid]::NewGuid().ToString()
$encodedScope = [System.Web.HttpUtility]::UrlEncode($Scopes)

$authUrl = "https://login.eveonline.com/v2/oauth/authorize?response_type=code&redirect_uri=$RedirectUri&client_id=$ClientID&scope=$encodedScope&state=$state"
Start-Process $authUrl
$authorizationCode = Read-Host "Paste the authorization code"

function Get-EVEAccessToken {
    param($ClientID, $ClientSecret, $RedirectUri, $AuthorizationCode)

    $body = @{
        grant_type    = "authorization_code"
        code          = $AuthorizationCode
        redirect_uri  = $RedirectUri
        client_id     = $ClientID
        client_secret = $ClientSecret
    }

    return Invoke-RestMethod -Uri "https://login.eveonline.com/v2/oauth/token" `
        -Method Post -ContentType "application/x-www-form-urlencoded" -Body $body
}


function Update-EVEAccessToken {
    param($ClientID, $ClientSecret, $RefreshToken)

    $body = @{
        grant_type    = "refresh_token"
        refresh_token = $RefreshToken
        client_id     = $ClientID
        client_secret = $ClientSecret
    }

    return Invoke-RestMethod -Uri "https://login.eveonline.com/v2/oauth/token" `
        -Method Post -ContentType "application/x-www-form-urlencoded" -Body $body
}

# =========================================================

$response = Get-EVEAccessToken -ClientID $ClientID -ClientSecret $ClientSecret -RedirectUri $RedirectUri -AuthorizationCode $authorizationCode
$accessToken = $response.access_token

$headers = @{
    Authorization = "Bearer $accessToken"
    "Content-Type" = "application/json"
}

$verify = Invoke-RestMethod -Uri "https://login.eveonline.com/oauth/verify" -Headers $headers
$characterID = $verify.CharacterID
Write-Host "Character ID: $characterID"

# Fetch character info
try {
    Invoke-RestMethod -Uri "https://esi.evetech.net/latest/characters/$characterID/" -Headers $headers
}
catch {
    Write-Host "Error fetching character info: $_"
}


# Fetch assets
try {
    Invoke-RestMethod -Uri "https://esi.evetech.net/latest/characters/$characterID/assets/" -Headers $headers
}
catch {
    Write-Host "Error fetching character assets: $_"
}


