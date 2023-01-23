;------------------------------------------------------------------------------
; Characters and Strings
;------------------------------------------------------------------------------
Chr_Bullet := Chr(0x2022)
Chr_Shift := Chr(0x21D1)
Chr_Tab := Chr(0x21B9)
Chr_Win := Chr(0x229E)
Str_Indent := A_Space . A_Space . A_Space . A_Space
Str_LI := Str_Indent . Chr_Bullet

;------------------------------------------------------------------------------
; Group setup
;------------------------------------------------------------------------------
GroupAdd Dialog, % "ahk_class #32770"
GroupAdd FileExplorer, ahk_class CabinetWClass

;------------------------------------------------------------------------------
; LogToolTip() clears and hides the tooltip
; LogToolTip(text) appends text to the tooltip and shows it
;------------------------------------------------------------------------------
Util_LogToolTip(newText := "") {
    static text := ""
    if (newText) {
        text .= newText
        ToolTip % text, 0, 0
    } else {
        text := ""
        ToolTip,,
    }
}

ELECTRON(exe := "") {
    return "ahk_class Chrome_WidgetWin_1" . (exe ? " ahk_exe " exe ".exe" : "")
}