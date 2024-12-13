function Create7z {
    # Tworzenie folderu C:\temp, jeśli nie istnieje
    $tempFolder = "C:\temp"
    if (-not (Test-Path $tempFolder)) {
        New-Item -Path $tempFolder -ItemType Directory
    }

    # Pobieranie 7z.zip do C:\temp, jeśli nie istnieje
    $zipPath = "$tempFolder\7z.zip"
    if (-not (Test-Path $zipPath)) {
        Write-Host "Pobieranie 7za920.zip..."
        Invoke-WebRequest -Uri "https://www.7-zip.org/a/7za920.zip" -OutFile $zipPath
    }

    # Rozpakowywanie 7z.zip
    $extractedFolder = "$tempFolder\7z"
    if (-not (Test-Path $extractedFolder)) {
        Write-Host "Rozpakowywanie 7za920.zip..."
        Expand-Archive -Path $zipPath -DestinationPath $extractedFolder
    }

    # Ścieżka do 7za.exe
    $sevenZipPath = "$extractedFolder\7za.exe"
    
    # Sprawdzanie, czy 7za.exe istnieje
    if (-not (Test-Path $sevenZipPath)) {
        Write-Error "Nie znaleziono programu 7za.exe w ścieżce: $sevenZipPath"
        return
    }

    # Lista
