. .\lib\OpenFolderDialog.ps1

Function Get-FileName([string]$InitialDirectory)
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $InitialDirectory
    $OpenFileDialog.filter = "ZIP (*.zip)| *.zip"
    $OpenFileDialog.ShowDialog() | Out-Null

    return $OpenFileDialog.FileName
}

$sourceRoot = Get-FileName -InitialDirectory "Desktop"
$destinationRoot = Read-FolderBrowserDialog -InitialDirectory $sourceRoot -Description "Select directory for restoring the backup."

Expand-Archive -Path $sourceRoot -DestinationPath $destinationRoot

$basename = (Get-Item $sourceRoot).BaseName.split('@')[0]

icacls $destinationRoot  /restore $destinationRoot"\acls"

Remove-Item $destinationRoot"\acls"