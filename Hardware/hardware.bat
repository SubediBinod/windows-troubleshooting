@echo off
setlocal EnableExtensions
title Hardware Diagnostics

:MENU
cls
echo ============================================================
echo                    HARDWARE DIAGNOSTICS
echo ============================================================
echo [1] Computer model, manufacturer and BIOS
echo [2] CPU and memory summary
echo [3] Physical memory modules
echo [4] Battery report (laptops)
echo [5] Plug and Play devices with problem status
echo [6] Display adapters
echo [7] Disk device models and status
echo [8] Open Device Manager
echo [0] Back
echo.
set "choice="
set /p "choice=Select: "
if "%choice%"=="1" (powershell -NoProfile -Command "Get-CimInstance Win32_ComputerSystem | Format-List Manufacturer,Model,SystemType; Get-CimInstance Win32_BIOS | Format-List Manufacturer,SMBIOSBIOSVersion,ReleaseDate" & goto PAUSE)
if "%choice%"=="2" (powershell -NoProfile -Command "Get-CimInstance Win32_Processor | Format-Table Name,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed -Auto; Get-CimInstance Win32_OperatingSystem | Select-Object @{N='TotalRAM_GB';E={[math]::Round($_.TotalVisibleMemorySize/1MB,2)}},@{N='FreeRAM_GB';E={[math]::Round($_.FreePhysicalMemory/1MB,2)}} | Format-List" & goto PAUSE)
if "%choice%"=="3" (powershell -NoProfile -Command "Get-CimInstance Win32_PhysicalMemory | Format-Table BankLabel,Manufacturer,PartNumber,@{N='CapacityGB';E={[math]::Round($_.Capacity/1GB,2)}},Speed -Auto" & goto PAUSE)
if "%choice%"=="4" (powercfg /batteryreport & goto PAUSE)
if "%choice%"=="5" (powershell -NoProfile -Command "Get-CimInstance Win32_PnPEntity | Where-Object {$_.ConfigManagerErrorCode -ne 0} | Format-Table Name,ConfigManagerErrorCode,Status -Auto" & goto PAUSE)
if "%choice%"=="6" (powershell -NoProfile -Command "Get-CimInstance Win32_VideoController | Format-Table Name,DriverVersion,VideoModeDescription -Auto" & goto PAUSE)
if "%choice%"=="7" (powershell -NoProfile -Command "Get-CimInstance Win32_DiskDrive | Format-Table Model,InterfaceType,MediaType,Status,@{N='SizeGB';E={[math]::Round($_.Size/1GB,1)}} -Auto" & goto PAUSE)
if "%choice%"=="8" (start "" devmgmt.msc & goto MENU)
if "%choice%"=="0" exit /b 0
echo Invalid selection.
timeout /t 2 >nul
goto MENU
:PAUSE
echo.
pause
goto MENU
