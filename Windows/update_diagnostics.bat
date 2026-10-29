@echo off
setlocal EnableExtensions
title Windows Update Diagnostics

:MENU
cls
echo ============================================================
echo                  WINDOWS UPDATE DIAGNOSTICS
echo ============================================================
echo [1] Windows Update related services
echo [2] Recently installed hotfixes
echo [3] Windows Update client events (last 7 days)
echo [4] Windows Update policy registry values (if present)
echo [5] Open Windows Update settings
echo [6] Open update history page
echo [0] Back
echo.
set "choice="
set /p "choice=Select: "
if "%choice%"=="1" (powershell -NoProfile -Command "Get-Service wuauserv,bits,cryptsvc,usosvc, WaaSMedicSvc -ErrorAction SilentlyContinue | Format-Table Name,DisplayName,Status,StartType -Auto" & goto PAUSE)
if "%choice%"=="2" (powershell -NoProfile -Command "Get-HotFix -ErrorAction SilentlyContinue | Sort-Object InstalledOn -Descending | Select-Object -First 30 HotFixID,Description,InstalledBy,InstalledOn | Format-Table -Auto" & goto PAUSE)
if "%choice%"=="3" (powershell -NoProfile -Command "Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-WindowsUpdateClient/Operational';StartTime=(Get-Date).AddDays(-7)} -MaxEvents 60 -ErrorAction SilentlyContinue | Select-Object TimeCreated,Id,LevelDisplayName,Message | Format-List" & goto PAUSE)
if "%choice%"=="4" (powershell -NoProfile -Command "$p='HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'; if(Test-Path $p){Get-ItemProperty $p | Format-List *}else{'No Windows Update policy key found at the standard path.'}" & goto PAUSE)
if "%choice%"=="5" (start "" ms-settings:windowsupdate & goto MENU)
if "%choice%"=="6" (start "" ms-settings:windowsupdate-history & goto MENU)
if "%choice%"=="0" exit /b 0
echo Invalid selection.
timeout /t 2 >nul
goto MENU
:PAUSE
echo.
pause
goto MENU
