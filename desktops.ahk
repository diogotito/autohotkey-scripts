#SingleInstance force
SetTitleMatchMode 2  ; Match anywhere

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
	ToolTip % "============`n=   Reloading...   =`n============"
	Sleep 500
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
; Edit %PATH%
; -----------------------------------------------------------------------------
#+O::
	Run SystemPropertiesAdvanced.exe
	WinWait ahk_exe SystemPropertiesAdvanced.exe
	Sleep 200
	MsgBox ola
	SendInput {Tab}{Tab}{Tab}{Space}
	MsgBox adeus
	return


; -----------------------------------------------------------------------------
; Application shortcuts
; -----------------------------------------------------------------------------
^#!T::Run C:\Users\diogotito\AppData\Roaming\Telegram Desktop\Telegram.exe
^#!S::Run subl
^#!C::Run "C:\Users\diogotito\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd" "-r"
^#C::SendInput !{Space}{{}
^#!M::Run C:\Users\diogotito\AppData\Local\Programs\caprine\Caprine.exe

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
; PowerToys Run
; -----------------------------------------------------------------------------
#IfWinActive
	#+w::
		switcheroo() {
			SendInput !{Space}^a{BackSpace}<{Space}

			WinGet id, List
			tiptext := "List of windows (" . id . "):"
			Loop %id%
			{
				win_id := id%A_Index%
				WinGetTitle win_title, ahk_id %win_id%
				WinGet win_process, ProcessName, ahk_id %win_id%
				WinGet win_minmax, MinMax, ahk_id %win_id%
				tiptext .= Format("`n{1}   {2}", {-1: "[__]", 0: "[ r ]", 1: "[M]"}[win_minmax], win_title ? win_title : "(" . win_process . ")")
			}
			ToolTip %tiptext%, 1400,30
			SetTimer check_powertoys_run, 50
			return

			check_powertoys_run:
				if (NOT WinActive("ahk_exe PowerToys.PowerLauncher.exe")) {
					ToolTip,,
					SetTimer check_powertoys_run, Off
				}
				return
		}

#IfWinActive ahk_exe PowerToys.PowerLauncher.exe
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
	!w::SendInput {End}+{Home}^x<{Space}^v{Home}^{Right}+{End}
	!s::SendInput {End}+{Home}^xd{Space}^v{Home}^{Right}+{End}

	; Custom shortcuts
	^,::SendEvent ^asettings
	