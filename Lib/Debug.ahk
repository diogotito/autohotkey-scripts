Debug_ShowObject(obj, timeout:=0) {
    message := "--- Debug ---"
    For Key, Value in obj {
        
        message .= "`n" A_Index ") [KEY]=" Key ";`t[VALUE]=" Value
    }
    message .= "`n--------------"
    MsgBox, % 0x1040, Debug_ShowObject(), %message%, %timeout%
}