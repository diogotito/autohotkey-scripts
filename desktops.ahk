; =============================================================================
; desktops.ahk:
; The entry point to a bunch of utilities and hotkeys
; -----------------------------------------------------------------------------
; Organization:
;   1. Local library
;   2. Development aids
;   3. Enhanced Windows desktop workflows
;   4. Hotstrings
;   5. Application shortcuts
;   6. Hotkeys to cycle between window groups -- see Lib\CycleOrLaunch.ahk
;   7. Misc hotkeys
; =============================================================================

#SingleInstance force
SetTitleMatchMode 2  ; Match anywhere

; -----------------------------------------------------------------------------
; 1. Local library
; -----------------------------------------------------------------------------
RunWaitOne_PrepareHiddenWindow()
Zim_Launch()
#Include Lib\VD.ahk
#Include Lib\CycleOrLaunch.ahk
; !!! End of auto-execute section !!!  Only hotkeys/hotstrings from here on!
#Include Lib\MonitorianKeys.ahk
#Include Lib\PowerToysRunKeys.ahk
#Include Lib\Switch-Windows-same-App.ahk
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
; 2. Development aids
; -----------------------------------------------------------------------------

; Exit the script
#+F4::
    ToolTip % "============`n=   EXITING...   =`n============"
    Sleep 500
    ExitApp

; Reload this hotkey with a keybinding -- Remeber to save first!
#+F5::
    ToolTip % "============`n=   Reloading...   =`n============"
    Sleep 300
    Reload
    return

; Quickly open this project in VS Code
^#!F5::Run, %A_ComSpec% /c "code %A_ScriptDir%"

; -----------------------------------------------------------------------------
; 3. Enhanced Windows desktop workflows
; -----------------------------------------------------------------------------

; More ergonomic window management
#+Q::SendInput !{F4}

; Cycle between File Explorer windows
^#!X::CycleOrLaunch("FileExplorer", "ahk_class CabinetWClass", "explorer.exe")

; Frequently accessed settings
#+O::Run SystemPropertiesAdvanced.exe

; I want to open a terminal with a hotkey
#+Enter::Run, CMD.EXE
#Enter::CycleOrLaunch("WindowsTerminal"
    ,"ahk_class CASCADIA_HOSTING_WINDOW_CLASS ahk_exe WindowsTerminal.exe"
    , "wt.exe")

; Virtual desktops (courtesy of Ciantic/VirtualDesktopAccessor)
; BTW https://github.com/Grabacr07/SylphyHorn goes well with this
; I use it to:
;   * Show the current desktop number / number of total desktops in the tray
;   * Move windows to adjacent desktops with keyboard shortcuts
#n::VD_GoToNextDesktop()
#+n::VD_GoToPrevDesktop()

^#!1::
^#!Numpad1::VD_GoToDesktopNumber(0)

^#!2::
^#!Numpad2::VD_GoToDesktopNumber(1)

^#!3::
^#!Numpad3::VD_GoToDesktopNumber(2)

^#!4::
^#!Numpad4::VD_GoToDesktopNumber(3)

^#!5::
^#!Numpad5::VD_GoToDesktopNumber(4)

^#!6::
^#!Numpad6::VD_GoToDesktopNumber(5)

^#!7::
^#!Numpad7::VD_GoToDesktopNumber(6)

^#!8::
^#!Numpad8::VD_GoToDesktopNumber(7)

^#!9::
^#!Numpad9::VD_GoToDesktopNumber(8)

^#!0::
^#!Numpad0::VD_GoToDesktopNumber(9)


; -----------------------------------------------------------------------------
; 4. Hotstrings
; -----------------------------------------------------------------------------
; TODO
; I haven't come up with good ideas for hotstrings and I never felt the need
; But there are a few in Hillel's blog: https://www.hillelwayne.com/post/ahk/

; -----------------------------------------------------------------------------
; 5. Application shortcuts
; -----------------------------------------------------------------------------
^#!T::Run C:\Users\diogotito\AppData\Roaming\Telegram Desktop\Telegram.exe
^#!P::Run C:\Users\diogotito\AppData\Local\SumatraPDF\SumatraPDF.exe
^#!L::Run C:\Program Files\texstudio\texstudio.exe
^#!M::Run C:\Users\diogotito\AppData\Local\Programs\caprine\Caprine.exe
^#!O::Run C:\Users\diogotito\AppData\Local\Obsidian\Obsidian.exe

