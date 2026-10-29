@echo off
setlocal EnableExtensions
title Security Diagnostics

:MENU
cls
echo ============================================================
echo                  SECURITY DIAGNOSTICS
echo ============================================================
echo [1] Microsoft Defender status (if available)
echo [2] Windows Firewall profiles
echo [3] Local account names
echo [4] Current user and groups
echo [5] Pending reboot indicators
echo [6] Open Windows Security
echo [0] Back
echo.
set "choice="
set /p "choice=Select: "
if "%choice%"=="1" (powershell -NoProfile -Command "if (Get-Command Get-MpComputerStatus -ErrorAction SilentlyContinue) { Get-MpComputerStatus | Select-Object AMServiceEnabled,AntivirusEnabled,AntispywareEnabled,RealTimeProtectionEnabled,QuickScanAge,FullScanAge | Format-List } else { Write-Host 'Defender status cmdlet unavailable on this system.' }" & goto PAUSE)
if "%choice%"=="2" (powershell -NoProfile -Command "Get-NetFirewallProfile | Format-Table Name,Enabled,DefaultInboundAction,DefaultOutboundAction -Auto" & goto PAUSE)
if "%choice%"=="3" (net user & goto PAUSE)
if "%choice%"=="4" (whoami /all & goto PAUSE)
if "%choice%"=="5" (powershell -NoProfile -Command "$p=@('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending','HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired'); foreach($k in $p){[pscustomobject]@{Path=$k;Present=[bool](Test-Path $k)}}; try { $v=(Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name PendingFileRenameOperations -ErrorAction Stop).PendingFileRenameOperations; 'PendingFileRenameOperations present: ' + [bool]$v } catch { 'PendingFileRenameOperations present: False or inaccessible' }" & goto PAUSE)
if "%choice%"=="6" (start "" windowsdefender: & goto MENU)
if "%choice%"=="0" exit /b 0
echo Invalid selection.
timeout /t 2 >nul
goto MENU
:PAUSE
echo.
pause
goto MENU
