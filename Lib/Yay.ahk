MsgBox,, , OH HAI, 0.5

Yay() {
    ToolTip, Yaaaaaay!,,, tooltip_yay
    SetTimer, dismiss_tooltip, -1000
    Return

    dismiss_tooltip:
        ToolTip,,,, tooltip_yay
        Return
}