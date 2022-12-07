Zim_Executable() {
    return """C:\tools\zim\zim-0_75_1\zim.exe"""
}

Zim_Criteria() {
    return "ahk_exe zim.exe ahk_class gdkWindowToplevel"
}

Zim_Launch() {
    Run % Zim_Executable() " --plugin trayicon"
    Sleep 500
    ; Run % Zim_Executable()
}

Zim() {
    DetectHiddenWindows Off
    if WinExist(Zim_Criteria()) {
        ; There is a unhidden Zim window. Toggle it.
        if WinActive()
            WinMinimize
        else
            WinActivate
        return
    }

    DetectHiddenWindows On
    if WinExist(Zim_Criteria()) {
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
        Run % Zim_Executable()
        WinWait % Zim_Criteria()
        ToolTip,,
    }
}