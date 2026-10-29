@echo off
setlocal EnableExtensions
title Windows Health Diagnostics

:MENU
cls
echo ============================================================
echo                 WINDOWS HEALTH DIAGNOSTICS
echo ============================================================
echo [1] Windows version and build
echo [2] System file checker (SFC verify only)
echo [3] DISM component store health check
echo [4] Windows Update service status
echo [5] Recent system errors (last 7 days)
echo [6] Recent unexpected shutdown events (best effort)
echo [7] Open Windows Update settings
echo [0] Back
echo.
set "choice="
set /p "choice=Select: "
if "%choice%"=="1" (systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"System Type" & goto PAUSE)
if "%choice%"=="2" (sfc /verifyonly & goto PAUSE)
if "%choice%"=="3" (DISM /Online /Cleanup-Image /CheckHealth & goto PAUSE)
if "%choice%"=="4" (powershell -NoProfile -Command "Get-Service wuauserv,bits,cryptsvc | Format-Table Name,Status,StartType -Auto" & goto PAUSE)
if "%choice%"=="5" (powershell -NoProfile -Command "Get-WinEvent -FilterHashtable @{LogName='System'; Level=1,2,3; StartTime=(Get-Date).AddDays(-7)} -MaxEvents 40 -ErrorAction SilentlyContinue | Select-Object TimeCreated,Id,ProviderName,LevelDisplayName,Message | Format-List" & goto PAUSE)
if "%choice%"=="6" (powershell -NoProfile -Command "Get-WinEvent -FilterHashtable @{LogName='System'; Id=41,6008; StartTime=(Get-Date).AddDays(-30)} -MaxEvents 30 -ErrorAction SilentlyContinue | Select-Object TimeCreated,Id,ProviderName,Message | Format-List" & goto PAUSE)
if "%choice%"=="7" (start "" ms-settings:windowsupdate & goto MENU)
if "%choice%"=="0" exit /b 0
echo Invalid selection.
timeout /t 2 >nul
goto MENU
:PAUSE
echo.
echo Some checks may need an elevated terminal for complete results.
pause
goto MENU
