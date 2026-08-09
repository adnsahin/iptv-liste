@echo off
chcp 65001 >nul
echo GitHub'a push ediliyor...
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0push.ps1"
echo.
pause
