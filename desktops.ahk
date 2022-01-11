; SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

; ----------------------------------------------------------------------------------------
; For running commands and capturing their output without an annoying window showing up
; ----------------------------------------------------------------------------------------
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
; ----------------------------------------------------------------------------------------


; 1) I hate Alt + F4
#+Q::
	SendInput !{F4}
	return

; 2) I want to open a terminal with a hotkey
#+Enter::
	Run, cmd.exe
	return

#Enter::
	Run, wt.exe
	return


; Monitor brightness through Monitorian

#+NumpadAdd::
	Run, Monitorian.exe /set all +15
	SetTimer, showBrightness, -100
	return

#+NumpadSub::
	Run, Monitorian.exe /set all -15
	SetTimer, showBrightness, -100
	return

#+F5::
	Reload
	return

showBrightness() {
	output := RunWaitOne("Monitorian.exe /get all")
	ToolTip, % "Brightness:`n" StrSplit(output, A_Space)[3]
	Sleep, 1000
	ToolTip,,
}




; Always On Top

#If NOT WinActive("ahk_exe idea64.exe") ; IntelliJ binds ^!t to "Surround With"
	^!t::
	Winset, Alwaysontop, Toggle, A
	; animation
	Winset, Transparent, 192, A
	Sleep 100
	Winset, Transparent, 255, A
#if
