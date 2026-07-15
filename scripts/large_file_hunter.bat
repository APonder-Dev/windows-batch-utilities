@echo off
setlocal enabledelayedexpansion
title Large File Hunter

:: Config file remembers last-used folder between runs
set "_cfg=%~dp0large_file_hunter.ini"
set "_dir="
if exist "%_cfg%" (
    for /f "usebackq tokens=1,* delims==" %%a in ("%_cfg%") do (
        if /i "%%a"=="folder" set "_dir=%%b"
    )
)

echo ============================================================
echo                     Large File Hunter
echo ============================================================
echo  Date : %date%   Time : %time:~0,8%
echo  Finds the biggest files under a folder, including all
echo  subfolders, so you can see what is eating your disk.
echo ============================================================
echo.

:: --- Target folder ---
:ask_dir
if defined _dir (
    echo  Last folder : !_dir!
    set "_in="
    set /p "_in=  Folder to scan [Enter = last used]: "
    if defined _in set "_dir=!_in!"
) else (
    set /p "_dir=  Folder to scan: "
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

:: --- Hunt mode ---
echo  Hunt mode:
echo   1. Top N largest files         (default)
echo   2. All files over a size limit
echo.
set "_mode="
set /p "_mode=  Select mode [1]: "
if not "!_mode!"=="2" set "_mode=1"

set "_topn=25"
set "_minmb=100"
if "!_mode!"=="1" (
    set "_in="
    set /p "_in=  How many files to list [25]: "
    if defined _in set "_topn=!_in!"
    echo !_topn!|findstr /r "^[0-9][0-9]*$" >nul || set "_topn=25"
) else (
    set "_in="
    set /p "_in=  Minimum size in MB [100]: "
    if defined _in set "_minmb=!_in!"
    echo !_minmb!|findstr /r "^[0-9][0-9]*$" >nul || set "_minmb=100"
)
echo.
set "_save="
set /p "_save=  Also save results to reports\ ? (Y/N): "
echo.

:: Remember folder for next run
> "%_cfg%" echo folder=!_dir!

echo  Scanning !_dir! ...
echo  This can take a while on big folders.
echo.

:: Hand off to PowerShell via environment variables (quoting-safe)
set "_hf_dir=!_dir!"
set "_hf_mode=!_mode!"
set "_hf_topn=!_topn!"
set "_hf_minmb=!_minmb!"
set "_hf_save="
if /i "!_save!"=="Y" set "_hf_save=%~dp0reports"

powershell -NoProfile -Command "$files = Get-ChildItem -LiteralPath $env:_hf_dir -Recurse -File -ErrorAction SilentlyContinue; if ($env:_hf_mode -eq '2') { $sel = $files | Where-Object { $_.Length -ge [int64]$env:_hf_minmb * 1MB } | Sort-Object Length -Descending } else { $sel = $files | Sort-Object Length -Descending | Select-Object -First ([int]$env:_hf_topn) }; if (-not $sel) { $out = '  No matching files found.' } else { $out = ($sel | Format-Table @{N='Size';E={ if ($_.Length -ge 1GB) { '{0,9:N2} GB' -f ($_.Length/1GB) } else { '{0,9:N1} MB' -f ($_.Length/1MB) } }}, @{N='File';E={$_.FullName}} | Out-String -Width 260).TrimEnd() }; $out; ''; $sum = ($files | Measure-Object Length -Sum).Sum; ('  Scanned : {0:N0} files, {1:N2} GB total' -f $files.Count, ($sum/1GB)); if ($env:_hf_save) { $null = New-Item -ItemType Directory -Force $env:_hf_save; $rpt = Join-Path $env:_hf_save ('large_files_' + (Get-Date).ToString('yyyy-MM-dd_HH-mm-ss') + '.txt'); ('Large File Hunter - ' + (Get-Date) + ' - ' + $env:_hf_dir), $out, ('Scanned: {0:N0} files, {1:N2} GB total' -f $files.Count, ($sum/1GB)) | Out-File $rpt -Encoding utf8; ('  Saved   : ' + $rpt) }"

echo.
echo ============================================================
echo  Done.
echo ============================================================
endlocal
