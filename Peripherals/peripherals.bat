@echo off
setlocal EnableExtensions
title Peripheral Diagnostics

:MENU
cls
echo ============================================================
echo              PERIPHERAL AND DEVICE DIAGNOSTICS
echo ============================================================
echo [1] Printers and print queues
echo [2] Print Spooler service
echo [3] Audio endpoints
echo [4] Audio-related services
echo [5] Bluetooth devices (where supported)
echo [6] USB controllers and connected USB devices
echo [7] Cameras and imaging devices
echo [8] All Plug and Play devices with problem codes
echo [0] Back
echo.
set "choice="
set /p "choice=Select: "
if "%choice%"=="1" (powershell -NoProfile -Command "Get-CimInstance Win32_Printer | Format-Table Name,Default,WorkOffline,PrinterStatus,DriverName,PortName -Auto" & goto PAUSE)
if "%choice%"=="2" (powershell -NoProfile -Command "Get-Service Spooler | Format-List Name,Status,StartType; Get-Printer -ErrorAction SilentlyContinue | Format-Table Name,PrinterStatus,JobCount -Auto" & goto PAUSE)
if "%choice%"=="3" (powershell -NoProfile -Command "Get-CimInstance Win32_SoundDevice | Format-Table Name,Manufacturer,Status,PNPDeviceID -Wrap" & goto PAUSE)
if "%choice%"=="4" (powershell -NoProfile -Command "Get-Service Audiosrv,AudioEndpointBuilder,BthServ -ErrorAction SilentlyContinue | Format-Table Name,DisplayName,Status,StartType -Auto" & goto PAUSE)
if "%choice%"=="5" (powershell -NoProfile -Command "if (Get-Command Get-PnpDevice -ErrorAction SilentlyContinue) { Get-PnpDevice -Class Bluetooth -ErrorAction SilentlyContinue | Format-Table Status,Class,FriendlyName,InstanceId -Wrap } else { Write-Host 'PnP device cmdlets are unavailable.' }" & goto PAUSE)
if "%choice%"=="6" (powershell -NoProfile -Command "Get-CimInstance Win32_PnPEntity | Where-Object {$_.PNPClass -in @('USB','USBController') -or $_.Name -match 'USB'} | Format-Table Name,Status,PNPClass,ConfigManagerErrorCode -Wrap" & goto PAUSE)
if "%choice%"=="7" (powershell -NoProfile -Command "Get-PnpDevice -Class Camera,Image -ErrorAction SilentlyContinue | Format-Table Status,Class,FriendlyName,InstanceId -Wrap" & goto PAUSE)
if "%choice%"=="8" (powershell -NoProfile -Command "Get-CimInstance Win32_PnPEntity | Where-Object {$_.ConfigManagerErrorCode -ne 0} | Format-Table Name,PNPClass,ConfigManagerErrorCode,Status -Wrap" & goto PAUSE)
if "%choice%"=="0" exit /b 0
echo Invalid selection.
timeout /t 2 >nul
goto MENU
:PAUSE
echo.
pause
goto MENU
