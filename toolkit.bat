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
echo.
echo   [9] Open Windows network settings
echo  [10] Open Device Manager
echo  [11] Open Event Viewer
echo  [12] Open Task Manager
echo  [13] Open Resource Monitor
echo.
echo   [0] Exit
echo.
set "choice="
set /p "choice=Select an option: "

if "%choice%"=="1" (
    call "%~dp0Network\network.bat"
    goto MENU
)
if "%choice%"=="2" (
    call "%~dp0Windows\system_info.bat"
    goto MENU
)
if "%choice%"=="3" (
    call "%~dp0Hardware\hardware.bat"
    goto MENU
)
if "%choice%"=="4" (
    call "%~dp0Storage\storage.bat"
    goto MENU
)
if "%choice%"=="5" (
    call "%~dp0Performance\performance.bat"
    goto MENU
)
if "%choice%"=="6" (
    call "%~dp0Windows\windows_health.bat"
    goto MENU
)
if "%choice%"=="7" (
    call "%~dp0Security\security.bat"
    goto MENU
)
if "%choice%"=="8" (
    call "%~dp0Processes\services.bat"
    goto MENU
)
if "%choice%"=="9" (
    start "" ms-settings:network
    goto MENU
)
if "%choice%"=="10" (
    start "" devmgmt.msc
    goto MENU
)
if "%choice%"=="11" (
    start "" eventvwr.msc
    goto MENU
)
if "%choice%"=="12" (
    start "" taskmgr.exe
    goto MENU
)
if "%choice%"=="13" (
    start "" resmon.exe
    goto MENU
)
if "%choice%"=="0" goto END

echo.
echo Invalid selection. Please choose one of the listed options.
timeout /t 2 /nobreak >nul
goto MENU

:END
endlocal
exit /b 0
