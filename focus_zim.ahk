#SingleInstance, Force
SendMode Input

ZimExecutable = C:\Program Files\Zim Desktop Wiki\zim.exe
ZimCriteria   = ahk_exe zim.exe ahk_class gdkWindowToplevel

; Launch Zim and minimize the main window
Run %ZimExecutable%, , Min
WinWait % ZimCriteria
WinMinimize

#z::
    ; DetectHiddenWindows On
    if WinExist(ZimCriteria)
        if WinActive()
            WinMinimize
        else
            WinActivate
    else {
        ToolTip Launching zim.exe`nto bring up the notebook...
        Run % ZimExecutable
        WinWait % ZimCriteria
        ToolTip,,
    }
    return
