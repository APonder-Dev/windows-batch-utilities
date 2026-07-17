@echo off
setlocal enabledelayedexpansion
title Hosts Toggle

set "_hosts=%SystemRoot%\System32\drivers\etc\hosts"
set "_dir=%~dp0hosts_profiles"
set "_dev=%_dir%\hosts.dev"
set "_def=%_dir%\hosts.default"
set "_prev=%_dir%\hosts.previous"
set "_mark=# [hosts-toggle] active profile:"

:: Admin check (required to modify the hosts file)
net session >nul 2>&1
if "%errorlevel%"=="0" (set "_admin=1") else (set "_admin=0")

if not exist "%_dir%" mkdir "%_dir%"

:: First run: offer to snapshot the current hosts as DEFAULT
if not exist "%_def%" (
    echo ============================================================
    echo                        Hosts Toggle
    echo ============================================================
    echo  First run - no DEFAULT profile saved yet.
    echo  Save your current hosts file as the DEFAULT profile so
    echo  you can always switch back to it.
    echo.
    set "_in="
    set /p "_in=  Save current hosts as DEFAULT now? (Y/N): "
    if /i "!_in!"=="Y" (
        findstr /v /c:"%_mark%" "%_hosts%" > "%_def%"
        echo  Saved.
        timeout /t 1 >nul
    )
)

:menu
cls
set "_active=unmanaged (never switched)"
findstr /c:"%_mark% DEV" "%_hosts%" >nul 2>&1 && set "_active=DEV"
findstr /c:"%_mark% DEFAULT" "%_hosts%" >nul 2>&1 && set "_active=DEFAULT"

echo ============================================================
echo                        Hosts Toggle
echo ============================================================
echo  Date : %date%   Time : %time:~0,8%
if "!_admin!"=="1" (
    echo  Mode : Administrator
) else (
    echo  Mode : Standard User  ^(switching disabled - run as Admin^)
)
echo  Active profile : !_active!
echo ============================================================
echo.
echo   SWITCH
echo   ------------------------------------------------------
echo   1. Switch to DEV hosts
echo   2. Switch to DEFAULT hosts
echo.
echo   PROFILES
echo   ------------------------------------------------------
echo   3. Save current hosts as DEV profile
echo   4. Save current hosts as DEFAULT profile
echo   E. Edit DEV profile in Notepad
echo.
echo   OTHER
echo   ------------------------------------------------------
echo   5. View current hosts file
echo   X. Back / Exit
echo.
set "choice="
set /p "choice=  Select an option: "

if "%choice%"=="1" call :apply DEV "%_dev%" & goto menu
if "%choice%"=="2" call :apply DEFAULT "%_def%" & goto menu
if "%choice%"=="3" call :save DEV "%_dev%" & goto menu
if "%choice%"=="4" call :save DEFAULT "%_def%" & goto menu
if /i "%choice%"=="e" call :editdev & goto menu
if "%choice%"=="5" call :view & goto menu
if /i "%choice%"=="x" exit /b
goto menu

:: --- Apply profile %1 from file %2 to the live hosts file ---
:apply
echo.
if "!_admin!"=="0" (
    echo   [X] Administrator required to modify the hosts file.
    pause
    goto :eof
)
if not exist "%~2" (
    echo   [X] No %~1 profile saved yet - use the save options first.
    pause
    goto :eof
)
copy /y "%_hosts%" "%_prev%" >nul
(
    echo %_mark% %~1
    type "%~2"
) > "%_hosts%" 2>nul
findstr /c:"%_mark% %~1" "%_hosts%" >nul 2>&1
if errorlevel 1 (
    echo   [X] Could not write the hosts file.
) else (
    ipconfig /flushdns >nul 2>&1
    echo   Switched to %~1 hosts and flushed the DNS cache.
    echo   The old hosts file was kept as hosts.previous
)
pause
goto :eof

:: --- Save the live hosts file as profile %1 into file %2 ---
:save
findstr /v /c:"%_mark%" "%_hosts%" > "%~2"
echo.
echo   Current hosts saved as the %~1 profile.
pause
goto :eof

:: --- Edit the DEV profile in Notepad (created from current hosts if new) ---
:editdev
if not exist "%_dev%" findstr /v /c:"%_mark%" "%_hosts%" > "%_dev%"
start "" notepad "%_dev%"
goto :eof

:: --- Show the live hosts file ---
:view
cls
echo ============================================================
echo  %_hosts%
echo ============================================================
type "%_hosts%"
echo ============================================================
pause
goto :eof
