@echo off
setlocal

title Network QuickDiag
echo ==== Network QuickDiag ====
echo Date: %date%  Time: %time%
echo.

echo [1/7] IP configuration (IPv4/Subnet/Gateway)
ipconfig | findstr /i "IPv4 Subnet Default" || ipconfig
echo.

echo [2/7] Default gateway ping
set "GW="
for /f "tokens=3 delims= " %%g in ('ipconfig ^| findstr /i "Default Gateway"') do (
  if not "%%g"=="" set "GW=%%g"
)
if defined GW (
  echo Pinging gateway: %GW%
  ping -n 4 %GW%
) else (
  echo No default gateway found.
)
echo.

echo [3/7] DNS check (nslookup microsoft.com)
nslookup microsoft.com
echo.

echo [4/7] Internet reachability
ping -n 4 1.1.1.1
ping -n 4 8.8.8.8
echo.

echo [5/7] Route table
route print
echo.

echo [6/7] Active connections (first page)
netstat -ano | more
echo.

echo [7/7] Current DNS cache (first page)
ipconfig /displaydns | more
echo.

echo Done.
endlocal
