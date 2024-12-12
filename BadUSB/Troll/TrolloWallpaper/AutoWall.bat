:: Title: AutoWall
:: Autor: 8ad3rror

@echo off
set IMAGE_PATH=C:\AutoWall\trollo.jpg
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "%IMAGE_PATH%" /f
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v WallpaperStyle /t REG_SZ /d "2" /f
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v TileWallpaper /t REG_SZ /d "0" /f
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
exit
