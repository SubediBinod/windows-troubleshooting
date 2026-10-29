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
echo System summary:
systeminfo
echo.
echo Tip: systeminfo can take a little while to finish.
echo.
pause
endlocal
exit /b 0
