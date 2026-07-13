@echo off
setlocal enabledelayedexpansion

:: Always run relative to this script's folder (i.e., ...\scripts\)
cd /d "%~dp0"

:: ISO-style timestamp (locale-proof)
for /f "usebackq" %%i in (`powershell -NoProfile -Command "(Get-Date).ToString('yyyy-MM-dd_HH-mm-ss')"`) do set "_stamp=%%i"

:: Output folder under scripts\reports\<timestamp>
set "_out=%~dp0reports\%_stamp%"
mkdir "%_out%" 2>nul

echo ============================================================
echo                  System Info Snapshot
echo ============================================================
echo  Saving to: %_out%
echo ============================================================
echo.

echo [1/7] System Info...
systeminfo > "%_out%\systeminfo.txt"
echo       Saved.

echo [2/7] Network Config...
ipconfig /all > "%_out%\ipconfig_all.txt"
echo       Saved.

echo [3/7] Installed Hotfixes...
powershell -NoProfile -Command "Get-HotFix | Sort-Object InstalledOn -Descending -ErrorAction SilentlyContinue | Format-Table HotFixID, InstalledOn, Description -AutoSize" > "%_out%\hotfixes.txt" 2>nul
echo       Saved.

echo [4/7] Disk Usage...
powershell -NoProfile -Command "Get-PSDrive -PSProvider FileSystem | Format-Table Name, @{N='Used(GB)';E={[math]::Round($_.Used/1GB,2)}}, @{N='Free(GB)';E={[math]::Round($_.Free/1GB,2)}}, @{N='Total(GB)';E={[math]::Round(($_.Used+$_.Free)/1GB,2)}} -AutoSize" > "%_out%\disks.txt" 2>nul
echo       Saved.

echo [5/7] Running Processes (top 50 by RAM)...
powershell -NoProfile -Command "Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 50 | Format-Table Name, Id, @{N='CPU(s)';E={[math]::Round($_.CPU,1)}}, @{N='RAM(MB)';E={[math]::Round($_.WorkingSet/1MB,0)}} -AutoSize" > "%_out%\processes.txt" 2>nul
echo       Saved.

echo [6/7] Startup Programs...
powershell -NoProfile -Command "Get-CimInstance Win32_StartupCommand | Format-Table Name, Command, Location -AutoSize" > "%_out%\startup.txt" 2>nul
echo       Saved.

echo [7/7] System Uptime...
powershell -NoProfile -Command "$up = (Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime; 'Uptime: {0} days {1} hours {2} minutes' -f $up.Days, $up.Hours, $up.Minutes" > "%_out%\uptime.txt" 2>nul
echo       Saved.

echo.
echo ============================================================
echo  Done. Report saved to:
echo  %_out%
echo ============================================================
endlocal
