; -----------------------------------------------------------------------------
; Switch to an app's window if it's running, otherwise launch it
; -----------------------------------------------------------------------------
CycleOrLaunch(win_criteria, launch_command) {
	; Find cloaked windows (i.e. in a non-active virtual desktop) too
	DetectHiddenWindows, On

	if not WinExist(win_criteria) {
		Run % launch_command
		WinWait % win_criteria
	}
	WinActivate % win_criteria
}