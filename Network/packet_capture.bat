@echo off
setlocal EnableExtensions
title Packet Capture Diagnostics

:MENU
cls
echo ============================================================
echo            PACKET CAPTURE - BUILT-IN PKTMON
echo ============================================================
echo Captures can contain sensitive traffic metadata. Get authorization
echo before capturing traffic on work, school or shared networks.
echo Output is written to your Desktop. Capture is not started automatically.
echo.
echo [1] Check pktmon availability and syntax
echo [2] Start packet capture to Desktop (ETL)
echo [3] Stop packet capture
echo [4] Convert Desktop ETL to PCAPNG (if supported)
echo [5] Show pktmon counters
echo [6] Open Network Connections
echo [0] Back
echo.
set "choice="
set /p "choice=Select: "
if "%choice%"=="1" (pktmon help & goto PAUSE)
if "%choice%"=="2" goto STARTCAP
if "%choice%"=="3" (pktmon stop & goto PAUSE)
if "%choice%"=="4" goto CONVERT
if "%choice%"=="5" (pktmon counters & goto PAUSE)
if "%choice%"=="6" (start "" ncpa.cpl & goto MENU)
if "%choice%"=="0" exit /b 0
echo Invalid selection.
timeout /t 2 >nul
goto MENU

:STARTCAP
echo.
echo Packet capture may require an elevated terminal.
echo Captures may contain device IPs, DNS names and traffic metadata.
choice /C YN /M "Start packet capture now"
if errorlevel 2 goto MENU
set "CAPFILE=%USERPROFILE%\Desktop\windows-packet-capture.etl"
pktmon start --capture --pkt-size 0 --file-name "%CAPFILE%"
echo.
echo If pktmon reports unsupported syntax, run option 1 and use the syntax shown by your Windows version.
echo Reopen this menu and select option 3 to stop capture.
pause
goto MENU

:CONVERT
set "CAPFILE=%USERPROFILE%\Desktop\windows-packet-capture.etl"
set "PCAPFILE=%USERPROFILE%\Desktop\windows-packet-capture.pcapng"
if not exist "%CAPFILE%" (
 echo No capture found at "%CAPFILE%".
 goto PAUSE
)
pktmon etl2pcap "%CAPFILE%" --out "%PCAPFILE%"
echo If conversion succeeded, open the PCAPNG in Wireshark for protocol-level inspection.
goto PAUSE

:PAUSE
echo.
pause
goto MENU
