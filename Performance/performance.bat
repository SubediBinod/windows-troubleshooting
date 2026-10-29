@echo off
setlocal EnableExtensions
title Performance Diagnostics

:MENU
cls
echo ============================================================
echo                 PERFORMANCE DIAGNOSTICS
echo ============================================================
echo [1] Top processes by CPU time
echo [2] Top processes by memory use
echo [3] Memory and virtual memory counters
echo [4] Startup commands
echo [5] Running processes with executable paths
echo [6] Open Resource Monitor
echo [7] Open Task Manager
echo [0] Back
echo.
set "choice="
set /p "choice=Select: "
if "%choice%"=="1" (powershell -NoProfile -Command "Get-Process | Sort-Object CPU -Descending | Select-Object -First 20 Name,Id,CPU,StartTime | Format-Table -Auto" & goto PAUSE)
if "%choice%"=="2" (powershell -NoProfile -Command "Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 20 Name,Id,@{N='MemoryMB';E={[math]::Round($_.WorkingSet64/1MB,1)}} | Format-Table -Auto" & goto PAUSE)
if "%choice%"=="3" (powershell -NoProfile -Command "Get-CimInstance Win32_OperatingSystem | Select-Object @{N='TotalRAM_GB';E={[math]::Round($_.TotalVisibleMemorySize/1MB,2)}},@{N='FreeRAM_GB';E={[math]::Round($_.FreePhysicalMemory/1MB,2)}},@{N='VirtualMemoryFree_GB';E={[math]::Round($_.FreeVirtualMemory/1MB,2)}} | Format-List" & goto PAUSE)
if "%choice%"=="4" (powershell -NoProfile -Command "Get-CimInstance Win32_StartupCommand | Format-Table Name,Location,Command -Wrap" & goto PAUSE)
if "%choice%"=="5" (powershell -NoProfile -Command "Get-Process | Select-Object -First 60 Name,Id,Path | Format-Table -Wrap" & goto PAUSE)
if "%choice%"=="6" (start "" resmon.exe & goto MENU)
if "%choice%"=="7" (start "" taskmgr.exe & goto MENU)
if "%choice%"=="0" exit /b 0
echo Invalid selection.
timeout /t 2 >nul
goto MENU
:PAUSE
echo.
pause
goto MENU
