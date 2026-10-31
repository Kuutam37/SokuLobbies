@echo off
setlocal
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0RunPrivateServerSafe.ps1"
echo.
pause
