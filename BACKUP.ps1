Function Read-FolderBrowserDialog([string]$InitialDirectory, [string]$Description)
{
    Add-Type -AssemblyName System.Windows.Forms
    $FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $FolderBrowser.Description = $Description
    $result = $FolderBrowser.ShowDialog((New-Object System.Windows.Forms.Form -Property @{TopMost = $true }))
    if ($result -eq [Windows.Forms.DialogResult]::OK){
        return $FolderBrowser.SelectedPath
    }
    else {
        exit
    }
}


$sourceRoot = Read-FolderBrowserDialog -InitialDirectory "Desktop" -Description "Select directory beeing backed up."
$destinationRoot = Read-FolderBrowserDialog -InitialDirectory $sourceRoot -Description "Select directory for saving the backup."

$dateStr = Get-Date -UFormat "%Y%m%d-%H%M"
 
$destinationRoot += (Get-Item $sourceRoot).BaseName + "@" + $dateStr


new-item $destinationRoot -itemtype directory
Copy-Item -Path $sourceRoot -Recurse -Destination $destinationRoot -Container

icacls $sourceRoot /save $destinationRoot"\.acls" /T
