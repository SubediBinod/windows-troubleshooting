@echo off
setlocal EnableExtensions
title Defensive Malware Triage

:MENU
cls
echo ============================================================
echo           DEFENSIVE MALWARE TRIAGE AND FORENSICS
echo ============================================================
echo These checks are triage aids, not a complete forensic investigation.
echo On a suspected compromise, avoid deleting files or clearing logs.
echo [1] Defender status and signature freshness
echo [2] Defender detections and protection history (where available)
echo [3] Defender exclusions (review carefully)
echo [4] Current network connections with owning process
echo [5] Running processes and executable paths
echo [6] Unsigned or unusual drivers (inventory, not proof of malware)
echo [7] Scheduled tasks and action commands
echo [8] Common Run-key persistence locations (read-only)
echo [9] Recent Defender operational events
echo [10] Launch Microsoft Defender Offline scan (RESTARTS PC)
echo [11] Open Windows Security
echo [0] Back
echo.
set "choice="
set /p "choice=Select: "
if "%choice%"=="1" (powershell -NoProfile -Command "Get-MpComputerStatus -ErrorAction SilentlyContinue | Format-List AMServiceEnabled,AntivirusEnabled,RealTimeProtectionEnabled,AntivirusSignatureVersion,AntivirusSignatureLastUpdated,QuickScanAge,FullScanAge" & goto PAUSE)
if "%choice%"=="2" (powershell -NoProfile -Command "Get-MpThreatDetection -ErrorAction SilentlyContinue | Select-Object InitialDetectionTime,ThreatID,ActionSuccess,Resources,ProcessName | Format-List" & goto PAUSE)
if "%choice%"=="3" (powershell -NoProfile -Command "Get-MpPreference -ErrorAction SilentlyContinue | Format-List ExclusionPath,ExclusionExtension,ExclusionProcess,ExclusionIpAddress" & goto PAUSE)
if "%choice%"=="4" (powershell -NoProfile -Command "Get-NetTCPConnection -ErrorAction SilentlyContinue | ForEach-Object {$p=Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue; [pscustomobject]@{State=$_.State;LocalAddress=$_.LocalAddress;LocalPort=$_.LocalPort;RemoteAddress=$_.RemoteAddress;RemotePort=$_.RemotePort;PID=$_.OwningProcess;Process=$p.ProcessName;Path=$p.Path}} | Sort-Object State,Process | Format-Table -Wrap" & goto PAUSE)
if "%choice%"=="5" (powershell -NoProfile -Command "Get-CimInstance Win32_Process | Select-Object ProcessId,ParentProcessId,Name,ExecutablePath,CommandLine | Format-List" & goto PAUSE)
if "%choice%"=="6" (powershell -NoProfile -Command "Get-CimInstance Win32_SystemDriver | Select-Object Name,State,StartMode,PathName,ServiceType | Format-Table -Wrap; 'This is an inventory only. Validate driver signatures and paths before drawing conclusions.' " & goto PAUSE)
if "%choice%"=="7" (powershell -NoProfile -Command "Get-ScheduledTask -ErrorAction SilentlyContinue | ForEach-Object {$t=$_; foreach($a in $t.Actions){[pscustomobject]@{TaskPath=$t.TaskPath;TaskName=$t.TaskName;State=$t.State;Execute=$a.Execute;Arguments=$a.Arguments}}} | Format-Table -Wrap" & goto PAUSE)
if "%choice%"=="8" (powershell -NoProfile -Command "$paths=@('HKCU:\Software\Microsoft\Windows\CurrentVersion\Run','HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce','HKLM:\Software\Microsoft\Windows\CurrentVersion\Run','HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce','HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Run'); foreach($p in $paths){if(Test-Path $p){Write-Host ('--- '+$p); Get-ItemProperty $p | Format-List *}}" & goto PAUSE)
if "%choice%"=="9" (powershell -NoProfile -Command "Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-Windows Defender/Operational';StartTime=(Get-Date).AddDays(-14)} -MaxEvents 100 -ErrorAction SilentlyContinue | Select-Object TimeCreated,Id,LevelDisplayName,Message | Format-List" & goto PAUSE)
if "%choice%"=="10" goto OFFLINE
if "%choice%"=="11" (start "" windowsdefender: & goto MENU)
if "%choice%"=="0" exit /b 0
echo Invalid selection.
timeout /t 2 >nul
goto MENU

:OFFLINE
echo.
echo WARNING: This starts an offline Defender scan and restarts the computer.
echo Save all work. Do not use if immediate reboot would interrupt critical work.
choice /C YN /M "Save your work and start Defender Offline now"
if errorlevel 2 goto MENU
powershell -NoProfile -Command "Start-MpWDOScan"
goto MENU

:PAUSE
echo.
echo Treat suspicious results as leads, not proof. For serious incidents preserve evidence and contact your security team.
pause
goto MENU