; -----------------------------------------------------------------------------
; 6. Hotkeys to cycle between window groups -- see Lib\CycleOrLaunch.ahk
; -----------------------------------------------------------------------------

; Help & Documentation windows
^#!H::CycleOrLaunch("Docs"
    , [ "DevDocs ahk_class Chrome_WidgetWin_1"
      , "ahk_class HH Parent"
      , "help ahk_class QWidget" ]
    , Func("HellYeah").Bind("NOT THE DEFAULT MESSAGE !!"))

HellYeah(msg:="DEFAULT!") {
    MsgBox % msg
}

; Lib\Zim.ahk
#z::Zim()

; 7-Zip File Manager
^#!Z::CycleOrLaunch("7zFM"
    , "ahk_class FM ahk_exe 7zFM.exe"
    , """C:\Program Files\7-Zip\7zFM.exe""")

; Sublime text
^#!S::CycleOrLaunch("SublimeText"
    , " - Sublime Text ahk_class PX_WINDOW_CLASS ahk_exe sublime_text.exe"
    , "subl")

; VS Code window group  -- because ^#!C::RunWaitOne("code -r") is a bit slow
^#!C::CycleOrLaunch("VSCode"
    , " - Visual Studio Code ahk_class Chrome_WidgetWin_1 ahk_exe Code.exe"
    , """code"" --reuse-window")

^#!F::CycleOrLaunch("BrowserWindows"
    , "Mozilla Firefox ahk_class MozillaWindowClass"
    , "C:\Program Files\Mozilla Firefox\firefox.exe")
^#!+F::Run "C:\Program Files\Mozilla Firefox\firefox.exe"

^#!G::CycleOrLaunch("GitGUIs"
    , [ "Git Gui ahk_class TkTopLevel ahk_exe wish.exe"
      , "gitk ahk_class TkTopLevel ahk_exe wish.exe"
      , "WinMerge ahk_class WinMergeWindowClassW"
      , "Fork ahk_class HwndWrapper[Fork.exe;; ahk_exe Fork.exe"])


; -----------------------------------------------------------------------------
; 7. Misc hotkeys
; -----------------------------------------------------------------------------

; Open Bitwarden and click "Unlock with Windows Hello"
^#!B::
    OpenBitwarden() {
        Run "C:\Program Files\Bitwarden\Bitwarden.exe"

        CRITERIA = Bitwarden ahk_exe Bitwarden.exe ahk_class Chrome_WidgetWin_1

        WinWait %CRITERIA%
        WinGetPos X, Y, Width, Height
        btn_x := X + Width  / 2 + 65
        btn_y := Y + Height / 2 + 145
        DllCall("SetCursorPos", "int", btn_x, "int", btn_y)
        MouseClick
    }

#IfWinActive Defold Editor
    F5::
        SendInput, ^s^b
        ToolTip, F5 >>> Ctrl + B`nBuild Project
        Sleep 500
        ToolTip,,
        return


; -----------------------------------------------------------------------------
; Ctrl+Tab to switch between the two MRU tabs in Microsoft Edge using QuicKey
; -----------------------------------------------------------------------------
#IfWinActive ahk_class Chrome_WidgetWin_1 ahk_exe msedge.exe
    ^Tab::SendInput !z
    ^+Tab::SendInput !q


; -----------------------------------------------------------------------------
; TeXstudio (MRU)
; -----------------------------------------------------------------------------
#IfWinActive TeXstudio
    ^Tab::SendInput ^o{Enter}
    ^+Tab::SendInput ^o{Enter}


; -----------------------------------------------------------------------------
; Firefox's Awesome Bar shortcuts
; -----------------------------------------------------------------------------
#IfWinActive Mozilla Firefox
    !+3::SendInput ^l+3{Space}  ; every search term is part of title or tag
    !+4::SendInput ^l+4{Space}  ; every search term is part of the URL
    !+5::SendInput ^l+5{Space}  ; open tabs
    !+6::SendInput ^l+6{Space}  ; history
    !+8::SendInput ^l+8{Space}  ; bookmarks
    !+=::SendInput ^l+={Space}  ; bookmarks with tags
    !+?::
        ToolTip,
        ( LTrim %
            Autocomplete modifiers
            ~~~~~~~~~~~~~~~~
            Title or tag`t3  # 
            URL`t`t4  $ 
            Open tabs`t5  % 
            History`t`t6  ^ 
            Bookmarks`t8   * 
            Tags`t`t    +
            Search suggestions     ?
        )
        Sleep 5000
        ToolTip,,
        Return
