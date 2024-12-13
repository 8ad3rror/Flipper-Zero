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

    # Lista plików do zarchiwizowania
    $filesToArchive = @(
        "C:\temp\Version.txt",
        "C:\temp\Wifi.txt",
        "C:\temp\Pass.txt"
    )

    # Sprawdzanie, czy pliki istnieją
    foreach ($file in $filesToArchive) {
        if (-not (Test-Path $file)) {
            Write-Error "Plik nie istnieje: $file"
            return
        }
    }

    # Tworzenie nazwy archiwum na podstawie daty i godziny
    $timestamp = Get-Date -Format "ddMMyyyy_HHmm"
    $archivePath = "$tempFolder\$timestamp.7z"

    # Tworzenie argumentów do kompresji
    $arguments = @("a", $archivePath)
    $arguments += $filesToArchive

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
