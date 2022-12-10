;==============================================================================
; Readline-inspired hotkeys:
; Hotkeys to make text manipulation more ergonomic in chosen input fields
;------------------------------------------------------------------------------
; How to use:
;   - #If...
;   - #IncludeAgain <ReadlineStyleHotkeys>
;==============================================================================

; Emacs-style keybindings
^b::SendInput {Left}
^f::SendInput {Right}
^+b::SendInput +{Left}
^+f::SendInput +{Right}
!b::SendInput ^{Left}
!f::SendInput ^{Right}
!a::SendInput {Home}
!e::SendInput {End}
^e::SendInput {End}
^w::SendInput ^+{Left}^x
!BackSpace::SendInput ^+{Left}^x
!d::SendInput ^+{Right}^x
^u::SendInput +{Home}^x
^k::SendInput +{End}^x
^y::^v
!r::SendInput ^a{BackSpace}
^/::^z
^-::^z
^j::SendInput {Enter}
^m::SendInput {Enter}

+!h::SendInput ^a

; Vim-style motions
!h::SendInput {Left}
!j::SendInput {Down}
!k::SendInput {Up}
!l::SendInput {Right}

; Incomplete hotkeys
!c::SendInput ^{Right} ; TODO Capitalize
!u::SendInput ^{Right} ; TODO UPPERCASE
!+l::SendInput ^{Right} ; TODO lowercase