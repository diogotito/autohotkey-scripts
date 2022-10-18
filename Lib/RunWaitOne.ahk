; -----------------------------------------------------------------------------
; Sets up the hidden window
; -----------------------------------------------------------------------------
RunWaitOne_PrepareHiddenWindow() {
    DllCall("AllocConsole")
    WinHide % "ahk_id " DllCall("GetConsoleWindow", "ptr")
}

; -----------------------------------------------------------------------------
; Run commands and capture their output without an annoying window showing up
; -----------------------------------------------------------------------------
RunWaitOne(command) {
    ; WshShell object: http://msdn.microsoft.com/en-us/library/aew9yb99 ¬
    shell := ComObjCreate("WScript.Shell")
    ; Execute a single command via cmd.exe
    exec := shell.Exec(ComSpec " /C " command)
    ; Read and return the command's output
    return exec.StdOut.ReadAll()
}