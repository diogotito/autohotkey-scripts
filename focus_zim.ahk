#SingleInstance, Force
SendMode Input
SetWorkingDir, C:\tools\zim\
SetTitleMatchMode, RegEx

Run, C:\tools\zim\zim.exe , , Min
WinWait, - Zim$ ahk_exe ^zim.exe$

#IfWinExist, - Zim$ ahk_exe ^zim.exe$
#z::
    OutputDebug, % If Win Exist
    WinActivate
#IfWinNotExist, - Zim$ ahk_exe ^zim.exe$
#z::
    OutputDebug, % If Win NOT Exist
    Run, C:\tools\zim\zim.exe