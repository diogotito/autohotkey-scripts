LAUNCH_TOOLTIP = 14
GROUP_TOOLTIP = 15

; -----------------------------------------------------------------------------
; Switch to an app's window if it's running, otherwise launch it
; -----------------------------------------------------------------------------
CycleOrLaunch(group_name:="", win_criteria:="", launch_command:="") {
	if not group_name {
		group_name := GenerateGroupName()
	}
	group_name := "G_" . group_name

	DetectHiddenWindows, On
	GroupAdd, %group_name%, %win_criteria%,, % launch_command ? "no_match" : ""
	GroupActivate, %group_name%, R
	ShowGroupInTooltip(group_name)
	Return

	no_match:
		if (WinActive(win_criteria)) {
			Return
		}
		ToolTip, ~~ Launching ~~`n%launch_command%,,, LAUNCH_TOOLTIP
		Run % launch_command
		WinWait % win_criteria
		WinActivate % win_criteria
		ToolTip,,,, LAUNCH_TOOLTIP
		Return
}


GenerateGroupName() {
	Loop, 10 {
		Random, r, 65, 90  ; A-Z
		s .= Chr(r)
	}
	Return s
}

ShowGroupInTooltip(group_name) {
	ToolTip, % "Windows in " SubStr(group_name, 3),,, GROUP_TOOLTIP
	SetTimer, dismiss_tooltip, -1000
	Return

	dismiss_tooltip:
		ToolTip,,,, GROUP_TOOLTIP
		Return
}