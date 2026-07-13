@echo off
setlocal enabledelayedexpansion
title Temp and Cache Cleaner

:: Admin check
net session >nul 2>&1
if "%errorlevel%"=="0" (set "_admin=1") else (set "_admin=0")

echo ============================================================
echo                 Temp and Cache Cleaner
echo ============================================================
echo  Date : %date%   Time : %time%
if "!_admin!"=="1" (
    echo  Mode : Administrator
) else (
    echo  Mode : Standard User  ^(Windows Temp will be skipped^)
)
echo ============================================================
echo.
echo  Targets:
echo  1. User Temp    : %TEMP%
if "!_admin!"=="1" (
    echo  2. Windows Temp : C:\Windows\Temp
) else (
    echo  2. Windows Temp : C:\Windows\Temp  [SKIPPED - run as Admin]
)
echo  3. Chrome Cache : %LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache
echo  4. Edge Cache   : %LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache
echo  5. Firefox      : Auto-detected profile cache
echo.

:: Warn about open browsers
set "_browser_warn=0"
tasklist /fi "imagename eq chrome.exe" 2>nul | find /i "chrome.exe" >nul 2>&1
if not errorlevel 1 (echo  [!] Chrome is running - cache files may be partially locked. & set "_browser_warn=1")
tasklist /fi "imagename eq msedge.exe" 2>nul | find /i "msedge.exe" >nul 2>&1
if not errorlevel 1 (echo  [!] Edge is running - cache files may be partially locked. & set "_browser_warn=1")
tasklist /fi "imagename eq firefox.exe" 2>nul | find /i "firefox.exe" >nul 2>&1
if not errorlevel 1 (echo  [!] Firefox is running - cache files may be partially locked. & set "_browser_warn=1")
if "!_browser_warn!"=="1" echo.

set /p "_confirm=  Proceed with cleanup? (Y/N): "
if /i not "!_confirm!"=="Y" (
    echo Cancelled.
    goto :eof
)
echo.

:: Capture C: free space before cleanup
for /f "usebackq" %%f in (`powershell -NoProfile -Command "[math]::Round((Get-PSDrive C).Free/1MB,0)"`) do set "_free_before=%%f"

:: --- 1. User Temp ---
echo [1/5] Cleaning User Temp...
del /f /s /q "%TEMP%\*" >nul 2>&1
for /d %%d in ("%TEMP%\*") do rd /s /q "%%d" >nul 2>&1
echo       Done.

:: --- 2. Windows Temp (admin only) ---
if "!_admin!"=="1" (
    echo [2/5] Cleaning Windows Temp...
    del /f /s /q "C:\Windows\Temp\*" >nul 2>&1
    for /d %%d in ("C:\Windows\Temp\*") do rd /s /q "%%d" >nul 2>&1
    echo       Done.
) else (
    echo [2/5] Windows Temp... Skipped ^(run as Administrator to clean^)
)

:: --- 3. Chrome Cache ---
echo [3/5] Cleaning Chrome Cache...
set "_chrome=%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache"
if exist "!_chrome!" (
    del /f /s /q "!_chrome!\*" >nul 2>&1
    echo       Done.
) else (
    echo       Not found.
)

:: --- 4. Edge Cache ---
echo [4/5] Cleaning Edge Cache...
set "_edge=%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache"
if exist "!_edge!" (
    del /f /s /q "!_edge!\*" >nul 2>&1
    echo       Done.
) else (
    echo       Not found.
)

:: --- 5. Firefox Cache (all default profiles) ---
echo [5/5] Cleaning Firefox Cache...
set "_ff_profiles=%APPDATA%\Mozilla\Firefox\Profiles"
if exist "!_ff_profiles!" (
    powershell -NoProfile -Command ^
        "Get-ChildItem $env:_ff_profiles -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'default' } | ForEach-Object { $c = Join-Path $_.FullName 'cache2'; if(Test-Path $c){ Remove-Item (Join-Path $c '*') -Recurse -Force -ErrorAction SilentlyContinue } }"
    echo       Done.
) else (
    echo       Not found.
)

:: Capture C: free space after cleanup
for /f "usebackq" %%f in (`powershell -NoProfile -Command "[math]::Round((Get-PSDrive C).Free/1MB,0)"`) do set "_free_after=%%f"
set /a "_freed=_free_after - _free_before"

echo.
echo ============================================================
echo  Summary
echo ============================================================
echo  C: before : !_free_before! MB free
echo  C: after  : !_free_after! MB free
echo  Freed     : !_freed! MB
echo ============================================================
endlocal
