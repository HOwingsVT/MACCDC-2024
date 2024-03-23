# Define a function to check if a file is public READ/WRITE
function IsPublicReadWriteFile {
    param (
        [string]$filePath
    )

    # Get ACL (Access Control List) for the file
    $acl = Get-Acl -Path $filePath

    # Check if Everyone has Read and Write permissions
    $everyoneRule = $acl.Access | Where-Object { $_.IdentityReference -eq 'Everyone' -and $_.FileSystemRights -eq 'Read,Write' }

    return $everyoneRule -ne $null
}

# Get list of files in specified directory and its subdirectories
$directory = "C:\"  # Change this to the directory you want to search
$files = Get-ChildItem -Path $directory -Recurse -File

# Iterate over each file and check if it's public READ/WRITE
foreach ($file in $files) {
    if (IsPublicReadWriteFile -filePath $file.FullName) {
        Write-Host "Public READ/WRITE file found: $($file.FullName)"
    }
}