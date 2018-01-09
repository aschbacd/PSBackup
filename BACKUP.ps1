$sourceRoot = "\\server\share"         # folder to be backed up - no backslash on the end of path
$destinationRoot = "E:\Backup"    # folder that holds backup - no backslash on the end of path

new-item $destinationRoot"\Backup" -itemtype directory
Copy-Item -Path $sourceRoot"\*" -Recurse -Destination $destinationRoot"\Backup" -Container
icacls $sourceRoot"\*" /save $destinationRoot"\ACL" /T