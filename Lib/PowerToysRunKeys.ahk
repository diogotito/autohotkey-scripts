; -----------------------------------------------------------------------------
; Emacs-style keybindings for PowerToys Run
; -----------------------------------------------------------------------------
#IfWinActive ahk_exe PowerToys.PowerLauncher.exe
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

; -----------------------------------------------------------------------------
; Launch PowerToys Run with a list of this desktop's windows, Switcheroo-style
; -----------------------------------------------------------------------------
#IfWinActive
	#w::
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
				tiptext .= Format("`n{1}   {2}"
				                 ,{-1: "[__]", 0: "[ r ]", 1: "[M]"}[win_minmax]
								 ,win_title ? win_title : "(" . win_process . ")")
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

    ; VS Code Workspaces plugin
    ^#C::SendInput !{Space}{{}
