;------------------------------------------------------------------------------
; Hotkeys to change monitor brightness through Monitorian
; Requires RunWaitOne_PrepareHiddenWindow() to have been run once
;------------------------------------------------------------------------------

; Scan code 29 is the `~ key
^#!sc029::Run ms-settings:nightlight
^#!+sc029::Run %A_ScriptDir%\bin\toggle_darkmode.rbw

#+PgUp::
	Run, Monitorian.exe /set all +15
	c := "[+] Increasing brightness...."
	SetTimer, showBrightness, -1 ; 1 ms timeout (-) to run in another "thread"
return

#+PgDn::
	Run, Monitorian.exe /set all -15
	c := "[-] Reducing brightness...."
	SetTimer, showBrightness, -1 ; 1 ms timeout (-) to run in another "thread"
return

#+sc029::
	SetTimer overlayBrightness, -1

	plus_or_minus := Chr(0x00B1)
	InputBox input_brightness, Set brightness,
	( LTrim
		Enter new value
		[%plus_or_minus%] 0 .. 100
	),, 162, 200,,,,, %input_brightness%

	ToolTip,,

	if ErrorLevel
		return
	if input_brightness is not Integer
		return
	if input_brightness not between -100 and +100
		return

	Run, Monitorian.exe /set all %input_brightness%
return

;------------------------------------------------------------------------------
; Auxiliary functions
;------------------------------------------------------------------------------

drawBar(brightness) {
	bar := ""
	Loop 15 {
		delta := (A_Index - 1)/(15) * 100 - brightness
		bar .= delta < 0 ? "#" : delta < (15) ? ": " : "- "
		; bar .= Format("[{:.2f}]", delta)
	}
	return bar
}

showBrightness() {
	global
	Gosub, UpdateTooltip
	output := RunWaitOne("Monitorian.exe /get all")
	brightness := StrSplit(output, A_Space)[3]
	MouseGetPos, mouseX, mouseY
	tipText := "Brightness: " brightness " / 100`n[" drawBar(brightness) "]"

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

overlayBrightness() {
	output := RunWaitOne("Monitorian.exe /get all")
	brightness := StrSplit(output, A_Space)[3]
	bar := drawBar(brightness)

	CoordMode ToolTip, Screen
	ToolTip,
	( LTrim
		[%brightness%] current brightness
		[%bar%]
	), % A_ScreenWidth / 2 - 85, % A_ScreenHeight / 2 - 45
}
