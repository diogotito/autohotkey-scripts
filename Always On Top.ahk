#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
# SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#If NOT WinActive("ahk_exe idea64.exe") ; IntelliJ binds ^!t to "Surround With"
	^!t::
	Winset, Alwaysontop, Toggle, A
	; animation
	Winset, Transparent, 192, A
	Sleep 100
	Winset, Transparent, 255, A
#if