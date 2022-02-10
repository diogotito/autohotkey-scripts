#SingleInstance, Force

ZimExecutable = C:\Program Files\Zim Desktop Wiki\zim.exe
ZimCriteria   = ahk_exe zim.exe ahk_class gdkWindowToplevel

; Launch Zim minimized to the tray
Run %ZimExecutable% --plugin trayicon

#z::
    DetectHiddenWindows Off
    if WinExist(ZimCriteria) {
        ; There is a unhidden Zim window. Toggle it.
        if WinActive()
            WinMinimize
        else
            WinActivate
        return
    }

    DetectHiddenWindows On
    if WinExist(ZimCriteria) {
        ; The window is minimized to the system tray.
        ; Use standard Windows hotkeys to "click" the icon.
        CoordMode Mouse, Screen
        MouseGetPos mouseX, mouseY
        ; Press Right 3x to jump over this script's AHK icon bc it eats the z?
        SendInput #b{Right}{Right}{Right}z
        Sleep 40
        SendInput {Enter}
        Sleep 10
        MouseMove % mouseX, % mouseY
    } else {
        ; There isn't any Zim window. Relaunch it.
        ToolTip Launching zim.exe`nto bring up the notebook...
        Run % ZimExecutable
        WinWait % ZimCriteria
        ToolTip,,
    }