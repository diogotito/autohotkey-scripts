#SingleInstance, Force
SendMode Input

global ZimExecutable := "C:\Program Files\Zim Desktop Wiki\zim.exe"
global ZimCriteria   := "ahk_exe zim.exe ahk_class gdkWindowToplevel"

Launch() {
    Run, %ZimExecutable%, , Min
    WinWait % ZimCriteria
}

Launch()

#z::
    if WinExist(ZimCriteria)
        WinActivate % ZimCriteria
    else
        Launch()