; Setup
#SingleInstance, Force
#MaxThreadsPerHotkey, 1 ; no re-entrant hotkey handling
SetKeyDelay, 80, 20 ; in milliseconds

; Action bar management
ActionBarOpened := FALSE

FocusActionBarButtons() {
    global ActionBarOpened
    Send #a
    Send +{Tab}
    Send +{Tab}
    Send {Tab}
    ActionBarOpened := TRUE
}

CloseActionBar() {
    global ActionBarOpened
    Send {Esc}
    ActionBarOpened := FALSE
}

; Hotkeys
#NumpadMult::
    if (not ActionBarOpened) {
        FocusActionBarButtons()
    }
    Send {Enter}
    return

#NumpadDiv::
    if (not ActionBarOpened) {
        FocusActionBarButtons()
        Send {Right}
    }
    Send {Enter}
    return

#If ActionBarOpened
~LWin UP::
    CloseActionBar()
    return