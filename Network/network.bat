@echo off
setlocal EnableExtensions
title Network Diagnostics

:MENU
cls
echo ============================================================
echo                    NETWORK DIAGNOSTICS
echo ============================================================
echo.
echo   [1] Show IP configuration
echo   [2] Test internet connectivity (ping)
echo   [3] Test DNS resolution (nslookup)
echo   [4] Trace route to a host
echo   [5] Flush DNS resolver cache
echo   [6] Show saved Wi-Fi profile names
echo   [7] Show active network connections
echo   [8] Advanced network configuration
echo.
echo   [0] Back to main menu
echo.
set "choice="
set /p "choice=Select an option: "

if "%choice%"=="1" (ipconfig /all & goto PAUSE)
if "%choice%"=="2" goto PING
if "%choice%"=="3" goto DNS
if "%choice%"=="4" goto TRACE
if "%choice%"=="5" goto FLUSHDNS
if "%choice%"=="6" goto WIFI
if "%choice%"=="7" (netstat -ano & goto PAUSE)
if "%choice%"=="8" (call "%~dp0network_deep.bat" & goto MENU)
if "%choice%"=="0" exit /b 0

echo Invalid selection.
timeout /t 2 /nobreak >nul
goto MENU

:PING
echo.
set "host="
set /p "host=Host to ping [default: 1.1.1.1]: "
if not defined host set "host=1.1.1.1"
ping -n 4 "%host%"
goto PAUSE

:DNS
echo.
set "host="
set /p "host=Domain to resolve [default: example.com]: "
if not defined host set "host=example.com"
nslookup "%host%"
goto PAUSE

:TRACE
echo.
set "host="
set /p "host=Host to trace [default: 1.1.1.1]: "
if not defined host set "host=1.1.1.1"
tracert "%host%"
goto PAUSE

:FLUSHDNS
echo.
echo This clears the local DNS resolver cache. It does not change DNS server settings.
ipconfig /flushdns
goto PAUSE

:WIFI
echo.
echo Wi-Fi profile names only. Passwords are not displayed.
netsh wlan show profiles
goto PAUSE

:PAUSE
echo.
pause
goto MENU
