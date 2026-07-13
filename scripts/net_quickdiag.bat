@echo off
setlocal enabledelayedexpansion
title Network Quick Diag

echo ============================================================
echo                   Network Quick Diag
echo ============================================================
echo  Date : %date%   Time : %time%
echo ============================================================
echo.

echo [1/7] IP Configuration (IPv4 / Subnet / Gateway / DNS)
echo --------------------------------------------------------
ipconfig | findstr /i "IPv4 Subnet Default DNS"
echo.

echo [2/7] Default Gateway Ping
echo --------------------------------------------------------
set "GW="
for /f "usebackq delims=" %%g in (`powershell -NoProfile -Command "(Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway } | Select-Object -First 1).IPv4DefaultGateway.NextHop" 2^>nul`) do set "GW=%%g"
if defined GW (
    echo Pinging gateway: %GW%
    ping -n 4 %GW%
    if errorlevel 1 (echo  Status: UNREACHABLE) else (echo  Status: OK)
) else (
    echo No default gateway found.
)
echo.

echo [3/7] DNS Resolution  (nslookup microsoft.com)
echo --------------------------------------------------------
nslookup microsoft.com
echo.

echo [4/7] Internet Reachability
echo --------------------------------------------------------
echo  Pinging 1.1.1.1 (Cloudflare)...
ping -n 3 1.1.1.1
if errorlevel 1 (echo  Status: UNREACHABLE) else (echo  Status: OK)
echo.
echo  Pinging 8.8.8.8 (Google)...
ping -n 3 8.8.8.8
if errorlevel 1 (echo  Status: UNREACHABLE) else (echo  Status: OK)
echo.

echo [5/7] Route Table
echo --------------------------------------------------------
route print
echo.

echo [6/7] Active Connections
echo --------------------------------------------------------
netstat -ano
echo.

echo [7/7] DNS Cache
echo --------------------------------------------------------
ipconfig /displaydns
echo.

echo ============================================================
echo  Done.
echo ============================================================
endlocal
