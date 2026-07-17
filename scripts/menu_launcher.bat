@echo off
setlocal
title Windows Batch Utilities
mode con: cols=64 lines=38 >nul 2>&1
color 0A

:: Always run relative to this script's folder
cd /d "%~dp0"

:: Admin check (shown in header)
net session >nul 2>&1
if "%errorlevel%"=="0" (set "_mode=Administrator") else (set "_mode=Standard User")

:menu
cls
echo ============================================================
echo               Windows Batch Utilities  v1.6.0
echo ============================================================
echo  Date : %date%   Time : %time:~0,8%
echo  Mode : %_mode%
echo ============================================================
echo.
echo   SYSTEM
echo   ------------------------------------------------------
echo   1. System Info Snapshot    Save full report to reports\
echo   2. Temp and Cache Cleaner  Free disk space safely
echo.
echo   NETWORK
echo   ------------------------------------------------------
echo   3. Network Quick Diag      Gateway, DNS, internet checks
echo   4. Wi-Fi Profile Exporter  Back up Wi-Fi profiles to XML
echo.
echo   FILES
echo   ------------------------------------------------------
echo   5. Smart Backup            Incremental robocopy backup
echo   6. File Organizer          Sort a folder by file type
echo   7. Large File Hunter       Find the biggest space hogs
echo.
echo   OTHER
echo   ------------------------------------------------------
echo   R. Open reports folder     L. Open backup logs folder
echo   X. Exit
echo.
echo ============================================================
set "choice="
set /p "choice=  Select an option: "

if /i "%choice%"=="1" call :run sysinfo_snapshot.bat & goto menu
if /i "%choice%"=="2" call :run temp_cleaner.bat & goto menu
if /i "%choice%"=="3" call :run net_quickdiag.bat & goto menu
if /i "%choice%"=="4" call :run wifi_profile_exporter.bat & goto menu
if /i "%choice%"=="5" call :run smart_backup.bat & goto menu
if /i "%choice%"=="6" call :run file_organizer.bat & goto menu
if /i "%choice%"=="7" call :run large_file_hunter.bat & goto menu
if /i "%choice%"=="r" call :open reports "run System Info Snapshot first" & goto menu
if /i "%choice%"=="l" call :open logs "run Smart Backup first" & goto menu
if /i "%choice%"=="x" exit /b

echo.
echo   [X] Invalid option: "%choice%" - choose 1-7, R, L, or X.
timeout /t 2 >nul
goto menu

:run
cls
call "%~dp0%~1"
echo.
echo ------------------------------------------------------------
pause
goto :eof

:open
if exist "%~dp0%~1" (
    start "" explorer "%~dp0%~1"
) else (
    echo.
    echo   No %~1 folder yet - %~2.
    timeout /t 2 >nul
)
goto :eof
