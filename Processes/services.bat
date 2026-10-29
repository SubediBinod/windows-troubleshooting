@echo off
setlocal EnableExtensions
title Services and Process Diagnostics

:MENU
cls
echo ============================================================
echo              SERVICES AND PROCESS DIAGNOSTICS
echo ============================================================
echo [1] Failed or stopped automatic services
echo [2] Search services by name
echo [3] Service details for a supplied service name
echo [4] Listening TCP ports and owning process IDs
echo [5] Map process IDs to process names
echo [6] Open Services console
echo [0] Back
echo.
set "choice="
set /p "choice=Select: "
if "%choice%"=="1" (powershell -NoProfile -Command "Get-CimInstance Win32_Service | Where-Object {$_.StartMode -eq 'Auto' -and $_.State -ne 'Running' -and $_.StartName -notmatch 'LocalSystem'} | Format-Table Name,DisplayName,State,StartMode,StartName -Auto" & goto PAUSE)
if "%choice%"=="2" (set "term=" & set /p "term=Enter part of service name or display name: " & powershell -NoProfile -Command "$t=$env:term; Get-Service | Where-Object {$_.Name -like ('*'+$t+'*') -or $_.DisplayName -like ('*'+$t+'*')} | Format-Table Name,DisplayName,Status -Auto" & goto PAUSE)
if "%choice%"=="3" (set "svc=" & set /p "svc=Enter exact service name (for example Spooler): " & powershell -NoProfile -Command "$n=$env:svc; Get-CimInstance Win32_Service -Filter ('Name='''+$n+'''') | Format-List Name,DisplayName,State,StartMode,StartName,PathName,ExitCode" & goto PAUSE)
if "%choice%"=="4" (netstat -abno & goto PAUSE)
if "%choice%"=="5" (tasklist /svc & goto PAUSE)
if "%choice%"=="6" (start "" services.msc & goto MENU)
if "%choice%"=="0" exit /b 0
echo Invalid selection.
timeout /t 2 >nul
goto MENU
:PAUSE
echo.
pause
goto MENU
