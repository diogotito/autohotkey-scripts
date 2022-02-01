#SingleInstance, Force
SendMode Input

Show(what) {
    ToolTip, %what%
    Sleep, 1000
    ToolTip,
}

Launch() {
    Run, C:\Program Files\Zim Desktop Wiki\zim.exe, , Min
    WinWait ahk_exe zim.exe ahk_class gdkWindowToplevel
}

Run, C:\Program Files\Zim Desktop Wiki\zim.exe, , Min
WinWait ahk_exe zim.exe ahk_class gdkWindowToplevel

#z::
    Show(WinExist("ahk_exe zim.exe ahk_class gdkWindowToplevel"))
    if WinExist("ahk_exe zim.exe ahk_class gdkWindowToplevel")
        WinActivate ahk_exe zim.exe ahk_class gdkWindowToplevel
    else {
        Run, C:\Program Files\Zim Desktop Wiki\zim.exe, , Min
        WinWait ahk_exe zim.exe ahk_class gdkWindowToplevel
    }