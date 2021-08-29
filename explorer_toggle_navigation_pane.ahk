#SingleInstance, Force
; #KeyHistory, 0
SendMode Input ; Forces Send and SendRaw to use SendInput buffering for speed.
; SetTitleMatchMode, 3 ; A window's title must exactly match WinTitle to be a match.
; #MaxThreadsPerHotkey, 1 ; no re-entrant hotkey handling
; SetWinDelay, -1 ; Remove short delay done automatically after every windowing command except IfWinActive and IfWinExist
SetKeyDelay, -1, -1 ; Remove short delay done automatically after every keystroke sent by Send or ControlSend
; SetMouseDelay, -1 ; Remove short delay done automatically after Click and MouseMove/Click/Drag

#IfWinActive 
!n::
    Send {Alt}vn{Enter}
    return