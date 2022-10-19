#SingleInstance force
SetTitleMatchMode 2  ; Match anywhere

; -----------------------------------------------------------------------------
; Local library
; -----------------------------------------------------------------------------
RunWaitOne_PrepareHiddenWindow()
Zim_Launch()
#Include Lib\VD.ahk
#Include Lib\CycleOrLaunch.ahk
#Include Lib\MonitorianKeys.ahk
#Include Lib\PowerToysRunKeys.ahk
#Include Lib\Switch-Windows-same-App.ahk
; -----------------------------------------------------------------------------

; == End of auto-execute section ==============================================


; -----------------------------------------------------------------------------
; Development aids
; -----------------------------------------------------------------------------

; Reload this hotkey with a keybinding -- Remeber to save first!
#+F5::
	ToolTip % "============`n=   Reloading...   =`n============"
	Sleep 300
	Reload
	return

; Quickly open this project in VS Code
^#!F5::Run, %A_ComSpec% /c "code %A_ScriptDir%"

; -----------------------------------------------------------------------------
; Enhanced Windows desktop workflows
; -----------------------------------------------------------------------------

; More ergonomic window management
#+Q::SendInput !{F4}

; Cycle between File Explorer windows
^#!X::CycleOrLaunch("FileExplorer", "ahk_class CabinetWClass", "explorer.exe")

; Frequently accessed settings
#+O::Run SystemPropertiesAdvanced.exe

; Virtual desktops (courtesy of Ciantic/VirtualDesktopAccessor)
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


; I want to open a terminal with a hotkey
#+Enter::Run, CMD.EXE
#Enter::CycleOrLaunch("WindowsTerminal"
	,"ahk_class CASCADIA_HOSTING_WINDOW_CLASS ahk_exe WindowsTerminal.exe"
	, "wt.exe")


; -----------------------------------------------------------------------------
; Application shortcuts
; -----------------------------------------------------------------------------
^#!T::Run C:\Users\diogotito\AppData\Roaming\Telegram Desktop\Telegram.exe
^#!P::Run C:\Users\diogotito\AppData\Local\SumatraPDF\SumatraPDF.exe
^#!L::Run C:\Program Files\texstudio\texstudio.exe
^#!M::Run C:\Users\diogotito\AppData\Local\Programs\caprine\Caprine.exe
^#!O::Run C:\Users\diogotito\AppData\Local\Obsidian\Obsidian.exe

; -----------------------------------------------------------------------------
; Workflows
; -----------------------------------------------------------------------------

; Help & Documentation windows
^#!H::CycleOrLaunch("Docs"
	, [ "DevDocs ahk_class Chrome_WidgetWin_1"
	  , "ahk_class HH Parent" ]
	, "")

; Lib\Zim.ahk
#z::Zim()

; Sublime text
^#!S::CycleOrLaunch("SublimeText"
	, " - Sublime Text ahk_class PX_WINDOW_CLASS ahk_exe sublime_text.exe"
	, "subl")

; VS Code window group  -- because this takes 1 sec: ^#!C::RunWaitOne("code -r")
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
