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
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "try { $c = Get-CimInstance Win32_ComputerSystem -ErrorAction Stop; Write-Host ('Manufacturer : ' + $c.Manufacturer); Write-Host ('Model        : ' + $c.Model) } catch { Write-Host 'Could not read manufacturer/model through CIM.' }"
echo.
echo Computer serial number:
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "try { $s = (Get-CimInstance Win32_BIOS -ErrorAction Stop).SerialNumber; if ([string]::IsNullOrWhiteSpace($s) -or $s.Trim() -match '^(To be filled by O\.E\.M\.|Default string|System Serial Number|None|Unknown|Not Applicable)
echo.
echo Tip: systeminfo can take a little while to finish.
echo.
pause
endlocal
exit /b 0
) { Write-Host 'Serial number is blank or not populated by the manufacturer.' } else { Write-Host $s.Trim() } } catch { Write-Host 'Could not read BIOS serial number through CIM.' }"
echo.
echo BIOS version and release date:
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "try { $b = Get-CimInstance Win32_BIOS -ErrorAction Stop; Write-Host ('BIOS version : ' + ($b.SMBIOSBIOSVersion -join ', ')); Write-Host ('BIOS date    : ' + $b.ReleaseDate) } catch { Write-Host 'Could not read BIOS details through CIM.' }"
echo.
echo Baseboard (motherboard) serial number:
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "try { $b = Get-CimInstance Win32_BaseBoard -ErrorAction Stop; Write-Host ('Manufacturer : ' + $b.Manufacturer); Write-Host ('Product      : ' + $b.Product); if ([string]::IsNullOrWhiteSpace($b.SerialNumber)) { Write-Host 'Serial number: Not reported by firmware.' } else { Write-Host ('Serial number: ' + $b.SerialNumber.Trim()) } } catch { Write-Host 'Could not read motherboard details through CIM.' }"
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
