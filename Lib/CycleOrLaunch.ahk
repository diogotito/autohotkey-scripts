; =============================================================================
; CycleOrLaunch(group_name:="", win_criteria:=[""], launch_command:="")
; Switch to an app's window if it's running, otherwise launch it
; -----------------------------------------------------------------------------
; Actually, AHK already of does most of this out of the box!!
; I could just call GroupAdd to setup all the groups, all at once, in the 
; auto-execute section, and then write hotkeys to GroupActivate them.
; The annoying thing is that as soon as a hotkey is declared, the auto-execute
; section ends, and GroupAdd simply doesn't run anymore, so I can't configure
; my window groups near the hotkeys that use them!
; All this file does is build a sort of more declarative API so that I can
; write group criteria right under the hotkeys that activate it.
; -----------------------------------------------------------------------------
; Ugh... This ended up taking too many hours for what it is.
; At least it was a good exercise in AHK and setting up VS Code to debug this.
; =============================================================================

global _TOOLTIP_LAUNCH = 14
global _TOOLTIP_GROUP = 15

; -----------------------------------------------------------------------------
; Entry point
; -----------------------------------------------------------------------------
CycleOrLaunch(group_name:="", win_criteria:="", launch_command:="") {
    _COL_uniformalize_args(group_name, win_criteria)  ; Passed ByRef
    _COL_SetupGroup(group_name, win_criteria, launch_command)

    ; Try to activate the group now
    ; This will `GoSub when_no_match` if this group doesn't match any window
    DetectHiddenWindows, On
    GroupActivate, %group_name%, R

    ; Show which windows match this group if there are any
    if (ErrorLevel != 1) {
        _COL_ShowGroupInTooltip(group_name)
    }
    Return

    when_no_match:
        ; TODO Isn't this loop redundant?
        For i, criteria in win_criteria {
            if WinActive(criteria) {
                Return
            }
        }

        ; Do the actual launching
        if IsObject(launch_command) {
            launch_command.Call()
        } else {
            Run % launch_command
        }

        ; Notify that the launch is happening...
        ToolTip, ~~ Launching ~~`n%launch_command%,,, %_TOOLTIP_LAUNCH%
        WinWait % win_criteria[1],, 5
        if not ErrorLevel {
            ; Success! Switch to the newly launched app right away!
            WinActivate % win_criteria[1]
        } else {
            ToolTip, !! Timeout: 5 seconds !!,,, %_TOOLTIP_LAUNCH%
            Sleep, 1000
        }
        ToolTip,,,, %_TOOLTIP_LAUNCH%
        Return
}

; -----------------------------------------------------------------------------

_COL_uniformalize_args(ByRef group_name, ByRef win_criteria) {
    if not group_name {
        group_name := _COL_GenerateGroupName()
    }
    group_name := "G_" . group_name
    win_criteria := IsObject(win_criteria) ? win_criteria : [win_criteria]
}

_COL_SetupGroup(group_name, win_criteria, launch_command) {
    ; Cache group names to repeat redundant GroupAdds
    static memo := {}
    memo_key := _COL_Flatten(win_criteria)
    If memo.HasKey(memo_key) {
        ; MsgBox, % "Memo: memo[" win_criteria "] = " memo[win_criteria]
        ; No need to GroupAdd again -- it would be ignored anyways
        Return memo[memo_key]
    }
    memo[memo_key] := group_name

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

    ; Return the group name that will GroupActivate this.
    Return group_name
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

_COL_Flatten(criteria_array) {
    For Key, Value in criteria_array {
        ret .= "[" Key "]" Value
    }
    Return ret
}

; -----------------------------------------------------------------------------
; Gratuitous bling
; -----------------------------------------------------------------------------

_COL_ShowGroupInTooltip(group_name) {
    windows_in_group := _COL_GetWindowsInGroup(group_name)
    if windows_in_group.Count() = 1 {
        Return
    }
    text := "----- " SubStr(group_name, 3) " -----"
    For i, window in windows_in_group {
        text .= "`n"
        text .= (i = 1) ? "**" : window.is_newest ? ">" : i
        text .= ") "
        text .= window.name
    }

    ToolTip, %text%,,, %_TOOLTIP_GROUP%
    SetTimer, dismiss_group_tooltip, -1000
    Return

    dismiss_group_tooltip:
        ToolTip,,,, %_TOOLTIP_GROUP%
        Return
}

_COL_GetWindowsInGroup(group_name) {
    Array := []
    WinGet, pseudo_array, List, ahk_group %group_name%
    Loop, %pseudo_array% {
        window_id := pseudo_array%A_Index%
        WinGetTitle, window_name, ahk_id %window_id%
        Array.Push({ id: window_id
                   , name: window_name
                   , is_newest: A_Index = pseudo_array })
    }
    return Array
}

StripModifiers(keyname) {
    ; gosh AHK is such a weird language. I'm saving this!
    Loop, Parse, keyname, &%A_Space%, ~!#$^*+<>
        return A_LoopField
}