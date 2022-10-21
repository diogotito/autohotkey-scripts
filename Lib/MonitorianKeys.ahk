; -----------------------------------------------------------------------------
; Hotkeys to change monitor brightness through Monitorian
; Requires RunWaitOne_PrepareHiddenWindow() to have been run once
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
			SetTimer,, Off
		}
		return
}