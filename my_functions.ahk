Show(what, timeout:=1000) {
    ToolTip, %what%
    SetTimer, HideTooltip, % -timeout
    return
    
    HideTooltip:
        ToolTip,
        return
}