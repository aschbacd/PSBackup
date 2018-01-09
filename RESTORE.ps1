$sourceRoot = "E:\Backup"         # folder that holds backup - no backslash on the end of path
$destinationRoot = "\\server\restore"    # folder to restore into - no backslash on the end of path

Copy-Item -Path $sourceRoot"\Backup\*" -Recurse -Destination $destinationRoot -Container
icacls $destinationRoot /restore $sourceRoot"\ACL"