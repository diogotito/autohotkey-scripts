_LAUNCH_TOOLTIP = 14
_GROUP_TOOLTIP = 15

; -----------------------------------------------------------------------------
; Switch to an app's window if it's running, otherwise launch it
; -----------------------------------------------------------------------------
CycleOrLaunch(group_name:="", win_criteria:="", launch_command:="") {
	if not group_name {
		group_name := _COL_GenerateGroupName()
	}
	group_name := "G_" . group_name
	win_criteria := IsObject(win_criteria) ? win_criteria : [win_criteria]

	; Add all criteria to group
	; Schedule launch_command to be launched when a failed attempt to activate
	; this group is made. 
	For i, criteria in win_criteria {
		if (i = 1 and launch_command) {
			GroupAdd, %group_name%, %criteria%,, when_no_match
		} else {
			GroupAdd, %group_name%, %criteria%
		}
	}

	; Try to activate the group now
	DetectHiddenWindows, On
	GroupActivate, %group_name%, R

	; Show which windows match this group if there are any
	if (ErrorLevel != 1) {
		_COL_ShowGroupInTooltip(group_name)
	}
	; Otherwise, AHK was told to execute when_no_match: below
	Return

	when_no_match:
		For i, criteria in win_criteria {
			if WinActive(criteria) {
				Return
			}
		}
		Run % launch_command

		ToolTip, ~~ Launching ~~`n%launch_command%,,, %_LAUNCH_TOOLTIP%
		WinWait % win_criteria[1]
		WinActivate % win_criteria[1]
		ToolTip,,,, %_LAUNCH_TOOLTIP%
		Return
}

; -----------------------------------------------------------------------------
; Utilities
; -----------------------------------------------------------------------------

_COL_GenerateGroupName() {
	Loop, 10 {
		Random, r, 65, 90  ; A-Z
		s .= Chr(r)
	}
	Return s
}

_COL_ShowGroupInTooltip(group_name) {
	text := "Windows in " SubStr(group_name, 3)
	text .= "`n--------------------------------------"
	For i, window in _COL_GetWindowsInGroup(group_name) {
		text .= "`n" (i == 1 ? "*" : i) ") " window.name
	}

	ToolTip, %text%,,, %_GROUP_TOOLTIP%
	SetTimer, dismiss_group_tooltip, -1000
	Return

	dismiss_group_tooltip:
		ToolTip,,,, %_GROUP_TOOLTIP%
		Return
}

_COL_GetWindowsInGroup(group_name) {
	Array := []
	WinGet, pseudo_array, List, ahk_group %group_name%
	Loop, %pseudo_array% {
		window_id := pseudo_array%A_Index%
		WinGetTitle, window_name, ahk_id %window_id%
		Array.Push({id: window_id, name: window_name})
	}
	return Array
}

StripModifiers(keyname) {
	Loop, Parse, keyname, &%A_Space%, ~!#$^*+<>
		return A_LoopField
}