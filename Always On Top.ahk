#If NOT WinActive("ahk_exe idea64.exe") ; IntelliJ binds ^!t to "Surround With"
	^!t::
	Winset, Alwaysontop, Toggle, A
	; animation
	Winset, Transparent, 192, A
	Sleep 100
	Winset, Transparent, 255, A
#if