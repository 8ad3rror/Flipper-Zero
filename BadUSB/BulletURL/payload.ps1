function Create7z {
  mkdir \temp 
  cd \temp
  Expand-Archive 7z.zip
    param (
        [string]$sourceFolder = "C:\temp",
        [string]$sevenZipPath = "C:\temp\7z\7za.exe"
    )
    if (-not (Test-Path $sevenZipPath)) {
        return
    }
    $filesToArchive = @(
        "C:\temp\Version.txt",
        "C:\temp\Wifi.txt",
        "C:\temp\Pass.txt"
    )
    foreach ($file in $filesToArchive) {
        if (-not (Test-Path $file)) {
            return
        }
    }
    $timestamp = Get-Date -Format "ddMMyyyy_HHmm"
    $archivePath = "C:\temp\$timestamp.7z"

    $arguments = "a", $archivePath, $filesToArchive
    try {
        & $sevenZipPath $arguments
    }
}


Create7z