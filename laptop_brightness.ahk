; Setup
#SingleInstance, Force
#MaxThreadsPerHotkey, 1 ; no re-entrant hotkey handling
SetKeyDelay, -1, -1 ; in milliseconds

; false = Action Centre closed, 1 = 1st quick action focused, 2 = ...
focused_qa := false

QuickAction(qa) {
    global focused_qa

    ; Open Action Centre and focus first quick action
    if (focused_qa = false) {
        Send #a
        Send +{Tab}
        Send +{Tab}
        Send {Tab}
        focused_qa := 1
    }

    ; Close Action Centre and don't do anything else
    if (qa = false) {
        Send {Esc}
        focused_qa := false
        return
    }

    ; Focus the quick action on the right
    while (focused_qa < qa) {
        Send {Right}
        focused_qa++
    }

    ; Focus the quick action on the left
    while (focused_qa > qa) {
        Send {Left}
        focused_qa--
    }

    ; Send {Enter}
}


; Hotkeys

#Numpad1::QuickAction(1)
#Numpad2::QuickAction(2)
#Numpad3::QuickAction(3)
#Numpad4::QuickAction(4)
#Numpad5::QuickAction(5)
#Numpad6::QuickAction(6)
#Numpad7::QuickAction(7)
#Numpad8::QuickAction(8)
#Numpad9::QuickAction(9)

#If focused_qa
~LWin UP::QuickAction(false)
