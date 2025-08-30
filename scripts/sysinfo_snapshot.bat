@echo off
setlocal enabledelayedexpansion

:: Always run relative to this script's folder (i.e., ...\scripts\)
cd /d "%~dp0"

:: ISO-style timestamp (locale-proof)
for /f %%i in ('powershell -NoProfile -Command "(Get-Date).ToString(\"yyyy-MM-dd_HH-mm-ss\")"') do set "_stamp=%%i"

:: Output folder under scripts\reports\<timestamp>
set "_out=%~dp0reports\%_stamp%"
mkdir "%_out%" 2>nul

echo Collecting systeminfo...
systeminfo > "%_out%\systeminfo.txt"

echo Collecting ipconfig...
ipconfig /all > "%_out%\ipconfig_all.txt"

echo Collecting installed hotfixes...
wmic qfe list full /format:list > "%_out%\hotfixes.txt"

echo Collecting disks...
wmic logicaldisk get caption,description,freespace,size,filesystem > "%_out%\disks.txt"

echo Done. Output: %_out%
endlocal
