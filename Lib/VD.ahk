; ------------------------------------------------- ;
; https://github.com/Ciantic/VirtualDesktopAccessor ;
; README.markdown > ## AutoHotkey script as example ;
; ------------------------------------------------- ;

DetectHiddenWindows, On
hwnd:=WinExist("ahk_pid " . DllCall("GetCurrentProcessId","Uint"))
hwnd+=0x1000<<32

_VD_hVirtualDesktopAccessor := DllCall("LoadLibrary", Str, "submodules\VirtualDesktopAccessor\x64\Release\VirtualDesktopAccessor.dll", "Ptr") 
_VD_GoToDesktopNumberProc := DllCall("GetProcAddress", Ptr, _VD_hVirtualDesktopAccessor, AStr, "GoToDesktopNumber", "Ptr")
_VD_GetCurrentDesktopNumberProc := DllCall("GetProcAddress", Ptr, _VD_hVirtualDesktopAccessor, AStr, "GetCurrentDesktopNumber", "Ptr")
_VD_IsWindowOnCurrentVirtualDesktopProc := DllCall("GetProcAddress", Ptr, _VD_hVirtualDesktopAccessor, AStr, "IsWindowOnCurrentVirtualDesktop", "Ptr")
_VD_MoveWindowToDesktopNumberProc := DllCall("GetProcAddress", Ptr, _VD_hVirtualDesktopAccessor, AStr, "MoveWindowToDesktopNumber", "Ptr")
_VD_RegisterPostMessageHookProc := DllCall("GetProcAddress", Ptr, _VD_hVirtualDesktopAccessor, AStr, "RegisterPostMessageHook", "Ptr")
_VD_UnregisterPostMessageHookProc := DllCall("GetProcAddress", Ptr, _VD_hVirtualDesktopAccessor, AStr, "UnregisterPostMessageHook", "Ptr")
_VD_IsPinnedWindowProc := DllCall("GetProcAddress", Ptr, _VD_hVirtualDesktopAccessor, AStr, "IsPinnedWindow", "Ptr")
RestartVirtualDesktopAccessorProc := DllCall("GetProcAddress", Ptr, _VD_hVirtualDesktopAccessor, AStr, "RestartVirtualDesktopAccessor", "Ptr")
; GetWindowDesktopNumberProc := DllCall("GetProcAddress", Ptr, _VD_hVirtualDesktopAccessor, AStr, "GetWindowDesktopNumber", "Ptr")
activeWindowByDesktop := {}

; Restart the virtual desktop accessor when Explorer.exe crashes, or restarts (e.g. when coming from fullscreen game)
explorerRestartMsg := DllCall("user32\RegisterWindowMessage", "Str", "TaskbarCreated")
OnMessage(explorerRestartMsg, "OnExplorerRestart")
OnExplorerRestart(wParam, lParam, msg, hwnd) {
    global RestartVirtualDesktopAccessorProc
    DllCall(RestartVirtualDesktopAccessorProc, UInt, result)
}

VD_MoveCurrentWindowToDesktop(number) {
	global _VD_MoveWindowToDesktopNumberProc, _VD_GoToDesktopNumberProc, activeWindowByDesktop
	WinGet, activeHwnd, ID, A
	activeWindowByDesktop[number] := 0 ; Do not activate
	DllCall(_VD_MoveWindowToDesktopNumberProc, UInt, activeHwnd, UInt, number)
	DllCall(_VD_GoToDesktopNumberProc, UInt, number)
}

VD_GoToPrevDesktop() {
	global _VD_GetCurrentDesktopNumberProc, _VD_GoToDesktopNumberProc
	current := DllCall(_VD_GetCurrentDesktopNumberProc, UInt)
	if (current = 0) {
		VD_GoToDesktopNumber(7)
	} else {
		VD_GoToDesktopNumber(current - 1)      
	}
	return
}

VD_GoToNextDesktop() {
	global _VD_GetCurrentDesktopNumberProc, _VD_GoToDesktopNumberProc
	current := DllCall(_VD_GetCurrentDesktopNumberProc, UInt)
	if (current = 7) {
		VD_GoToDesktopNumber(0)
	} else {
		VD_GoToDesktopNumber(current + 1)    
	}
	return
}

VD_GoToDesktopNumber(num) {
	global _VD_GetCurrentDesktopNumberProc, _VD_GoToDesktopNumberProc, _VD_IsPinnedWindowProc, activeWindowByDesktop

	; Store the active window of old desktop, if it is not pinned
	WinGet, activeHwnd, ID, A
	current := DllCall(_VD_GetCurrentDesktopNumberProc, UInt) 
	isPinned := DllCall(_VD_IsPinnedWindowProc, UInt, activeHwnd)
	if (isPinned == 0) {
		activeWindowByDesktop[current] := activeHwnd
	}

	; Try to avoid flashing task bar buttons, deactivate the current window if it is not pinned
	if (isPinned != 1) {
		WinActivate, ahk_class Shell_TrayWnd
	}

	; Change desktop
	DllCall(_VD_GoToDesktopNumberProc, Int, num)
	return
}

; Windows 10 desktop changes listener
DllCall(_VD_RegisterPostMessageHookProc, Int, hwnd, Int, 0x1400 + 30)
OnMessage(0x1400 + 30, "VWMess")
VWMess(wParam, lParam, msg, hwnd) {
	global _VD_IsWindowOnCurrentVirtualDesktopProc, _VD_IsPinnedWindowProc, activeWindowByDesktop

	desktopNumber := lParam + 1
	
	; Try to restore active window from memory (if it's still on the desktop and is not pinned)
	WinGet, activeHwnd, ID, A 
	isPinned := DllCall(_VD_IsPinnedWindowProc, UInt, activeHwnd)
	oldHwnd := activeWindowByDesktop[lParam]
	isOnDesktop := DllCall(_VD_IsWindowOnCurrentVirtualDesktopProc, UInt, oldHwnd, Int)
	if (isOnDesktop == 1 && isPinned != 1) {
		WinActivate, ahk_id %oldHwnd%
	}

	; Menu, Tray, Icon, Icons/icon%desktopNumber%.ico
}
