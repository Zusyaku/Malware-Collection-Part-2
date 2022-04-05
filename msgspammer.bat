@echo off
color 02
set MSGSPAM=
title MSG Spammer 1.0
:0
cls
echo MSG Spammer 1.0 - for educational and ethical hacking pentest purposes only
set /p MSGSPAM="Type Message to spam: "
if "%MSGSPAM%"=="" goto 0
:1
msg * %MSGSPAM%
goto 1