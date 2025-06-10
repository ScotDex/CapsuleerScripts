
# Developed by Dexomus Viliana

# Designed to look at fleet logs, and will grab the latest exported loot sheet and add it to your desktop as a spreadsheet.

# Hopefully making fleet management slightly more practical, make sure there are no loot theifs! 

# I hope you find it useful - let me know any potential ideas for progress/improvements on top of this.

# Get the username of the current user
$userName = $env:USERNAME

# Get the path to the user's desktop directory
$desktopPath = "C:\Users\$userName\Desktop"

# Set the path to the directory where your text files are located
$directoryPath = "C:\Users\$userName\Documents\EVE\logs\Fleetlogs\"

# Get the latest text file in the directory
$latestFile = Get-ChildItem -Path $directoryPath -Filter "Loot - *.txt" | Sort-Object LastWriteTime -Descending | Select-Object -First 1

# Check if a file was found
if ($latestFile) {
    # Set the path to the latest input text file
    $txtFilePath = $latestFile.FullName

    # Generate the output CSV file name based on the input file name
    $csvFileName = $latestFile.Name -replace '\.txt$', '.csv'
    $csvFilePath = Join-Path -Path $desktopPath -ChildPath $csvFileName

    # Read the content of the text file and convert it to CSV
    Get-Content -Path $txtFilePath | ConvertFrom-Csv -Delimiter "`t" | Export-Csv -Path $csvFilePath -NoTypeInformation

    Write-Host "CSV file generated: $csvFilePath"
} else {
    Write-Host "No text files found in the directory: $directoryPath"
}
