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
