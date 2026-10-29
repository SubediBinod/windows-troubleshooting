@echo off
setlocal EnableExtensions
title BINOD SUBEDI - WINDOWS TROUBLESHOOTING TOOLKIT
color 0B

:MENU
cls
echo ============================================================
echo       BINOD SUBEDI ^| WINDOWS TROUBLESHOOTING TOOLKIT
echo ============================================================
echo.
echo   [1] Network diagnostics
echo   [2] System information
echo   [3] Open Windows network settings
echo   [4] Open Device Manager
echo   [5] Open Event Viewer
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
    start "" ms-settings:network
    goto MENU
)
if "%choice%"=="4" (
    start "" devmgmt.msc
    goto MENU
)
if "%choice%"=="5" (
    start "" eventvwr.msc
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
