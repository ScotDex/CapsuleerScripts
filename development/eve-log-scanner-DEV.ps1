# Section to store log file path and keywords to detect 
$chatlogPath = "$env:userprofile\Documents\EVE\logs\Chatlogs"
# edit keyword list to add or remove keywords to detect in local chat log
# keywords are not case sensitive and will match any part of the line.
$keywordList = @("wtb") # Add your keywords here, separated by commas

# Function to get the latest local chat log file
function Get-LatestLocalChatLog {
    return Get-ChildItem -Path $chatlogPath -Filter "Local_*.txt" |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1
}

# Function to send a message to Discord webhook (optional)

function DiscordPing {
    param (
        [string]$keyword,
        [string]$line
    )
    
}

######################################

# Discord webhook URL (optional)
# Uncomment the following line to enable Discord notifications
$webhookUrl = "https://discord.com/api/webhooks/1363959440960782346/u2O1gKrB2aRq0saM4Eoye6JX7EAVPdv_aToXfZD-VAPJLU_LhWoAPd70kZs72qn3HrsG" # Replace with your Discord webhook URL

$payload = @{
    content = "Keyword detected: $keyword`nMessage: $line"
    username = "Chat Monitor"
} | ConvertTo-Json -Depth 3

try {
    Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $payload -ContentType "application/json"
} catch {
    Write-Warning "Failed to send Discord notification: $($_.Exception.Message)"
}

##########################

# Error handling to check its available.

Write-Host "Local Chat Monitor Active" -ForegroundColor Green
$currentLog = Get-LatestLocalChatLog
if (-not $currentLog) {
    Write-Error "No Local chat logs found. Are you sure EVE has chat logging enabled?"
    exit
}

# Once the log file is found, initialize variables

$lastFileSize = (Get-Item $currentLog.FullName).Length
$alreadySeen = @{}
Write-Host "Monitoring $($currentLog.FullName) for new messages..." -ForegroundColor Green

while ($true) {
    # Check for new log file
    $newLog = Get-LatestLocalChatLog
    if ($newLog.FullName -ne $currentLog.FullName) {
        Write-Host "`nNew log file detected: $($newLog.Name)" -ForegroundColor Yellow
        $currentLog = $newLog
        $lastFileSize = 0 # Reset file size for the new log
        $alreadySeen = @{} # Clear seen messages for the new log
        Write-Host "Now monitoring $($currentLog.FullName)" -ForegroundColor Green
        continue
    }

    try {
        # Log file comparison and reading log file - discovered that cant use streamreader as it locks the file and prevents eve from writing to it.
        # This is a workaround to read the file without locking it - using Get-Content with -Tail
        # Get the current file size and read new lines if the file has grown
        $currentFileSize = (Get-Item $currentLog.FullName).Length
        if ($currentFileSize -gt $lastFileSize) {
            $newContent = Get-Content -Path $currentLog.FullName -Tail ($currentFileSize - $lastFileSize)
            $lastFileSize = $currentFileSize

            foreach ($line in $newContent) {
                foreach ($keyword in $keywordList) {
                    if ($line -match $keyword -and -not $alreadySeen.ContainsKey($line)) {
                        Write-Host "[$((Get-Date).ToString('HH:mm:ss'))] Match: $keyword -> $line" -ForegroundColor Magenta
                        $alreadySeen[$line] = $true
                    }
                }
            }
        }
    } catch {
        Write-Warning "Error reading log file: $($_.Exception.Message)"
        Start-Sleep -Seconds 1
    }

    Start-Sleep -Milliseconds 100
}