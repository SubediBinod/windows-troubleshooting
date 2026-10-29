@echo off
setlocal EnableExtensions
title OEM Diagnostics and Firmware

:MENU
cls
echo ============================================================
echo              OEM HARDWARE DIAGNOSTICS
echo ============================================================
echo [1] Detect computer manufacturer and model
echo [2] Open Windows UEFI firmware settings
echo [3] Open Windows Update optional driver page
echo [4] Open Device Manager
echo [5] Open Reliability Monitor
echo [6] Open System Information
echo [7] Show system serial and board identifiers (may be blank)
echo.
echo OEM boot diagnostics usually require restarting and pressing the
echo manufacturer's firmware key, or selecting Diagnostics in UEFI.
echo Use only the official support site for the exact computer model.
echo Do not flash BIOS/UEFI unless necessary and power is stable.
echo.
echo Common official support portals:
echo Dell:     https://www.dell.com/support
echo HP:       https://support.hp.com
echo Lenovo:   https://support.lenovo.com
echo ASUS:     https://www.asus.com/support
echo Acer:     https://www.acer.com/support
echo Microsoft:https://support.microsoft.com/surface
echo.
echo [0] Back
set "choice="
set /p "choice=Select: "
if "%choice%"=="1" (powershell -NoProfile -Command "Get-CimInstance Win32_ComputerSystem | Format-List Manufacturer,Model,SystemType; Get-CimInstance Win32_BIOS | Format-List SMBIOSBIOSVersion,ReleaseDate" & goto PAUSE)
if "%choice%"=="2" (shutdown /r /fw /t 0 & goto MENU)
if "%choice%"=="3" (start "" ms-settings:windowsupdate-optionalupdates & goto MENU)
if "%choice%"=="4" (start "" devmgmt.msc & goto MENU)
if "%choice%"=="5" (start "" perfmon.exe /rel & goto MENU)
if "%choice%"=="6" (start "" msinfo32.exe & goto MENU)
if "%choice%"=="7" (powershell -NoProfile -Command "Get-CimInstance Win32_BaseBoard | Format-List Manufacturer,Product,Version,SerialNumber; Get-CimInstance Win32_BIOS | Format-List SerialNumber,SMBIOSBIOSVersion" & goto PAUSE)
if "%choice%"=="0" exit /b 0
echo Invalid selection.
timeout /t 2 >nul
goto MENU
:PAUSE
echo.
pause
goto MENU
