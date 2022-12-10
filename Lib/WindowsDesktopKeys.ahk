;==============================================================================
; Windows Desktop hotkeys:
; Hotkeys for core Windows apps and window/workspace management
;------------------------------------------------------------------------------
; Organization:
;   1. General hotkeys
;   2. File Explorer enhancements
;   3. Cybernetically enhanced charmap.exe
;   4. Virtual desktops
;==============================================================================

;------------------------------------------------------------------------------
; 1. General hotkeys
;------------------------------------------------------------------------------

; More ergonomic window management
#+Q::SendInput !{F4}

; Get to the %PATH% quicker
#+O::Run SystemPropertiesAdvanced.exe

; I want to open a terminal with a hotkey
#+Enter::Run, CMD.EXE
#Enter::CycleOrLaunch("WindowsTerminal"
    ,"ahk_class CASCADIA_HOSTING_WINDOW_CLASS ahk_exe WindowsTerminal.exe"
    , "wt.exe")

;------------------------------------------------------------------------------
; 2. File Explorer enhancements
;------------------------------------------------------------------------------
InputFocusIn(control, win_title) {
    ControlGetFocus focused_control, %win_title%
    Return focused_control == control
}

#IfWinActive ahk_class CabinetWClass ahk_exe explorer.exe
    !+C::SendInput ^l^aC:\
    !+D::SendInput ^l^aD:\
    !+E::SendInput ^l^aE:\{Enter}
    !+T::SendInput ^l^aT:\
    ~::SendInput ^l^a`%USERPROFILE`%\
    |::SendInput ^l^a`%USERPROFILE`%\
    !+S::SendInput ^l^asubl -d .{Enter} ; Open Sublime Text here
    !+V::SendInput ^l^acode .{Enter} ; Open VS Code here
    !+W::SendInput ^l^awt nt -d .{Enter} ; Open Windows Terminal here
    !+N::SendInput ^l^aserve.cmd .{Enter} ; Run a dev. static file server here
    ^Tab::GroupActivate G_FileExplorer, R
    +^Tab::GroupActivate G_FileExplorer
#If InputFocusIn("Edit1", "ahk_class CabinetWClass ahk_exe explorer.exe")
    #IncludeAgain <ReadlineKeys>
    /::\
    Tab::SendInput {Down}
    +Tab::SendInput {Up}
#If

;------------------------------------------------------------------------------
; 3. Cybernetically enhanced charmap.exe
;------------------------------------------------------------------------------
#C::
    CycleOrLaunch("charmap", "Character Map ahk_exe charmap.exe", "charmap.exe")
    WinShow Character Map ahk_exe charmap.exe
    ControlFocus, Edit2, Character Map ahk_exe charmap.exe
Return

#IfWinActive Character Map ahk_exe charmap.exe
    ^F::ControlFocus Edit2
    ^H::ControlSend RICHEDIT50W1, {BackSpace}
    ^BackSpace::Send ^+{Left}{BackSpace}
    Esc::WinHide

    ; Control the character grid, Vim-style
    !h::ControlSend CharGridWClass1, {Left}
    !j::ControlSend CharGridWClass1, {Down}
    !k::ControlSend CharGridWClass1, {Up}
    !l::ControlSend CharGridWClass1, {Right}

    ; Quickly copy the highlighted character in the grid and hide Character Map
    ^C::
        SetControlDelay 100
        ControlSetText RICHEDIT50W1, % ""
        ControlClick Button1
        ControlClick Button2
        WinHide
    Return
#IfWinActive

;------------------------------------------------------------------------------
; 4. Virtual desktops (courtesy of Ciantic/VirtualDesktopAccessor)
;------------------------------------------------------------------------------
; BTW https://github.com/Grabacr07/SylphyHorn goes well with this
; I use it to:
;   * Show the current desktop number / number of total desktops in the tray
;   * Move windows to adjacent desktops with keyboard shortcuts
;------------------------------------------------------------------------------
#Include <VD>

#n::VD_GoToNextDesktop()
#+n::VD_GoToPrevDesktop()

^#!1::
^#!Numpad1::
    VD_GoToDesktopNumber(0)
Return

^#!2::
^#!Numpad2::
    VD_GoToDesktopNumber(1)
Return

^#!3::
^#!Numpad3::
    VD_GoToDesktopNumber(2)
Return

^#!4::
^#!Numpad4::
    VD_GoToDesktopNumber(3)
Return

^#!5::
^#!Numpad5::
    VD_GoToDesktopNumber(4)
Return

^#!6::
^#!Numpad6::
    VD_GoToDesktopNumber(5)
Return

^#!7::
^#!Numpad7::
    VD_GoToDesktopNumber(6)
Return

^#!8::
^#!Numpad8::
    VD_GoToDesktopNumber(7)
Return

^#!9::
^#!Numpad9::
    VD_GoToDesktopNumber(8)
Return

^#!0::
^#!Numpad0::
    VD_GoToDesktopNumber(9)
Return