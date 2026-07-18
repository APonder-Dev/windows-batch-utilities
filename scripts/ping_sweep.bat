@echo off
setlocal enabledelayedexpansion
title Ping Sweep

echo ============================================================
echo                        Ping Sweep
echo ============================================================
echo  Date : %date%   Time : %time:~0,8%
echo  Pings every address on a /24 subnet in parallel and lists
echo  the hosts that answer, with round-trip time and hostname.
echo ============================================================
echo.

:: Detect this PC's IPv4 and derive the local /24 base
set "_myip="
for /f "usebackq delims=" %%i in (`powershell -NoProfile -Command "(Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway } | Select-Object -First 1).IPv4Address.IPAddress" 2^>nul`) do set "_myip=%%i"
set "_base="
if defined _myip for /f "tokens=1-3 delims=." %%a in ("!_myip!") do set "_base=%%a.%%b.%%c"

:ask_base
if defined _base (
    echo  This PC : !_myip!
    set "_in="
    set /p "_in=  Subnet to scan (first 3 octets) [Enter = !_base!]: "
    if defined _in set "_base=!_in!"
) else (
    set /p "_base=  Subnet to scan (first 3 octets, e.g. 192.168.1): "
)
if not defined _base goto ask_base
echo !_base!|findstr /r "^[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$" >nul || (
    echo  [X] Use the first three octets only, e.g. 192.168.1
    echo.
    set "_base="
    goto ask_base
)
echo.
set "_save="
set /p "_save=  Also save results to reports\ ? (Y/N): "
echo.

echo  Scanning !_base!.1 - !_base!.254 ...
echo  This takes about 10 seconds.
echo.

set "_ps_base=!_base!"
set "_ps_save="
if /i "!_save!"=="Y" set "_ps_save=%~dp0reports"

powershell -NoProfile -Command "$base = $env:_ps_base; $tasks = @{}; 1..254 | ForEach-Object { $ip = $base + '.' + $_; $tasks[$ip] = (New-Object System.Net.NetworkInformation.Ping).SendPingAsync($ip, 1000) }; try { [void][Threading.Tasks.Task]::WaitAll([Threading.Tasks.Task[]]@($tasks.Values), 10000) } catch {}; $mine = @(); try { $mine = (Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue).IPAddress } catch {}; $gw = ''; try { $gw = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway } | Select-Object -First 1).IPv4DefaultGateway.NextHop } catch {}; $alive = foreach ($k in $tasks.Keys) { try { $r = $tasks[$k].Result; if ($r.Status -eq 'Success') { [pscustomobject]@{ IP = $k; ms = $r.RoundtripTime } } } catch {} }; $alive = @($alive | Sort-Object { [int]($_.IP -split '\.')[-1] }); $lines = foreach ($a in $alive) { $name = ''; try { $t = [Net.Dns]::GetHostEntryAsync($a.IP); if ($t.Wait(400)) { $name = $t.Result.HostName } } catch {}; $tag = ''; if ($a.IP -eq $gw) { $tag = ' (gateway)' }; if ($mine -contains $a.IP) { $tag = ' (this PC)' }; '  {0,-15} {1,5} ms   {2}{3}' -f $a.IP, $a.ms, $name, $tag }; if (-not $lines) { $lines = @('  No hosts answered. (Some devices block ping.)') }; $lines; ''; $sum = '  Alive : {0} host(s) on {1}.0/24' -f $alive.Count, $base; $sum; if ($env:_ps_save) { $null = New-Item -ItemType Directory -Force $env:_ps_save; $rpt = Join-Path $env:_ps_save ('ping_sweep_' + (Get-Date).ToString('yyyy-MM-dd_HH-mm-ss') + '.txt'); ('Ping Sweep - ' + (Get-Date) + ' - ' + $base + '.0/24'), $lines, $sum | Out-File $rpt -Encoding utf8; ('  Saved : ' + $rpt) }"

echo.
echo ============================================================
echo  Done. Note: devices with ping blocked will not show up.
echo ============================================================
endlocal
