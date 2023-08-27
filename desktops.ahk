#Requires AutoHotKey v1.1.33+
;==============================================================================
; desktops.ahk:
; The main script file that #Includes and defines many utilities and hotkeys
;------------------------------------------------------------------------------
; Organization:
;   1. Local library
;   2. Development aids
;   3. Hotstrings
;   4. Application shortcuts
;   5. Hotkeys to cycle between window groups -- see Lib\CycleOrLaunch.ahk
;   6. Misc hotkeys
;==============================================================================

#SingleInstance force

SetTitleMatchMode 2 ; Match anywhere

; This is a 16x16 pixel-art keyboard icon drawn by TOMAZ-DIONISIO
Menu Tray, Icon, Icons\KEYBOARD.ico

;------------------------------------------------------------------------------
; 1. Local library: Bring things from Lib\
;------------------------------------------------------------------------------
RunWaitOne_PrepareHiddenWindow()
Zim_Launch()
#Include <Util>
; !!! End of auto-execute section !!!  Only hotkeys/hotstrings from here on!
#Include <WindowsDesktopKeys>
#Include <MonitorianKeys>
#Include <PowerToysRunKeys>
#Include <Switch-Windows-same-App>
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; 2. Development aids
;------------------------------------------------------------------------------

; Exit the script
#+F4::
    ToolTip % "============`n= EXITING... =`n============"
    Sleep 500
ExitApp

; Reload this hotkey with a keybinding -- Remeber to save first!
^#!R::
#+F5::
    ToolTip % "============`n= Reloading... =`n============"
    Sleep 300
    Reload
return

; Quickly open this project in VS Code
^#!F5::Run, %A_ComSpec% /c "code %A_ScriptDir%"

;------------------------------------------------------------------------------
; 3. Hotstrings
;------------------------------------------------------------------------------
; TODO
; I haven't come up with good ideas for hotstrings and I never felt the need
; But there are a few in Hillel's blog: https://www.hillelwayne.com/post/ahk/
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; 4. Application shortcuts
;------------------------------------------------------------------------------
^#!A::Run C:\Program Files\AutoHotkey\WindowSpy.ahk
^#!T::Run C:\Users\diogotito\AppData\Roaming\Telegram Desktop\Telegram.exe
^#!P::Run C:\Users\diogotito\AppData\Local\SumatraPDF\SumatraPDF.exe
^#!M::Run C:\Users\diogotito\AppData\Local\Programs\caprine\Caprine.exe
^#!D::CycleOrLaunch("Discord"
    , ELECTRON("Discord")
    , "C:\Users\diogotito\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Discord Inc\Discord.lnk")
^#!E::CycleOrLaunch("Godot"
    , ["ahk_class Engine", "ahk_exe RPGVXAce.exe"]
    , "C:\tools\Godot\Godot_v4.0-stable_win64.exe")

;------------------------------------------------------------------------------
; 5. Hotkeys to cycle between window groups -- see Lib\CycleOrLaunch.ahk
;------------------------------------------------------------------------------

; Help & Documentation windows
^#!H::CycleOrLaunch("Docs"
    , [ "DevDocs " ELECTRON("msedge")
    , "ahk_class HH Parent"
    , "help ahk_class QWidget" ]
    , Func("LaunchDevDocs"))

