ListLines

#^B::
{
    lol := WinActive()
    i := 1
    Loop 10 {
        i .= A_Index
    }
    MsgBox("Yo", 100 / 15)
    MsgBox("Yo", 100 // 15)
    ToolTip i
    SetTimer () => ToolTip(), -1000
}