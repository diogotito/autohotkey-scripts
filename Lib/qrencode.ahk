qrencode() {
    qrencode = C:\tools\msys64\mingw64\bin\qrencode.exe
    image = %A_Temp%\qrencode.png

    if not Clipboard {
        ToolTip Não há texto no Clipboard
        Sleep 1000
        ToolTip,,
        Return
    }

    try {
        Util_LogToolTip("> a correr qrencode:`n" qrencode "`nClipboard = " Clipboard)
        RunWait %qrencode% "%Clipboard%" -s 20 -o %image%,, UseErrorLevel
        Util_LogToolTip("`n-----`n")
        Sleep 200
        Util_LogToolTip("> a lancar o visualizador de imagens:`n" image)
        Run %image%,, UseErrorLevel
        Util_LogToolTip("`n-----`n")
        Sleep 2000
        Util_LogToolTip("> a apagar a imagem")
        FileDelete %image%
        Util_LogToolTip()
    } catch e {
        MsgBox Houve um erro!`nSpecifically: %e%`nA_LastError = %A_LastError%
    } finally {
        Util_LogToolTip()
    }
}