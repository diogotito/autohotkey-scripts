; Match anywhere
SetTitleMatchMode, 2

;
; TODO #z para abrir a janela do/arrancar o Zim
;

; -----------------------------------------------------------------------------
; Run commands and capture their output without an annoying window showing up
; -----------------------------------------------------------------------------
DllCall("AllocConsole")
WinHide % "ahk_id " DllCall("GetConsoleWindow", "ptr")

RunWaitOne(command) {
    ; WshShell object: http://msdn.microsoft.com/en-us/library/aew9yb99 ¬
    shell := ComObjCreate("WScript.Shell")
    ; Execute a single command via cmd.exe
    exec := shell.Exec(ComSpec " /C " command)
    ; Read and return the command's output
    return exec.StdOut.ReadAll()
}
; -----------------------------------------------------------------------------

#+F5::
	MsgBox,, desktops.ahk, Reloading..., 500
	Reload
	return


#+Q::
	SendInput !{F4}
	return

; -----------------------------------------------------------------------------
; I want to open a terminal with a hotkey
; -----------------------------------------------------------------------------
#+Enter::
	Run, cmd.exe   ; Shows up instantly and doesnt't take 1 to 30 seconds to start up
	return

#Enter::
	Run, wt.exe    ; Fancy PowerShell in fancy Windows Terminal
	return


; -----------------------------------------------------------------------------
; Monitor brightness through Monitorian
; -----------------------------------------------------------------------------
#+NumpadAdd::
	Run, Monitorian.exe /set all +15
	c := "[+] Increasing brightness...."
	SetTimer, showBrightness, -1  ; 1 ms timeout (-) to run in another "thread"
	return

#+NumpadSub::
	Run, Monitorian.exe /set all -15
	c := "[-] Reducing brightness...."
	SetTimer, showBrightness, -1  ; 1 ms timeout (-) to run in another "thread"
	return

showBrightness() {
	global
	; ListVars
	Gosub, UpdateTooltip
	output := RunWaitOne("Monitorian.exe /get all")
	brightness := StrSplit(output, A_Space)[3]
	bar := ""
	MouseGetPos, mouseX, mouseY
	Loop, 15 {
		delta := (A_Index - 1)/(15) * 100 - brightness
		; bar .= Format("[{:.2f}]", delta)
		bar .= delta < 0 ? "#" : delta < (15) ? ": " : "- "
	}
	tipText := "Brightness: " brightness " / 100`n[" bar "]"

	CoordMode, ToolTip, Screen
	; c := "_______________"
	SetTimer, UpdateTooltip, 30
	return

	UpdateTooltip:
		if c := SubStr(c, 1, -1) {
			ToolTip, % c . "`n" . tipText, % mouseX, % mouseY
		} else {
			ToolTip,,
			SetTimer, UpdateTooltip, Off
		}
		return
}


; -----------------------------------------------------------------------------
; Application shortcuts
; -----------------------------------------------------------------------------
^#T::Run C:\Users\diogotito\AppData\Roaming\Telegram Desktop\Telegram.exe

AppKey(executable, winCriteria) {
	Run %executable%
	WinWait %winCriteria%
	WinActivate
}

^#S::Run subl
^#C::Run "C:\Program Files\Microsoft VS Code\bin\code.cmd" "-r"


; -----------------------------------------------------------------------------
; Always On Top
; -----------------------------------------------------------------------------
#If NOT WinActive("ahk_exe idea64.exe") ; IntelliJ binds ^!t to "Surround With"
	^!t::
		Winset, Alwaysontop, Toggle, A
		; animation
		Winset, Transparent, 192, A
		Sleep 100
		Winset, Transparent, 255, A
		return
#if

#IfWinActive Defold Editor
	F5::
		SendInput, ^s^b
		ToolTip, F5 >>> Ctrl + B`nBuild Project
		Sleep 500
		ToolTip,,
		return


; -----------------------------------------------------------------------------
; Wox
; -----------------------------------------------------------------------------
#IfWinActive Wox ahk_exe Wox.exe
	; Emacs-style keybindings
	^b::SendInput {Left}
	^f::SendInput {Right}
	!b::SendInput ^{Left}      ; word left
	!f::SendInput ^{Right}     ; word right
	!a::SendInput {Home}       ; end
	!e::SendInput {End}        ; beginning of line
	^e::SendInput {End}        ; beginning of line
	+!b::SendInput +^{Left}    ; 
	+!f::SendInput +^{Right}   ; 
	+^a::SendInput +{Home}     ; 
	+^e::SendInput +{End}      ; 
	^w::SendInput ^+{Left}^x
	!BackSpace::SendInput ^+{Left}^x
	!d::SendInput ^+{Right}^x
	^u::SendInput +{Home}^x
	!k::SendInput +{End}^x
	^y::SendInput ^v
	!r::SendInput ^a{BackSpace}
	^m::SendInput {Enter}

	; Custom prefixes
	!w::SendInput {End}+{Home}^xwin{Space}^v{Home}^{Right}+{End}
	!s::SendInput {End}+{Home}^xd{Space}^v{Home}^{Right}+{End}

	; Custom shortcuts
	^,::SendEvent ^asettings
	