@echo off
setlocal EnableExtensions
title Applications and Tasks Diagnostics

:MENU
cls
echo ============================================================
echo           APPLICATIONS AND TASKS DIAGNOSTICS
echo ============================================================
echo [1] Installed applications (registry inventory)
echo [2] Windows Store app packages for current user
echo [3] Scheduled tasks with last run result
echo [4] Signed driver inventory
echo [5] Startup commands
echo [6] Services set to automatic but not running
echo [7] Default browser registration (best effort)
echo [8] Open Programs and Features
echo [0] Back
echo.
set "choice="
set /p "choice=Select: "
if "%choice%"=="1" (powershell -NoProfile -Command "$p=@('HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*','HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*','HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'); Get-ItemProperty $p -ErrorAction SilentlyContinue | Where-Object DisplayName | Sort-Object DisplayName -Unique | Select-Object DisplayName,DisplayVersion,Publisher,InstallDate | Format-Table -Wrap" & goto PAUSE)
if "%choice%"=="2" (powershell -NoProfile -Command "Get-AppxPackage | Select-Object Name,Version,Status,PackageFullName | Format-Table -Wrap" & goto PAUSE)
if "%choice%"=="3" (powershell -NoProfile -Command "Get-ScheduledTask -ErrorAction SilentlyContinue | ForEach-Object {$i=Get-ScheduledTaskInfo -TaskName $_.TaskName -TaskPath $_.TaskPath -ErrorAction SilentlyContinue; [pscustomobject]@{TaskPath=$_.TaskPath;TaskName=$_.TaskName;State=$_.State;LastRunTime=$i.LastRunTime;LastTaskResult=$i.LastTaskResult;NextRunTime=$i.NextRunTime}} | Sort-Object LastTaskResult | Format-Table -Wrap" & goto PAUSE)
if "%choice%"=="4" (powershell -NoProfile -Command "Get-CimInstance Win32_PnPSignedDriver | Sort-Object DeviceName | Format-Table DeviceName,DriverProviderName,DriverVersion,DriverDate,IsSigned -Wrap" & goto PAUSE)
if "%choice%"=="5" (powershell -NoProfile -Command "Get-CimInstance Win32_StartupCommand | Format-Table Name,Location,User,Command -Wrap" & goto PAUSE)
if "%choice%"=="6" (powershell -NoProfile -Command "Get-CimInstance Win32_Service | Where-Object {$_.StartMode -eq 'Auto' -and $_.State -ne 'Running'} | Format-Table Name,DisplayName,State,StartMode,ExitCode -Wrap" & goto PAUSE)
if "%choice%"=="7" (powershell -NoProfile -Command "Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice' -ErrorAction SilentlyContinue | Select-Object ProgId | Format-List" & goto PAUSE)
if "%choice%"=="8" (start "" appwiz.cpl & goto MENU)
if "%choice%"=="0" exit /b 0
echo Invalid selection.
timeout /t 2 >nul
goto MENU
:PAUSE
echo.
pause
goto MENU
