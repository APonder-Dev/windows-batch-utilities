@echo off
setlocal enabledelayedexpansion
title Wi-Fi Profile Exporter

:: Admin check (needed for plain-text password export)
net session >nul 2>&1
if "%errorlevel%"=="0" (set "_admin=1") else (set "_admin=0")

echo ============================================================
echo                   Wi-Fi Profile Exporter
echo ============================================================
echo  Date : %date%   Time : %time:~0,8%
if "!_admin!"=="1" (
    echo  Mode : Administrator
) else (
    echo  Mode : Standard User  ^(password export unavailable^)
)
echo  Backs up every saved Wi-Fi profile to XML files, so you
echo  can restore them later with: netsh wlan add profile
echo ============================================================
echo.

:: --- Check for wireless profiles ---
netsh wlan show profiles >nul 2>&1
if errorlevel 1 (
    echo  [X] No wireless interface found, or the WLAN service is
    echo      not running. Nothing to export.
    goto :eof
)

set "_count=0"
echo  Saved profiles:
for /f "tokens=1,* delims=:" %%a in ('netsh wlan show profiles ^| findstr /c:"All User Profile"') do (
    set /a _count+=1
    echo    -%%b
)
if "!_count!"=="0" (
    echo    ^(none^)
    echo.
    echo  No saved Wi-Fi profiles on this machine. Nothing to export.
    goto :eof
)
echo.
echo  Found !_count! profile^(s^).
echo.

:: --- Export mode ---
echo  Export mode:
if "!_admin!"=="1" (
    echo   1. Without passwords                        ^(default^)
    echo   2. With passwords in PLAIN TEXT in the XML
) else (
    echo   1. Without passwords                        ^(default^)
    echo   2. With passwords - unavailable, run as Administrator
)
echo.
set "_mode="
set /p "_mode=  Select mode [1]: "
if not "!_mode!"=="2" set "_mode=1"
if "!_mode!"=="2" if "!_admin!"=="0" (
    echo.
    echo  [WARN] Password export needs Administrator - using mode 1.
    set "_mode=1"
)
if "!_mode!"=="2" (
    echo.
    echo  [WARN] The exported XML files will contain your Wi-Fi
    echo         passwords in plain text. Keep them somewhere safe.
)
echo.

:: --- Destination under scripts\reports\ ---
for /f "usebackq" %%i in (`powershell -NoProfile -Command "(Get-Date).ToString('yyyy-MM-dd_HH-mm-ss')"`) do set "_stamp=%%i"
set "_out=%~dp0reports\wifi_profiles_%_stamp%"

echo ------------------------------------------------------------
echo  Profiles    : !_count!
if "!_mode!"=="2" (
    echo  Passwords   : INCLUDED ^(plain text^)
) else (
    echo  Passwords   : not included
)
echo  Destination : !_out!
echo ------------------------------------------------------------
set "_go="
set /p "_go=  Export now? (Y/N): "
if /i not "!_go!"=="Y" (
    echo Cancelled.
    goto :eof
)
echo.

mkdir "!_out!" 2>nul
:: netsh mis-parses some folder= paths, so export from inside the folder
pushd "!_out!"
if "!_mode!"=="2" (
    netsh wlan export profile folder=. key=clear
) else (
    netsh wlan export profile folder=.
)
popd

set "_exported=0"
for %%f in ("!_out!\*.xml") do set /a _exported+=1

echo.
echo ============================================================
echo  Summary
echo ============================================================
echo  Exported : !_exported! of !_count! profile^(s^)
echo  Folder   : !_out!
if "!_mode!"=="2" echo  [WARN]   : Files contain plain-text passwords!
echo.
echo  To restore a profile on another PC:
echo    netsh wlan add profile filename="name.xml" user=all
echo ============================================================
endlocal
