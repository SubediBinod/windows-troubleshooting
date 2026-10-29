@echo off
setlocal EnableExtensions
title Advanced Network Diagnostics

:MENU
cls
echo ============================================================
echo               ADVANCED NETWORK DIAGNOSTICS
echo ============================================================
echo [1] Network adapters and link status
echo [2] IP addresses, gateways and DNS servers
echo [3] Routing table
echo [4] ARP neighbor cache
echo [5] DNS resolver cache
echo [6] Test TCP connection to host and port
echo [7] Proxy configuration
echo [8] Windows Firewall profile status
echo [9] Wi-Fi interface details
echo [10] Network-related driver details
echo [0] Back
echo.
set "choice="
set /p "choice=Select: "
if "%choice%"=="1" (powershell -NoProfile -Command "Get-NetAdapter -IncludeHidden | Format-Table Name,InterfaceDescription,Status,LinkSpeed,MacAddress,DriverVersion -Auto" & goto PAUSE)
if "%choice%"=="2" (powershell -NoProfile -Command "Get-NetIPConfiguration -Detailed | Format-List InterfaceAlias,InterfaceDescription,NetProfile,IPv4Address,IPv4DefaultGateway,DNSServer" & goto PAUSE)
if "%choice%"=="3" (route print & goto PAUSE)
if "%choice%"=="4" (arp -a & goto PAUSE)
if "%choice%"=="5" (ipconfig /displaydns & goto PAUSE)
if "%choice%"=="6" goto TCPTEST
if "%choice%"=="7" (netsh winhttp show proxy & powershell -NoProfile -Command "Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' | Select-Object ProxyEnable,ProxyServer,AutoConfigURL | Format-List" & goto PAUSE)
if "%choice%"=="8" (powershell -NoProfile -Command "Get-NetFirewallProfile | Format-Table Name,Enabled,DefaultInboundAction,DefaultOutboundAction -Auto" & goto PAUSE)
if "%choice%"=="9" (netsh wlan show interfaces & goto PAUSE)
if "%choice%"=="10" (powershell -NoProfile -Command "Get-CimInstance Win32_PnPSignedDriver | Where-Object {$_.DeviceClass -eq 'NET'} | Format-Table DeviceName,DriverVersion,DriverDate,Manufacturer -Wrap" & goto PAUSE)
if "%choice%"=="0" exit /b 0
echo Invalid selection.
timeout /t 2 >nul
goto MENU

:TCPTEST
echo.
set "host="
set /p "host=Hostname or IP address: "
if not defined host goto MENU
set "port="
set /p "port=TCP port (for example 443): "
if not defined port goto MENU
powershell -NoProfile -Command "Test-NetConnection -ComputerName $env:host -Port $env:port -InformationLevel Detailed"
goto PAUSE

:PAUSE
echo.
pause
goto MENU