HellYeah(msg:="DEFAULT!") {
    MsgBox % msg
}
LaunchDevDocs() {
    Run,
    ( LTrim Join`s
        "C:\Program Files (x86)\Microsoft\Edge\Application\msedge_proxy.exe"
        --profile-directory=Default
        --app-id=ahiigpfcghkbjfcibpojancebdfjmoop
        --app-url=https://devdocs.io/
        --app-launch-source=4
    ), "C:\Program Files (x86)\Microsoft\Edge\Application"
}

; Lib\Zim.ahk
#z::Zim()

; Cycle between File Explorer windows
^#!X::CycleOrLaunch("FileExplorer", "ahk_class CabinetWClass", "explorer.exe")

; 7-Zip File Manager
^#!Z::CycleOrLaunch("7zFM"
    , "ahk_class FM ahk_exe 7zFM.exe"
    , """C:\Program Files\7-Zip\7zFM.exe""")

; Obsidian
^#!O::CycleOrLaunch("Obsidian"
    , ELECTRON("Obsidian")
    , """C:\Users\diogotito\AppData\Local\Obsidian\Obsidian.exe""")

; Notion
^#!N::CycleOrLaunch("Notion"
    , ELECTRON("Notion")
    , """C:\Users\diogotito\AppData\Local\Programs\Notion\Notion.exe""")

; Sublime text
^#!S::CycleOrLaunch("SublimeText"
    , " - Sublime Text ahk_class PX_WINDOW_CLASS ahk_exe sublime_text.exe"
    , "subl")

; Neovim
^#!V::CycleOrLaunch("Neovim"
    , "Neovim ahk_exe nvim-qt.exe"
    , Func("LaunchNeovim"))

LaunchNeovim() {
    Run neovide, C:\Users\%A_UserName%\AppData\Local\nvim
}

; VS Code window group  -- because ^#!C::RunWaitOne("code -r") is a bit slow
^#!C::CycleOrLaunch("VSCode"
    , [" - Visual Studio Code " ELECTRON("Code")
    , "Clock ahk_class ApplicationFrameWindow"]
    , Func("RunWaitOne").Bind("""code"" --reuse-window"))

; Firefox, Chrome, Edge, etc.
^#!F::CycleOrLaunch("BrowserWindows"
    , "Mozilla Firefox ahk_class MozillaWindowClass"
    , "C:\Program Files\Mozilla Firefox\firefox.exe")

; Git GUI, gitk, Fork, SourceTree, WinMerge, you name it
^#!G::CycleOrLaunch("GitGUIs"
    , [ "Git Gui ahk_class TkTopLevel ahk_exe wish.exe"
    , "gitk ahk_class TkTopLevel ahk_exe wish.exe"
    , "WinMerge ahk_class WinMergeWindowClassW"
    , "Fork ahk_exe Fork.exe"])

;------------------------------------------------------------------------------
; 6. Misc hotkeys
;------------------------------------------------------------------------------

#^#!Q::qrencode() ; Lib\qrencode.ahk

; Open Bitwarden and click "Unlock with Windows Hello"
^#!B::
    OpenBitwarden() {
        Run "C:\Program Files\Bitwarden\Bitwarden.exe"
        WinWait % "Bitwarden " ELECTRON("Bitwarden")
        WinGetPos X, Y, Width, Height
        btn_x := X + Width / 2 + 65
        btn_y := Y + Height / 2 + 150
        DllCall("SetCursorPos", "int", btn_x, "int", btn_y)
        MouseClick
    }

#IfWinActive VLC media player ahk_exe vlc.exe
^+S::
    Util_LogToolTip("> Taking VLC Snapshot (Ctrl+S)`n")
    SendInput +S
    Sleep 200

    Util_LogToolTip("> Locating PNG...")
    vlcsnap := ES_LatestFile("vlcsnap-*.png")
    if vlcsnap is not space
    {
        Util_LogToolTip(" " vlcsnap "`n")
        Util_LogToolTip("Launching Paint.NET...")
        Run C:\Program Files\paint.net\paintdotnet.exe "%vlcsnap%"
        WinWait "paint.net",, 1
    }
    Util_LogToolTip()
return

#IfWinActive Defold Editor
    F5::
        SendInput, ^s^b
        ToolTip, F5 >>> Ctrl + B`nBuild Project
        Sleep 500
        ToolTip,,
    return

;------------------------------------------------------------------------------
; RPG Maker VX Ace
;------------------------------------------------------------------------------
#IfWinActive Script Editor ahk_exe RPGVXAce.exe
    #IncludeAgain <ReadlineKeys>
    ^S::Send !A
    ^R::
        Send !A
        WinClose
        Send ^S
        Send {F12}
        Send !Y
    return
#IfWinActive RPG Maker VX Ace ahk_exe RPGVXAce.exe
    ^!S::Send {F11} ; Script Editor
    ^!D::Send {F9} ; Database
    ^R::
        Send ^S
        Send {F12}
        Send !Y
    return

;------------------------------------------------------------------------------
; Add a few force-of-habit convenience shortcuts for the 7-Zip File Manager
;------------------------------------------------------------------------------
#IfWinActive ahk_class FM ahk_exe 7zFM.exe
    ^Q::WinClose
    ^W::WinClose
    ^B::Send {F9} ; Toggle 2 panels
    ^L::
        ; Focus the "address bar" of the active pane
        ControlGetFocus focused_control
        if RegExMatch(focused_control, "32\K[12]$", one_or_two) {
            ControlFocus Edit%one_or_two%
        }
    Return

;------------------------------------------------------------------------------
; Ctrl+Tab to switch between the two MRU tabs in Microsoft Edge using QuicKey
;------------------------------------------------------------------------------
#IfWinActive ahk_class Chrome_WidgetWin_1 ahk_exe msedge.exe
    ^Tab::SendInput !z
    ^+Tab::SendInput !q

;------------------------------------------------------------------------------
; TeXstudio (MRU)
;------------------------------------------------------------------------------

#IfWinActive
^#!L::CycleOrLaunch("TeXstudio"
    , "TeXstudio ahk_class Qt650QWindowIcon ahk_exe texstudio.exe"
    , "C:\Program Files\texstudio\texstudio.exe")

#IfWinActive TeXstudio
    ^Tab::SendInput ^o{Enter}
    ^+Tab::SendInput ^o{Enter}

;------------------------------------------------------------------------------
; Firefox's Awesome Bar shortcuts
;------------------------------------------------------------------------------
#IfWinActive Mozilla Firefox
    !+2::SendInput ^l+2 ; search engines
    !+3::SendInput ^l+3{Space} ; every search term is part of title or tag
    !+4::SendInput ^l+4{Space} ; every search term is part of the URL
    !+5::SendInput ^l+5{Space} ; open tabs
    !+6::SendInput ^l+6{Space} ; history
    !+8::SendInput ^l+8{Space} ; bookmarks
    !+=::SendInput ^l+={Space} ; bookmarks with tags
    !+?::
        ToolTip,
        ( LTrim %
            Autocomplete modifiers
            ~~~~~~~~~~~~~~~~
            Search Engines`t2  @
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

    ; macOS-style Preferences shortcut
    ^,::SendInput ^labout:preferences!{Enter}

    ; Activate context menu entries with {Space}
    ~Space::
        MouseGetPos,,, m_win_id, m_ctl
        WinGetClass m_winclass, ahk_id %m_win_id%
        if (m_winclass = "MozillaDropShadowWindowClass") {
            SendInput {Enter}
        }
    Return

    ; :imap jk <Esc> in Vim modes
    !+V::SendEvent {Esc}:imap jk <C-[>{Enter}

#IfWinActive