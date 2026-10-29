@echo off
setlocal EnableExtensions
title Power and Sleep Diagnostics

:MENU
cls
echo ============================================================
echo                POWER AND SLEEP DIAGNOSTICS
echo ============================================================
echo [1] Active power scheme
echo [2] Available sleep states and blockers
echo [3] Last wake source
echo [4] Devices allowed to wake computer
echo [5] Battery report (laptops)
echo [6] Energy efficiency report (may require admin)
echo [7] Power requests preventing sleep
echo [8] Open Power Options
echo [0] Back
echo.
set "choice="
set /p "choice=Select: "
if "%choice%"=="1" (powercfg /getactivescheme & goto PAUSE)
if "%choice%"=="2" (powercfg /a & goto PAUSE)
if "%choice%"=="3" (powercfg /lastwake & goto PAUSE)
if "%choice%"=="4" (powercfg /devicequery wake_armed & goto PAUSE)
if "%choice%"=="5" (powercfg /batteryreport & goto PAUSE)
if "%choice%"=="6" (echo This generates an HTML report and may require administrator rights. & powercfg /energy /duration 60 & goto PAUSE)
if "%choice%"=="7" (powercfg /requests & goto PAUSE)
if "%choice%"=="8" (start "" powercfg.cpl & goto MENU)
if "%choice%"=="0" exit /b 0
echo Invalid selection.
timeout /t 2 >nul
goto MENU
:PAUSE
echo.
pause
goto MENU
