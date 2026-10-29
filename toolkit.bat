@echo off
setlocal EnableExtensions
title BINOD SUBEDI - WINDOWS TROUBLESHOOTING TOOLKIT
color 0B

:MENU
cls
echo ==================================================================
echo          BINOD SUBEDI ^| WINDOWS TROUBLESHOOTING TOOLKIT
echo ==================================================================
echo.
echo   [1] Network diagnostics
echo   [2] System information
echo   [3] Hardware and devices
echo   [4] Storage and drives
echo   [5] Performance and startup
echo   [6] Windows health and update diagnostics
echo   [7] Security status
echo   [8] Services, processes and ports
echo   [9] Advanced network configuration
echo  [10] Printers, audio, Bluetooth, USB and cameras
echo  [11] Applications, drivers and scheduled tasks
echo  [12] Event logs and crash diagnostics
echo  [13] Power, sleep and battery
echo.
echo  [20] Open Windows network settings
echo  [21] Open Device Manager
echo  [22] Open Event Viewer
echo  [23] Open Task Manager
echo  [24] Open Resource Monitor
echo  [25] Open Reliability Monitor
echo.
echo   [0] Exit
echo.
set "choice="
set /p "choice=Select an option: "

if "%choice%"=="1" (call "%~dp0Network\network.bat" & goto MENU)
if "%choice%"=="2" (call "%~dp0Windows\system_info.bat" & goto MENU)
if "%choice%"=="3" (call "%~dp0Hardware\hardware.bat" & goto MENU)
if "%choice%"=="4" (call "%~dp0Storage\storage.bat" & goto MENU)
if "%choice%"=="5" (call "%~dp0Performance\performance.bat" & goto MENU)
if "%choice%"=="6" (call "%~dp0Windows\windows_health.bat" & goto MENU)
if "%choice%"=="7" (call "%~dp0Security\security.bat" & goto MENU)
if "%choice%"=="8" (call "%~dp0Processes\services.bat" & goto MENU)
if "%choice%"=="9" (call "%~dp0Network\network_deep.bat" & goto MENU)
if "%choice%"=="10" (call "%~dp0Peripherals\peripherals.bat" & goto MENU)
if "%choice%"=="11" (call "%~dp0Applications\apps_tasks.bat" & goto MENU)
if "%choice%"=="12" (call "%~dp0Logs\logs.bat" & goto MENU)
if "%choice%"=="13" (call "%~dp0Power\power.bat" & goto MENU)
if "%choice%"=="20" (start "" ms-settings:network & goto MENU)
if "%choice%"=="21" (start "" devmgmt.msc & goto MENU)
if "%choice%"=="22" (start "" eventvwr.msc & goto MENU)
if "%choice%"=="23" (start "" taskmgr.exe & goto MENU)
if "%choice%"=="24" (start "" resmon.exe & goto MENU)
if "%choice%"=="25" (start "" perfmon.exe /rel & goto MENU)
if "%choice%"=="0" goto END

echo.
echo Invalid selection. Please choose one of the listed options.
timeout /t 2 /nobreak >nul
goto MENU

:END
endlocal
exit /b 0
