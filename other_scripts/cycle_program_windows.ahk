; https://stackoverflow.com/questions/46577418/autohotkey-move-to-next-program-when-press-a-key/47066800#47066800

AltTab_ID_List_ := []

setTimer, updateList, 100

+f9::WinActivate, % "AHK_ID" AltTab_ID_List_[(pointer == 1 or pointer == 0 
                                   ? AltTab_ID_List_.Count()-1 : --pointer)]

f9::WinActivate, % "AHK_ID" AltTab_ID_List_[++pointer]

updateList:
list := AltTab_window_list()
if (AltTab_ID_List_.MaxIndex() != list.MaxIndex()) 
    AltTab_ID_List_ := list


cur:=WinExist("A")
for e, v in AltTab_ID_List_
    if (cur == v)
        pointer := AltTab_ID_List_.MaxIndex() == e ? 0 : e, break

return


AltTab_window_list()
{

  WS_EX_CONTROLPARENT =0x10000
  WS_EX_APPWINDOW =0x40000
  WS_EX_TOOLWINDOW =0x80
  WS_DISABLED =0x8000000
  WS_POPUP =0x80000000
  AltTab_ID_List_ := [] ;AltTab_ID_List_ =0

  WinGet, Window_List, List ; Gather a list of running programs
  id_list =
  Loop, %Window_List%
    {
    wid := Window_List%A_Index%
    WinGetTitle, wid_Title, ahk_id %wid%
    WinGet, Style, Style, ahk_id %wid%

    If ((Style & WS_DISABLED) or ! (wid_Title)) ; skip unimportant windows ; ! wid_Title or 
        Continue

    WinGet, es, ExStyle, ahk_id %wid%
    Parent := Decimal_to_Hex( DllCall( "GetParent", "uint", wid ) )
    WinGetClass, Win_Class, ahk_id %wid%
    WinGet, Style_parent, Style, ahk_id %Parent%

    If ((es & WS_EX_TOOLWINDOW)
        or ((es & ws_ex_controlparent) and ! (Style & WS_POPUP) and !(Win_Class ="#32770") and ! (es & WS_EX_APPWINDOW)) ; pspad child window excluded
        or ((Style & WS_POPUP) and (Parent) and ((Style_parent & WS_DISABLED) =0))) ; notepad find window excluded ; note - some windows result in blank value so must test for zero instead of using NOT operator!
      continue

     AltTab_ID_List_.push(wid)

    }
    return AltTab_ID_List_
}

Decimal_to_Hex(var)
{
  SetFormat, integer, hex
  var += 0
  SetFormat, integer, d
  return var
}