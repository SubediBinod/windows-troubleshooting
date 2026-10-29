@echo off
setlocal EnableExtensions
title Generate Windows Support Report - Binod Subedi
echo.
echo ================================================================
echo                 GENERATE SUPPORT REPORT
echo ================================================================
echo.
echo This collects a broad, read-only troubleshooting snapshot:
echo system/BIOS, CPU/RAM, adapters/IP/DNS/routes, TCP connections,
echo disks, top processes, services, Defender/firewall, installed
echo updates, and recent critical/error events.
echo.
echo IMPORTANT: the report can contain usernames, IP/MAC addresses,
echo domain details, process information and event messages.
echo Review and redact it before sharing.
echo.
echo No repair, cleanup, packet capture, or restart will be initiated.
echo.
pause
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0generate_report.ps1"
if errorlevel 1 (
  echo.
  echo Report generation returned an error. Check PowerShell availability.
  pause
)
exit /b
