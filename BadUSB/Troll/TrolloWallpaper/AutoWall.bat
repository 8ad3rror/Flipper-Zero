@echo off
reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "C:\AutoWall\trollo.jpg" /f
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters