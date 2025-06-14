

# $username="admin"
# $password="password"
# $credentials = "{$username}:{$password}"
# $credentialBytes = [System.Text.Encoding]::ASCII.GetBytes($credentials)
# $base64AuthInfo = [Convert]::ToBase64String(($credentialBytes))
# $basicAuthHeader = "Basic " + $base64AuthInfo

# The block of code above is used to create a basic authentication header for any api request

# The code below is used to authenticate with the EVE Online API using OAuth2
# The code is based on the example provided in the EVE Online documentation: https://esi.evetech.net/ui/?version=latest#/Character/get_characters_character_id
$clientID="539efdfedabe4ca19575d01b6ae5ba8e"
$clientSecret="xBMQMOOZVxfQI8RQPSjKEKXvqsdJKybv8UceDZjY"
# $credentials = "{$username}:{$password}"
# $credentialBytes = [System.Text.Encoding]::ASCII.GetBytes($credentials)
# $base64AuthInfo = [Convert]::ToBase64String(($credentialBytes))
# $basicAuthHeader = "Basic " + $base64AuthInfo
$redirectUri="https://c6ce-146-70-204-179.ngrok-free.app/callback"
$scopes = "publicData esi-assets.read_assets.v1"
$state = [Guid]::NewGuid().ToString() # Generate a random state value
$encodedScope = [System.Web.HttpUtility]::UrlEncode($scopes)
$tokenUri = "https://login.eveonline.com/v2/oauth/token"
$authUrl = "https://login.eveonline.com/v2/oauth/authorize?response_type=code&redirect_uri=$redirectUri&client_id=$clientID&scope=$encodedScope&state=$state"
$assetsUrl = "https://esi.evetech.net/latest/characters/95282689/assets/"
$encodedAssets = [System.Web.HttpUtility]::UrlEncode($assetsUrl)
Write-Host "Please visit this URL to authenticate: $authUrl"

$authorizationCode = "ZaazFJl76kSX_87Z0GQJ1A"

$body = @{
    grant_type    = "authorization_code"
    code          = $authorizationCode
    redirect_uri  = $redirectUri
    client_id     = $clientID
    client_secret = $clientSecret
}
$response = Invoke-RestMethod -Uri "$tokenUri" -Method Post -ContentType "application/x-www-form-urlencoded" -Body $body

$accessToken = $response.access_token
Write-Host "Access Token: $accessToken"

$headers = @{
    Authorization = "Bearer $accessToken"
    "Content-Type"="application/json"
}

# The code below is used to get the character information for a specific character

$uri = "https://esi.evetech.net/latest/characters/95282689/"
$characterInfo = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get
$characterInfo

$assetResponse = Invoke-RestMethod -Uri "$encodedAssets" -Headers $headers -Method Get
$assetResponse