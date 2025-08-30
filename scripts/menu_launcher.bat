@echo off
title Project Tools Menu
mode con: cols=80 lines=25
color 0A

:: Change working directory to the folder where this script lives
cd /d "%~dp0"

:menu
cls
echo ========================================================
echo                APonder - Project Tools
echo ========================================================
echo  1) System Info Snapshot
echo  X) Exit
echo.
set /p choice="Select: "

if /i "%choice%"=="1" call "%~dp0sysinfo_snapshot.bat" & pause & goto menu
if /i "%choice%"=="x" exit /b

goto menu
