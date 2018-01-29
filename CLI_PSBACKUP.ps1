Param(
[string]$option,
[string]$source,
[string]$destination
)

class FileDetails{
    [string] $path
    [string] $hash
    [string] $mtime
}

function Syntax-Error() {
    echo ""
    echo "Please use the following syntax:"
    echo "PSBACKUP.ps1 <option> <source> <destination>"
    echo ""
    echo "   option:"
    echo "      /full for full backup"
    echo "      /diff for differential backup"
    echo "      /inc for incremental backup"
    echo "      /restore to restore a backup"
    echo ""
    echo "   source:"
    echo "      enter source folder for backup"
    echo "      enter source file for restore"
    echo ""
    echo "   destination:"
    echo "      on backup enter folder where backups are being stored"
    echo "      on restore enter folder where backup shall be restored into"
}

$fileArray
$folderArray

function AnalyzeFolder ($FOLDER)
{
	$NUMLOCAL=0
	$NUMSUB=0

	$FULL = Get-ChildItem "$FOLDER" -Include *.*

	Foreach ($ITEM in Get-ChildItem $FOLDER)
	{
		$FULLNAME=$ITEM.FullName

		if (!(Test-Path $FULLNAME -PathType Container))
		{
			$NUMLOCAL=$NUMLOCAL+1
            
            $file_details_tmp = New-Object FileDetails

            $file_details_tmp.path = $FULLNAME
            $Type="MD5"
            $fs = New-Object System.IO.FileStream $FULLNAME, "Open"
            $algo = [type]"System.Security.Cryptography.$Type"
            $crypto = $algo::Create()
            $hash = [BitConverter]::ToString($crypto.ComputeHash($fs)).Replace("-", "")
            $fs.Close()
            $file_details_tmp.hash = $hash
            $item = Get-Item $FULLNAME
            $file_details_tmp.mtime = $item.LastAccessTimeUtc
            $fileArray.Add($file_details_tmp);
		}
		else
		{
			If ($FULLNAME -ne $FOLDER)
			{
				$NUMTEMP=AnalyzeFolder "$FULLNAME"
				$NUMSUB=$NUMSUB+$NUMTEMP
			}
		}
	}
	$folderArray.Add($FOLDER);
    
}

# check if parameters are provided
if($option -and $source -and $destination) {
    
    # check for backup option
    if($option -eq "/full" -or $option -eq "/diff" -or $option -eq "/inc") {
        
        if((Test-Path $source -PathType Container) -eq $false) {
            # source path does not exist
            echo "ERROR: source folder does not exist";
        } elseif((Test-Path $destination -PathType Container) -eq $false) {
            # destination path does not exist
            echo "ERROR: destination folder does not exist";
        } else {
            # all paths exist -> option
            switch($option) {
                "/full" {
                    $fileArray = [System.Collections.ArrayList]::new();
                    $folderArray = [System.Collections.ArrayList]::new();
                    AnalyzeFolder "$source"
                    $resultFiles = @{ Files = $fileArray};
                    $resultFolder = @{ Folders = $folderArray};
                    
                    $resultFiles | ConvertTo-Json | Out-File $destination"\files.json"
                    $resultFolders | ConvertTo-Json | Out-File $destination"\folders.json"
                }

                "/diff" {
                    
                }

                "/inc" {

                }
            }
        }
    # check for restore option
    } elseif($option -eq "/restore") {
        
    } else {
        # wrong option parameter
        Syntax-Error;
    }
}
else {
    # parameters are not provided
    Syntax-Error;
}