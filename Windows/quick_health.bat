@echo off
setlocal EnableExtensions
title Quick Health Check - Binod Subedi
echo.
echo Starting a quick, read-only Windows health sweep...
echo This checks connectivity, DNS, CPU/RAM pressure, system-drive space,
echo available disk health indicators, key services, Defender/firewall
echo visibility, and recent critical/shutdown events.
echo.
echo It does NOT repair, clean, stress-test, capture traffic, or restart.
echo Some results may be unavailable on managed or older Windows systems.
echo.
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0quick_health.ps1"
if errorlevel 1 (
  echo.
  echo Quick Health Check ended with an error. Confirm PowerShell is available.
  pause
)
exit /b
