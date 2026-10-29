@echo off
setlocal EnableExtensions
title Windows System Information

cls
echo ============================================================
echo                  WINDOWS SYSTEM INFORMATION
echo ============================================================
echo.
echo Computer name:
hostname
echo.
echo Windows version:
ver
echo.
echo Logged-in user:
whoami
echo.
echo ============================================================
echo             DEVICE SERIAL AND HARDWARE IDENTIFIERS
echo ============================================================
echo.
echo Manufacturer and model:
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$c = Get-CimInstance Win32_ComputerSystem; Write-Host ('Manufacturer : ' + $c.Manufacturer); Write-Host ('Model        : ' + $c.Model)"
echo.
echo Computer serial number:
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$s = (Get-CimInstance Win32_BIOS).SerialNumber; if ($s -and $s.Trim() -notmatch 'To be filled by O.E.M.|Default string|System Serial Number|Unknown|Not Applicable') { Write-Host $s.Trim() } else { Write-Host 'Serial number unavailable or not populated by firmware.' }"
echo.
echo BIOS version and release date:
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$b = Get-CimInstance Win32_BIOS; Write-Host ('BIOS version : ' + ($b.SMBIOSBIOSVersion -join ', ')); Write-Host ('BIOS date    : ' + $b.ReleaseDate)"
echo.
echo Baseboard (motherboard) details:
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$b = Get-CimInstance Win32_BaseBoard; Write-Host ('Manufacturer : ' + $b.Manufacturer); Write-Host ('Product      : ' + $b.Product); if ($b.SerialNumber) { Write-Host ('Serial number: ' + $b.SerialNumber.Trim()) } else { Write-Host 'Serial number: Not reported by firmware.' }"
echo.
echo Note: Some custom-built PCs or firmware may return blank, generic, or inaccurate serial numbers.
echo.
echo System summary:
systeminfo
echo.
echo Tip: systeminfo can take a little while to finish.
echo.
pause
endlocal
exit /b 0
