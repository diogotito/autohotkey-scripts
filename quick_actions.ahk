; Setup
#SingleInstance, Force
#MaxThreadsPerHotkey, 1 ; no re-entrant hotkey handling
; SetKeyDelay, 200, 50 ; in milliseconds
#InstallKeybdHook

; false = Action Centre closed, 1 = 1st quick action focused, 2 = ...
focused_qa := false


#NumpadMult::
#+NumpadMult::
#F9::QuickAction(1)

#F10::QuickAction(2)
#F11::QuickAction(3)
#F12::QuickAction(4)

#If focused_qa
~LWin UP::QuickAction(false)
#+NumpadMult::
#+F9::
    Loop, 4
        QuickAction(1)


QuickAction(new_qa) {
    global focused_qa
    Tooltip, Called QuickAction(%new_qa%)`nfocused_qa = %focused_qa%

    if (focused_qa and new_qa = focused_qa) {
        Send {Enter}
    }

    ; Open or close Action Centre
    if (focused_qa = false) {
        Send #a
        Sleep 1000
        Send +{Tab}
        Sleep 500
        Send {Tab}
        Sleep 500
        Send +{Tab}
        focused_qa := 1
        ToolTip, Opened Action Centre`nfocused_qa = %focused_qa%`nnew_qa = %new_qa%
        Sleep 1000
    } else if (new_qa = false) {
        Send {Esc}
        focused_qa := false
        ToolTip, %focused_qa%
        return
    }

    ; Focus the quick action on the right
    while (focused_qa < new_qa) {
        Send {Right}
        Tooltip, RIGHT`nfocused_qa = %focused_qa%`nnew_qa = %new_qa%
        Sleep 500
        focused_qa++
    }

    ; Focus the quick action on the left
    while (focused_qa > new_qa) {
        Send {Left}
        Tooltip, LEFT`nfocused_qa = %focused_qa%`nnew_qa = %new_qa%
        Sleep 500
        focused_qa--
    }
    ToolTip, end.`nfocused_qa = %focused_qa%`nnew_qa = %new_qa%
}