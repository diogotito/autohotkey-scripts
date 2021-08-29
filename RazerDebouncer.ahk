; This script was taken from
; https://www.autohotkey.com/boards/viewtopic.php?f=76&t=61469&p=260444&hilit=debounce#p260483

#SingleInstance, Force
db := new Debouncer(50)	; Set Debounce Time here
db.AddKey("t")
db.AddKey("j")
db.AddKey("r")
return

class Debouncer {
	KeyFns := {}

	__New(debounceTime := 20) {
		this.DebounceTime := debounceTime
	}
	
	AddKey(key, pfx := "$*") {
		fn := this.KeyEvent.Bind(this, key, 1)
		hotkey, % pfx key, % fn
		fn := this.KeyEvent.Bind(this, key, 0)
		hotkey, % pfx key " up", % fn
	}
	
	KeyEvent(key, state) {
		if (state) {
			fn := this.KeyFns[key]
			if (fn != "") {
				; Down event while release timer running - bounce!
				SetTimer, % fn, Off
				;~ OutputDebug % "AHK| Bounce!"
			} else {
				; Down event while release timer not running - normal press
				this.SendKey(key, state)
				;~ OutputDebug % "AHK| Normal press of " key
			}
		} else {
			; Release key - block and set timer running instead
			;~ OutputDebug % "AHK| Release of " key "... Starting timer"
			fn := this.ReleaseKey.Bind(this, key)
			SetTimer, % fn, % - this.DebounceTime
			this.KeyFns[key] := fn
		}
	}
	
	SendKey(key, state) {
		Send % "{Blind}{" key (state ? " down" : " up") "}"
	}
	
	; Timer expired before key went back down again - normal release
	ReleaseKey(key) {
		this.KeyFns[key] := ""
		this.SendKey(key, 0)
		;~ OutputDebug % "AHK| Timer finished.. " key " released"
	}
}

; https://www.autohotkey.com/boards/viewtopic.php?f=76&t=59484&p=250654&hilit=debounce#p250667

; #UseHook On
; 
; for each, key in StrSplit("qwerty")
;     new DebounceHotkey(key)
; 
; class DebounceHotkey
; {
;     upTick := 0
; 
;     __New(key) {
;         this.key := key
; 
;         fnPress := ObjBindMethod(this, "press")
;         Hotkey % this.key, % fnPress
;         
;         fnRelease := ObjBindMethod(this, "release")
;         Hotkey % this.key " Up", % fnRelease
;     }
; 
;     press() {
;         elapsedTime := A_TickCount - this.upTick
; 
;         if (elapsedTime > 50)
;             SendInput % "{" this.key " Down}"
;     }
; 
;     release() {
;         this.upTick := A_TickCount
; 
;         SendInput % "{" this.key " Up}"
;     }
; }
