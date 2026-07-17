@echo off
setlocal enabledelayedexpansion
title Git Quick Helper

:: Config file remembers last-used repo between runs
set "_cfg=%~dp0git_quick_helper.ini"
set "_dir="
if exist "%_cfg%" (
    for /f "usebackq tokens=1,* delims==" %%a in ("%_cfg%") do (
        if /i "%%a"=="repo" set "_dir=%%b"
    )
)

echo ============================================================
echo                     Git Quick Helper
echo ============================================================
echo  Date : %date%   Time : %time:~0,8%
echo  Stage, commit, and push in one go: git add -A, commit
echo  with your message, then push ^(sets upstream if needed^).
echo ============================================================
echo.

git --version >nul 2>&1
if errorlevel 1 (
    echo  [X] Git is not installed or not on PATH.
    goto :eof
)

:: --- Repo folder ---
:ask_dir
if defined _dir (
    echo  Last repo : !_dir!
    set "_in="
    set /p "_in=  Repo folder [Enter = last used]: "
    if defined _in set "_dir=!_in!"
) else (
    set /p "_dir=  Repo folder: "
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
git -C "!_dir!" rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo  [X] Not a git repository: !_dir!
    echo.
    set "_dir="
    goto ask_dir
)
echo.

:: Remember repo for next run
> "%_cfg%" echo repo=!_dir!

:: --- Branch and pending changes ---
set "_branch="
for /f "usebackq delims=" %%b in (`git -C "!_dir!" branch --show-current`) do set "_branch=%%b"
if not defined _branch (
    echo  [X] Detached HEAD - check out a branch first.
    goto :eof
)

set "_count=0"
for /f "usebackq delims=" %%s in (`git -C "!_dir!" status --short`) do set /a _count+=1

echo ------------------------------------------------------------
echo  Branch  : !_branch!
echo  Changes : !_count! file^(s^)
echo ------------------------------------------------------------
if not "!_count!"=="0" git -C "!_dir!" status --short
echo.

:: Nothing to commit? Maybe there are unpushed commits.
if "!_count!"=="0" (
    set "_ahead=0"
    for /f "usebackq" %%n in (`git -C "!_dir!" rev-list --count @{u}..HEAD 2^>nul`) do set "_ahead=%%n"
    if "!_ahead!"=="0" (
        echo  Working tree clean and nothing to push. All done.
        goto :eof
    )
    echo  Working tree clean, but !_ahead! commit^(s^) not pushed yet.
    set "_go="
    set /p "_go=  Push them now? (Y/N): "
    if /i not "!_go!"=="Y" (
        echo Cancelled.
        goto :eof
    )
    goto push
)

:: --- Commit message ---
:ask_msg
set "_msg="
set /p "_msg=  Commit message: "
if not defined _msg (
    echo  [X] A commit message is required.
    goto ask_msg
)
set "_msg=!_msg:"=!"
echo.

set "_go="
set /p "_go=  Stage all, commit, and push? (Y/N): "
if /i not "!_go!"=="Y" (
    echo Cancelled.
    goto :eof
)
echo.

echo [1/3] Staging all changes...
git -C "!_dir!" add -A
if errorlevel 1 (
    echo  [X] git add failed.
    goto :eof
)

echo [2/3] Committing...
git -C "!_dir!" commit -m "!_msg!"
if errorlevel 1 (
    echo  [X] Commit failed - see message above.
    goto :eof
)

:push
echo [3/3] Pushing...
git -C "!_dir!" rev-parse --abbrev-ref @{u} >nul 2>&1
if errorlevel 1 (
    echo       No upstream set - pushing with -u origin !_branch!
    git -C "!_dir!" push -u origin "!_branch!"
) else (
    git -C "!_dir!" push
)
set "_pushrc=!errorlevel!"

echo.
echo ============================================================
echo  Summary
echo ============================================================
for /f "usebackq delims=" %%l in (`git -C "!_dir!" log -1 --oneline`) do echo  Latest  : %%l
if "!_pushrc!"=="0" (
    echo  Push    : OK
) else (
    echo  Push    : FAILED - is a remote configured? The commit
    echo            is safe locally; push again once fixed.
)
echo  Branch  : !_branch!
echo ============================================================
endlocal
