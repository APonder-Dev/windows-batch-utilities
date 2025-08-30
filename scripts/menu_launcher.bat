@echo off
title Project Tools Menu
mode con: cols=80 lines=25
color 0A

:: Always run relative to this script's folder
cd /d "%~dp0"

:menu
cls
echo ========================================================
echo                APonder - Project Tools
echo ========================================================
echo  1) System Info Snapshot
echo  2) Network Quick Diag
echo  X) Exit
echo.
set /p choice="Select: "

if /i "%choice%"=="1" call "%~dp0sysinfo_snapshot.bat" & pause & goto menu
if /i "%choice%"=="2" call "%~dp0net_quickdiag.bat" & pause & goto menu
if /i "%choice%"=="x" exit /b

goto menu
