; Setup

#SingleInstance, Force
#MaxThreadsPerHotkey, 1 ; no re-entrant hotkey handling
; SetKeyDelay, 100, 50 ; in milliseconds
#InstallKeybdHook


; Script state

focused_qa := false
; 0/false = Action Centre closed, 1 = 1st quick action focused, 2 = ...


; Hotkeys

#NumpadMult::
#+NumpadMult::
#F9::QuickAction(1) ; Easily change laptop brighness when used as a 2nd screen

#NumpadDiv::
#F10::QuickAction(2)

#F11::QuickAction(3)

#F12::QuickAction(4)

; Only enable the following hotkeys while the Action Centre is opened
#If focused_qa

; Close the Action Centre as soon as the Win key is released
~LWin UP::QuickAction(false)

; The Brightness quick action cycles through 5 different values from 0 to 100%.
; To lower the brightness, we can press the Brightness button 4 times.
#+NumpadMult::
#+F9::
    Loop, 4
        QuickAction(1)-
    return

; Alternative way to change brightness
#IfWinNotActive, Control Panel\Hardware and Sound\Power Options
#+PgUp::
#+PgDn::
    Run, powercfg.cpl
    WinWait, Control Panel\Hardware and Sound\Power Options
    ControlFocus, msctls_trackbar321, Control Panel\Hardware and Sound\Power Options
    return

#IfWinActive, Control Panel\Hardware and Sound\Power Options
#+PgUp::PgUp
#+PgDn::PgDn
~LWin UP::WinClose
Escape::WinClose


; QuickAction function

QuickAction(new_qa) {
    global focused_qa

    if (focused_qa and new_qa = focused_qa) {
        Send {Enter}
    }

    ; Open or close Action Centre
    if (focused_qa = false) {
        Send #a
        Send +{Tab}
        Send {Home}
        focused_qa := 1
    } else if (new_qa = false) {
        Send {Esc}
        focused_qa := false
        return
    }

    ; Focus the quick action on the right
    while (focused_qa < new_qa) {
        Send {Right}
        focused_qa++
    }

    ; Focus the quick action on the left
    while (focused_qa > new_qa) {
        Send {Left}
        focused_qa--
    }
}