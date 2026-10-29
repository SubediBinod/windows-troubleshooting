@echo off
setlocal EnableExtensions
title BINOD SUBEDI - WINDOWS TROUBLESHOOTING TOOLKIT
color 0B

:WELCOME
cls
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0Windows\intro_animation.ps1"
if errorlevel 1 (
    echo.
    echo Welcome to the Windows Troubleshooting Toolkit.
    echo Run this toolkit on a Windows system with PowerShell available.
)
echo.
pause

:MENU
cls
echo ==================================================================
echo          BINOD SUBEDI ^| WINDOWS TROUBLESHOOTING TOOLKIT
echo ==================================================================
echo  PC: %COMPUTERNAME%   ^|   %DATE%   %TIME:~0,8%
echo ------------------------------------------------------------------
echo   [Q] QUICK HEALTH CHECK - fast system triage and report
echo   [R] GENERATE SUPPORT REPORT - broader diagnostic snapshot
echo.
echo   [1] Network diagnostics
echo   [2] System information
echo   [3] Hardware and devices
echo   [4] Storage and drives
echo   [5] Performance and startup
echo   [6] Windows health diagnostics
echo   [7] Security status
echo   [8] Services, processes and ports
echo   [9] Advanced network configuration
echo  [10] Printers, audio, Bluetooth, USB and cameras
echo  [11] Applications, drivers and scheduled tasks
echo  [12] Event logs and crash diagnostics
echo  [13] Power, sleep and battery
echo  [14] Windows Update diagnostics
echo  [15] Advanced motherboard, CPU, RAM and disk checks
echo  [16] OEM diagnostics and firmware guidance
echo  [17] Packet capture with Windows pktmon
echo  [18] Malware triage and forensic snapshots
echo  [19] Enterprise, domain and policy diagnostics
echo.
echo  [20] Open Windows network settings
echo  [21] Open Device Manager
echo  [22] Open Event Viewer
echo  [23] Open Task Manager
echo  [24] Open Resource Monitor
echo  [25] Open Reliability Monitor
echo  [26] Open System Information
echo.
echo   [0] Exit
echo.
set "choice="
set /p "choice=Select an option: "

if /i "%choice%"=="Q" (call "%~dp0Windows\quick_health.bat" & goto MENU)
if /i "%choice%"=="R" (call "%~dp0Reports\generate_report.bat" & goto MENU)
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
if "%choice%"=="14" (call "%~dp0Windows\update_diagnostics.bat" & goto MENU)
if "%choice%"=="15" (call "%~dp0Hardware\deep_hardware.bat" & goto MENU)
if "%choice%"=="16" (call "%~dp0Hardware\oem_tools.bat" & goto MENU)
if "%choice%"=="17" (call "%~dp0Network\packet_capture.bat" & goto MENU)
if "%choice%"=="18" (call "%~dp0Security\forensics.bat" & goto MENU)
if "%choice%"=="19" (call "%~dp0Enterprise\enterprise.bat" & goto MENU)
if "%choice%"=="20" (start "" ms-settings:network & goto MENU)
if "%choice%"=="21" (start "" devmgmt.msc & goto MENU)
if "%choice%"=="22" (start "" eventvwr.msc & goto MENU)
if "%choice%"=="23" (start "" taskmgr.exe & goto MENU)
if "%choice%"=="24" (start "" resmon.exe & goto MENU)
if "%choice%"=="25" (start "" perfmon.exe /rel & goto MENU)
if "%choice%"=="26" (start "" msinfo32.exe & goto MENU)
if "%choice%"=="0" goto END

echo.
echo Invalid selection. Please choose one of the listed options.
timeout /t 2 /nobreak >nul
goto MENU

:END
endlocal
exit /b 0
