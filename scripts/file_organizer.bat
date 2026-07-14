@echo off
setlocal enabledelayedexpansion
title File Organizer

:: Config file remembers last-used folder between runs
set "_cfg=%~dp0file_organizer.ini"
set "_dir="
if exist "%_cfg%" (
    for /f "usebackq tokens=1,* delims==" %%a in ("%_cfg%") do (
        if /i "%%a"=="folder" set "_dir=%%b"
    )
)

:: Category map (cmd variable names are case-insensitive, so .JPG matches too)
for %%e in (jpg jpeg png gif bmp webp svg ico tif tiff heic) do set "_map_.%%e=Images"
for %%e in (pdf doc docx xls xlsx ppt pptx txt rtf odt csv md) do set "_map_.%%e=Documents"
for %%e in (mp4 mkv avi mov wmv flv webm) do set "_map_.%%e=Videos"
for %%e in (mp3 wav flac m4a aac ogg wma) do set "_map_.%%e=Music"
for %%e in (zip rar 7z tar gz iso) do set "_map_.%%e=Archives"
for %%e in (exe msi bat cmd ps1) do set "_map_.%%e=Programs"

echo ============================================================
echo                      File Organizer
echo ============================================================
echo  Date : %date%   Time : %time:~0,8%
echo  Sorts the files in a folder into tidy subfolders.
echo  Only top-level files are touched - subfolders are ignored.
echo ============================================================
echo.

:: --- Target folder ---
:ask_dir
if defined _dir (
    echo  Last folder : !_dir!
    set "_in="
    set /p "_in=  Folder to organize [Enter = last used]: "
    if defined _in set "_dir=!_in!"
) else (
    set /p "_dir=  Folder to organize: "
)
if not defined _dir goto ask_dir
set "_dir=!_dir:"=!"
if "!_dir:~-1!"=="\" if not "!_dir:~-2!"==":\" set "_dir=!_dir:~0,-1!"
if not exist "!_dir!\" (
    echo  [X] Folder not found: !_dir!
    echo.
    set "_dir="
    goto ask_dir
)
echo.

:: --- Organize mode ---
echo  Organize mode:
echo   1. By type      - Images, Documents, Videos, Music,
echo                     Archives, Programs, Other  (default)
echo   2. By extension - one folder per extension (jpg, pdf, ...)
echo.
set "_mode="
set /p "_mode=  Select mode [1]: "
if not "!_mode!"=="2" set "_mode=1"
echo.

:: --- Preview pass ---
set "_total=0"
for /f "delims=" %%f in ('dir /b /a-d-h "!_dir!" 2^>nul') do (
    set "_full=!_dir!\%%f"
    if /i not "!_full!"=="%~f0" if /i not "!_full!"=="%_cfg%" (
        call :getdest "%%~xf"
        set /a "_cnt_!_dest!+=1"
        set /a _total+=1
    )
)

if !_total!==0 (
    echo  Nothing to organize - no files found in !_dir!
    goto :eof
)

echo ------------------------------------------------------------
echo  Plan for: !_dir!
echo ------------------------------------------------------------
for /f "tokens=1,* delims==" %%a in ('set _cnt_ 2^>nul') do (
    set "_n=%%a"
    echo   !_n:_cnt_=!\  ^<-  %%b file^(s^)
)
echo ------------------------------------------------------------
echo  Total: !_total! file^(s^). Name clashes get a _1, _2, ... suffix.
echo.
set "_go="
set /p "_go=  Organize now? (Y/N): "
if /i not "!_go!"=="Y" (
    echo Cancelled.
    goto :eof
)

:: Remember folder for next run
> "%_cfg%" echo folder=!_dir!

:: --- Move pass ---
set "_moved=0"
set "_skipped=0"
for /f "delims=" %%f in ('dir /b /a-d-h "!_dir!" 2^>nul') do (
    set "_full=!_dir!\%%f"
    if /i not "!_full!"=="%~f0" if /i not "!_full!"=="%_cfg%" (
        call :getdest "%%~xf"
        if not exist "!_dir!\!_dest!\" mkdir "!_dir!\!_dest!"
        call :movefile "!_dir!\%%f" "!_dir!\!_dest!"
    )
)

echo.
echo ============================================================
echo  Summary
echo ============================================================
echo  Moved   : !_moved! file^(s^)
if not "!_skipped!"=="0" echo  Skipped : !_skipped! file^(s^) - in use or access denied
echo  Folder  : !_dir!
echo ============================================================
goto :eof

:: --- Map an extension (with dot) to a destination folder name ---
:getdest
set "_e=%~1"
if "!_mode!"=="2" (
    if defined _e (set "_dest=!_e:~1!") else set "_dest=No_Extension"
) else (
    set "_dest=!_map_%~1!"
    if not defined _dest set "_dest=Other"
)
goto :eof

:: --- Move %1 into folder %2, adding _1, _2, ... on name clashes ---
:movefile
set "_tgt=%~2\%~nx1"
set "_i=0"
:mf_try
if exist "!_tgt!" (
    set /a _i+=1
    set "_tgt=%~2\%~n1_!_i!%~x1"
    goto mf_try
)
move "%~1" "!_tgt!" >nul 2>&1
if errorlevel 1 (set /a _skipped+=1) else (set /a _moved+=1)
goto :eof
