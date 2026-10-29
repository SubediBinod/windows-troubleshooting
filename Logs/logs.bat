@echo off
setlocal EnableExtensions
title Event Logs and Crash Diagnostics

:MENU
cls
echo ============================================================
echo             EVENT LOGS AND CRASH DIAGNOSTICS
echo ============================================================
echo [1] Recent critical and error events (System, 24 hours)
echo [2] Recent application errors (24 hours)
echo [3] Application crash events (last 7 days)
echo [4] BugCheck and unexpected shutdown events (30 days)
echo [5] Windows Error Reporting entries (best effort)
echo [6] Open Reliability Monitor
echo [7] Open Event Viewer
echo [0] Back
echo.
set "choice="
set /p "choice=Select: "
if "%choice%"=="1" (powershell -NoProfile -Command "Get-WinEvent -FilterHashtable @{LogName='System';Level=1,2;StartTime=(Get-Date).AddHours(-24)} -MaxEvents 60 -ErrorAction SilentlyContinue | Select-Object TimeCreated,Id,ProviderName,LevelDisplayName,Message | Format-List" & goto PAUSE)
if "%choice%"=="2" (powershell -NoProfile -Command "Get-WinEvent -FilterHashtable @{LogName='Application';Level=1,2;StartTime=(Get-Date).AddHours(-24)} -MaxEvents 60 -ErrorAction SilentlyContinue | Select-Object TimeCreated,Id,ProviderName,LevelDisplayName,Message | Format-List" & goto PAUSE)
if "%choice%"=="3" (powershell -NoProfile -Command "Get-WinEvent -FilterHashtable @{LogName='Application';Id=1000,1001;StartTime=(Get-Date).AddDays(-7)} -MaxEvents 50 -ErrorAction SilentlyContinue | Select-Object TimeCreated,Id,ProviderName,Message | Format-List" & goto PAUSE)
if "%choice%"=="4" (powershell -NoProfile -Command "Get-WinEvent -FilterHashtable @{LogName='System';Id=41,1001,6008;StartTime=(Get-Date).AddDays(-30)} -MaxEvents 50 -ErrorAction SilentlyContinue | Select-Object TimeCreated,Id,ProviderName,Message | Format-List" & goto PAUSE)
if "%choice%"=="5" (powershell -NoProfile -Command "Get-WinEvent -FilterHashtable @{LogName='Application';ProviderName='Windows Error Reporting';StartTime=(Get-Date).AddDays(-7)} -MaxEvents 30 -ErrorAction SilentlyContinue | Select-Object TimeCreated,Id,Message | Format-List" & goto PAUSE)
if "%choice%"=="6" (start "" perfmon.exe /rel & goto MENU)
if "%choice%"=="7" (start "" eventvwr.msc & goto MENU)
if "%choice%"=="0" exit /b 0
echo Invalid selection.
timeout /t 2 >nul
goto MENU
:PAUSE
echo.
echo Event messages can contain usernames, paths, and other private details.
pause
goto MENU
