function Create7z {
    # Upewnij się, że folder C:\temp istnieje
    $tempFolder = "C:\temp"
    if (-not (Test-Path $tempFolder)) {
        Write-Error "Folder $tempFolder nie istnieje."
        return
    }

    # Ścieżki plików
    $filesToArchive = @(
        "C:\temp\Version.txt",
        "C:\temp\Wifi.txt",
        "C:\temp\Pass.txt"
    )

    # Sprawdzamy, czy pliki istnieją
    foreach ($file in $filesToArchive) {
        if (-not (Test-Path $file)) {
            Write-Error "Plik $file nie istnieje."
            return
        }
    }

    # Pobieranie 7za jeśli nie istnieje
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

    # Tworzenie nazwy archiwum na podstawie daty i godziny
    $timestamp = Get-Date -Format "yyyyMMdd_HHmm"
    $archivePath = "$tempFolder\$timestamp.7z"

    # Przygotowanie argumentów do komendy 7-Zip z pełnymi ścieżkami plików
    $arguments = @("a", "`"$archivePath`"")
    foreach ($file in $filesToArchive) {
        $arguments += "`"$file`""  # Używamy cudzysłowów wokół ścieżek
    }

    # Komenda do kompresji plików do archiwum 7z
    try {
        Write-Host "Tworzenie archiwum: $archivePath..."
        & $sevenZipPath $arguments
        Write-Host "Archiwum zostało utworzone: $archivePath"
    }
    catch {
        Write-Error "Wystąpił błąd podczas tworzenia archiwum: $_"
    }
}

# Wywołanie funkcji
Create7z
