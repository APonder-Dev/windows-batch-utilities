@echo off
setlocal enabledelayedexpansion
title Smart Backup

:: Config file remembers last-used paths between runs
set "_cfg=%~dp0smart_backup.ini"
set "_src="
set "_dst="
if exist "%_cfg%" (
    for /f "usebackq tokens=1,* delims==" %%a in ("%_cfg%") do (
        if /i "%%a"=="source" set "_src=%%b"
        if /i "%%a"=="dest" set "_dst=%%b"
    )
)

echo ============================================================
echo                       Smart Backup
echo ============================================================
echo  Date : %date%   Time : %time:~0,8%
echo  Incremental backup via robocopy - copies new and updated
echo  files only. Mirror mode makes an exact copy instead.
echo ============================================================
echo.

:: --- Source folder ---
:ask_source
if defined _src (
    echo  Last source : !_src!
    set "_in="
    set /p "_in=  Source folder [Enter = last used]: "
    if defined _in set "_src=!_in!"
) else (
    set /p "_src=  Source folder: "
)
if not defined _src goto ask_source
set "_src=!_src:"=!"
if "!_src:~-1!"=="\" if not "!_src:~-2!"==":\" set "_src=!_src:~0,-1!"
if not exist "!_src!\" (
    echo  [X] Folder not found: !_src!
    echo.
    set "_src="
    goto ask_source
)
echo.

:: --- Destination folder ---
:ask_dest
if defined _dst (
    echo  Last destination : !_dst!
    set "_in="
    set /p "_in=  Destination folder [Enter = last used]: "
    if defined _in set "_dst=!_in!"
) else (
    set /p "_dst=  Destination folder: "
)
if not defined _dst goto ask_dest
set "_dst=!_dst:"=!"
if "!_dst:~-1!"=="\" if not "!_dst:~-2!"==":\" set "_dst=!_dst:~0,-1!"
if /i "!_dst!"=="!_src!" (
    echo  [X] Destination must be different from source.
    echo.
    set "_dst="
    goto ask_dest
)
if not exist "!_dst!\" (
    set "_mk="
    set /p "_mk=  Destination does not exist. Create it? (Y/N): "
    if /i not "!_mk!"=="Y" (
        echo.
        set "_dst="
        goto ask_dest
    )
    mkdir "!_dst!" 2>nul
    if not exist "!_dst!\" (
        echo  [X] Could not create: !_dst!
        echo.
        set "_dst="
        goto ask_dest
    )
)
echo.

:: --- Backup mode ---
echo  Backup mode:
echo   1. Incremental - copy new and updated files only  (default)
echo   2. Mirror      - exact copy, DELETES extra files in destination
echo.
set "_mode="
set /p "_mode=  Select mode [1]: "
if "!_mode!"=="2" (
    set "_flags=/MIR"
    set "_modename=Mirror"
    echo.
    echo  [WARN] Mirror mode deletes files in the destination that
    echo         no longer exist in the source.
) else (
    set "_flags=/E /XO"
    set "_modename=Incremental"
)
echo.

:: Drive roots need a trailing dot so robocopy quoting stays intact
if "!_src:~-2!"==":\" set "_src=!_src!."
if "!_dst:~-2!"==":\" set "_dst=!_dst!."

:: --- Confirm ---
echo ------------------------------------------------------------
echo  Source      : !_src!
echo  Destination : !_dst!
echo  Mode        : !_modename!
echo ------------------------------------------------------------
set "_go="
set /p "_go=  Start backup? (Y/N): "
if /i not "!_go!"=="Y" (
    echo Cancelled.
    goto :eof
)

:: Remember paths for next run
(
    echo source=!_src!
    echo dest=!_dst!
) > "%_cfg%"

:: Timestamped log under scripts\logs\
for /f "usebackq" %%i in (`powershell -NoProfile -Command "(Get-Date).ToString('yyyy-MM-dd_HH-mm-ss')"`) do set "_stamp=%%i"
mkdir "%~dp0logs" 2>nul
set "_log=%~dp0logs\backup_%_stamp%.log"

echo.
echo  Running robocopy ^(!_modename!^)...
echo.
robocopy "!_src!" "!_dst!" !_flags! /FFT /R:1 /W:1 /MT:8 /NP /TEE /LOG:"!_log!"
set "_rc=!errorlevel!"

echo.
echo ============================================================
echo  Summary
echo ============================================================
if !_rc! GEQ 8 (
    echo  Status : COMPLETED WITH ERRORS ^(robocopy code !_rc!^)
    echo           Check the log for details.
) else if !_rc! GEQ 1 (
    echo  Status : SUCCESS - changes were copied
) else (
    echo  Status : SUCCESS - already up to date, nothing to copy
)
echo  Log    : !_log!
echo ============================================================
endlocal
