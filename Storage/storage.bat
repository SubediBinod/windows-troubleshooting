@echo off
setlocal EnableExtensions
title Storage Diagnostics

:MENU
cls
echo ============================================================
echo                    STORAGE DIAGNOSTICS
echo ============================================================
echo [1] Logical drive free space
echo [2] Physical disk health summary (where supported)
echo [3] Volume and file system details
echo [4] Check disk online scan (read-only scan request)
echo [5] Open Disk Management
echo [6] Open Optimize Drives
echo [0] Back
echo.
set "choice="
set /p "choice=Select: "
if "%choice%"=="1" (powershell -NoProfile -Command "Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' | Select-Object DeviceID,VolumeName,FileSystem,@{N='SizeGB';E={[math]::Round($_.Size/1GB,1)}},@{N='FreeGB';E={[math]::Round($_.FreeSpace/1GB,1)}},@{N='FreePercent';E={[math]::Round($_.FreeSpace/$_.Size*100,1)}} | Format-Table -Auto" & goto PAUSE)
if "%choice%"=="2" (powershell -NoProfile -Command "if (Get-Command Get-PhysicalDisk -ErrorAction SilentlyContinue) { Get-PhysicalDisk | Format-Table FriendlyName,MediaType,HealthStatus,OperationalStatus,Size -Auto } else { Write-Host 'Get-PhysicalDisk is not available on this Windows edition.' }" & goto PAUSE)
if "%choice%"=="3" (powershell -NoProfile -Command "Get-Volume | Format-Table DriveLetter,FileSystemLabel,FileSystem,HealthStatus,OperationalStatus,@{N='SizeGB';E={[math]::Round($_.Size/1GB,1)}},@{N='FreeGB';E={[math]::Round($_.SizeRemaining/1GB,1)}} -Auto" & goto PAUSE)
if "%choice%"=="4" (echo This requests an online scan of drive C:. It does not request offline repair. & chkdsk C: /scan & goto PAUSE)
if "%choice%"=="5" (start "" diskmgmt.msc & goto MENU)
if "%choice%"=="6" (start "" dfrgui.exe & goto MENU)
if "%choice%"=="0" exit /b 0
echo Invalid selection.
timeout /t 2 >nul
goto MENU
:PAUSE
echo.
pause
goto MENU
