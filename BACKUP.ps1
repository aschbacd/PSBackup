. .\lib\OpenFolderDialog.ps1

#find filenames
$sourceRoot = Read-FolderBrowserDialog -InitialDirectory "Desktop" -Description "Select directory beeing backed up."
$destinationRoot = Read-FolderBrowserDialog -InitialDirectory $sourceRoot -Description "Select directory for saving the backup."

$dateStr = Get-Date -UFormat "%Y%m%d-%H%M"
 
$destinationRoot += "\" +(Get-Item $sourceRoot).BaseName + "@" + $dateStr

#compress items
Compress-Archive -Path $sourceRoot -DestinationPath $destinationRoot

# add acls
$tmpacls = $env:TEMP + "\acls"

icacls $sourceRoot /save $tmpacls /T

Compress-Archive -Path $tmpacls -Update -DestinationPath $destinationRoot

Remove-Item $tmpacls