# Create paths
$zipPath = ""
$extractedPath = "dir-for-files\EXTRACTED"
$unextractedPath = "dir-for-files\NOTEXTRACTED"

# Create temporary directories for items.
New-Item -ItemType Directory $extractedPath
New-Item -ItemType Directory $unextractedPath

# Extract all contents of zipPath. 
# When no more archives exist output last file content to host
while($true)
{
    # Test the file exists to be extracted
    if(Test-Path $zipPath)
    {
        # Ensure extension is a zip. Yes I know this isn't a true binary test
        if($zipPath -like "*.zip")
        {
            # Extract archive to extracted path
            write-host "Extracting $zipPath"
            Expand-Archive $zipPath -DestinationPath $extractedPath
            
            # Get the object that was extracted
            $extractedItem = (Get-ChildItem -Path $extractedPath | Select-Object -First 1 | Select-Object -Property FullName).FullName
            
            # Clear temporary directory. This helps with grabbing the most current extracted file in the next step
            Remove-Item -Path "$unextractedPath\*"
            
            # Move the extracted object to the not extracted path
            Move-Item -Path $extractedItem -Destination $unextractedPath
            
            # Set the object to be extracted for the next iteration.
            $zipPath = (Get-ChildItem -Path $unextractedPath | Select-Object -First 1 | Select-Object -Property FullName).FullName
        }
        else
        {
            Get-Content -Path $zipPath
            break
        }
    }
    else
    {
        break
    }
}
