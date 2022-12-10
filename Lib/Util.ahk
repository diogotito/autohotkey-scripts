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
