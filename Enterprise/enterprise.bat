@echo off
setlocal EnableExtensions
title Enterprise and Domain Diagnostics

:MENU
cls
echo ============================================================
echo           ENTERPRISE, DOMAIN AND POLICY DIAGNOSTICS
echo ============================================================
echo [1] Domain/workgroup membership
echo [2] Group Policy summary
echo [3] Generate Group Policy HTML report on Desktop
echo [4] Microsoft Entra ID / device registration status
echo [5] DNS and domain controller locator test
echo [6] Secure channel test (domain joined devices)
echo [7] Current user token and groups
echo [8] Mapped drives and network connections
echo [9] Windows firewall profiles
echo [10] Windows event logs for Group Policy errors (7 days)
echo [0] Back
echo.
set "choice="
set /p "choice=Select: "
if "%choice%"=="1" (systeminfo | findstr /I /C:"Domain" /C:"Workgroup" & powershell -NoProfile -Command "Get-CimInstance Win32_ComputerSystem | Format-List PartOfDomain,Domain,Workgroup" & goto PAUSE)
if "%choice%"=="2" (gpresult /r & goto PAUSE)
if "%choice%"=="3" (gpresult /h "%USERPROFILE%\Desktop\gpresult.html" /f & echo Report path: %USERPROFILE%\Desktop\gpresult.html & goto PAUSE)
if "%choice%"=="4" (dsregcmd /status & goto PAUSE)
if "%choice%"=="5" goto DCTEST
if "%choice%"=="6" (powershell -NoProfile -Command "if ((Get-CimInstance Win32_ComputerSystem).PartOfDomain) { Test-ComputerSecureChannel -Verbose } else { 'This computer does not report domain membership.' }" & goto PAUSE)
if "%choice%"=="7" (whoami /all & goto PAUSE)
if "%choice%"=="8" (net use & powershell -NoProfile -Command "Get-SmbConnection -ErrorAction SilentlyContinue | Format-Table ServerName,ShareName,UserName,Dialect,NumOpens -Auto" & goto PAUSE)
if "%choice%"=="9" (powershell -NoProfile -Command "Get-NetFirewallProfile | Format-Table Name,Enabled,DefaultInboundAction,DefaultOutboundAction -Auto" & goto PAUSE)
if "%choice%"=="10" (powershell -NoProfile -Command "Get-WinEvent -FilterHashtable @{LogName='System';StartTime=(Get-Date).AddDays(-7)} -MaxEvents 500 -ErrorAction SilentlyContinue | Where-Object {$_.ProviderName -match 'GroupPolicy|Netlogon|DNS Client|Kerberos'} | Select-Object TimeCreated,Id,ProviderName,LevelDisplayName,Message | Format-List" & goto PAUSE)
if "%choice%"=="0" exit /b 0
echo Invalid selection.
timeout /t 2 >nul
goto MENU

:DCTEST
set "domain="
set /p "domain=Enter your organization's domain (for example corp.example): "
if not defined domain goto MENU
nslookup "%domain%"
nltest /dsgetdc:"%domain%"
goto PAUSE

:PAUSE
echo.
echo Some commands need domain access or administrator rights. Redact reports before sharing.
pause
goto MENU
