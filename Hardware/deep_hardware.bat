@echo off
setlocal EnableExtensions
title Advanced Hardware Diagnostics

:MENU
cls
echo ============================================================
echo       ADVANCED MOTHERBOARD, CPU, RAM AND DISK DIAGNOSTICS
echo ============================================================
echo [1] Motherboard, BIOS and system board identification
echo [2] CPU model, cores, logical processors and current load
echo [3] RAM modules and slot occupancy (firmware-reported)
echo [4] Memory Diagnostic results from Windows event log
echo [5] Launch Windows Memory Diagnostic (RESTART REQUIRED)
echo [6] Disk health / reliability counters where supported
echo [7] Storage SMART failure-prediction status (if exposed)
echo [8] WHEA hardware error events (last 30 days)
echo [9] Disk and storage-related system events (last 7 days)
echo [10] BIOS time and Windows time status
echo [11] Open UEFI firmware settings (if supported)
echo [12] Open Device Manager
echo [0] Back
echo.
set "choice="
set /p "choice=Select: "
if "%choice%"=="1" (powershell -NoProfile -Command "Get-CimInstance Win32_BaseBoard | Format-List Manufacturer,Product,Version,SerialNumber; Get-CimInstance Win32_BIOS | Format-List Manufacturer,SMBIOSBIOSVersion,ReleaseDate,SerialNumber; Get-CimInstance Win32_ComputerSystem | Format-List Manufacturer,Model" & goto PAUSE)
if "%choice%"=="2" (powershell -NoProfile -Command "Get-CimInstance Win32_Processor | Format-List Name,Manufacturer,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed,CurrentClockSpeed,LoadPercentage,Status; Get-Counter '\Processor(_Total)\% Processor Time' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object CookedValue" & goto PAUSE)
if "%choice%"=="3" (powershell -NoProfile -Command "'Physical memory array:'; Get-CimInstance Win32_PhysicalMemoryArray | Format-Table MemoryDevices,MaxCapacity,MaxCapacityEx -Auto; 'Detected memory modules:'; Get-CimInstance Win32_PhysicalMemory | Format-Table DeviceLocator,BankLabel,Manufacturer,PartNumber,SerialNumber,@{N='CapacityGB';E={[math]::Round($_.Capacity/1GB,2)}},Speed,ConfiguredClockSpeed,DataWidth,TotalWidth -Wrap; 'Note: firmware may not report empty slots accurately.' " & goto PAUSE)
if "%choice%"=="4" (powershell -NoProfile -Command "Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-MemoryDiagnostics-Results/Debug';StartTime=(Get-Date).AddYears(-2)} -MaxEvents 20 -ErrorAction SilentlyContinue | Select-Object TimeCreated,Id,Message | Format-List; Get-WinEvent -FilterHashtable @{LogName='System';ProviderName='Microsoft-Windows-MemoryDiagnostics-Results';StartTime=(Get-Date).AddYears(-2)} -MaxEvents 20 -ErrorAction SilentlyContinue | Select-Object TimeCreated,Id,Message | Format-List" & goto PAUSE)
if "%choice%"=="5" goto MEMTEST
if "%choice%"=="6" (powershell -NoProfile -Command "if (Get-Command Get-PhysicalDisk -ErrorAction SilentlyContinue) { Get-PhysicalDisk | Format-List FriendlyName,SerialNumber,MediaType,BusType,HealthStatus,OperationalStatus,Usage,Size; Get-PhysicalDisk | Get-StorageReliabilityCounter -ErrorAction SilentlyContinue | Format-List * } else { 'Storage cmdlets are unavailable on this Windows edition.' }" & goto PAUSE)
if "%choice%"=="7" (powershell -NoProfile -Command "Get-CimInstance -Namespace root\wmi -ClassName MSStorageDriver_FailurePredictStatus -ErrorAction SilentlyContinue | Format-Table InstanceName,PredictFailure,Reason -Wrap; 'No output does not prove a drive is healthy; many NVMe/RAID/storage drivers do not expose this interface.' " & goto PAUSE)
if "%choice%"=="8" (powershell -NoProfile -Command "Get-WinEvent -FilterHashtable @{LogName='System';ProviderName='Microsoft-Windows-WHEA-Logger';StartTime=(Get-Date).AddDays(-30)} -MaxEvents 100 -ErrorAction SilentlyContinue | Select-Object TimeCreated,Id,LevelDisplayName,Message | Format-List" & goto PAUSE)
if "%choice%"=="9" (powershell -NoProfile -Command "Get-WinEvent -FilterHashtable @{LogName='System';StartTime=(Get-Date).AddDays(-7)} -MaxEvents 500 -ErrorAction SilentlyContinue | Where-Object {$_.ProviderName -match 'disk|stor|nvme|ntfs|volmgr|iaStor|stornvme|storahci'} | Select-Object TimeCreated,Id,ProviderName,LevelDisplayName,Message | Format-List" & goto PAUSE)
if "%choice%"=="10" (powershell -NoProfile -Command "Get-CimInstance Win32_OperatingSystem | Select-Object LastBootUpTime,LocalDateTime | Format-List; w32tm /query /status" & goto PAUSE)
if "%choice%"=="11" (echo This opens firmware settings only if Windows and firmware support it. & shutdown /r /fw /t 0)
if "%choice%"=="12" (start "" devmgmt.msc & goto MENU)\nif "%choice%"=="13" goto CMOS
if "%choice%"=="0" exit /b 0
echo Invalid selection.
timeout /t 2 >nul
goto MENU

:MEMTEST
echo.
echo IMPORTANT: Windows Memory Diagnostic restarts the PC.
echo Save all work first. For serious RAM testing, a bootable test such as MemTest86
echo can test memory outside Windows and may find faults Windows Memory Diagnostic misses.
choice /C YN /M "Save your work and launch mdsched now"
if errorlevel 2 goto MENU
start "" mdsched.exe
goto MENU

:PAUSE
echo.
echo A blank result can mean unsupported hardware/driver reporting, not a clean bill of health.
pause
goto MENU
