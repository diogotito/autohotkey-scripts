^!Left::
#PgUp::
#+N::
LWin & Ctrl::
	SendInput #^{Left}
		Run, Monitorian.exe, 
	return

^!Right::
#PgDn::
#N::
LWin & Alt::
	SendInput #^{Right}
	return


#+Q::
	SendInput !{F4}
	return


; Laptop monitor

#^NumpadAdd:
	Run, Monitorian.exe /set "DISPLAY\AUO21EC\4&278bc23d&0&UID67568640" +20
	return
	
#^NumpadSub:
	Run, Monitorian.exe /set "DISPLAY\AUO21EC\4&278bc23d&0&UID67568640" -20
	return


; External LG monitor

#+NumpadAdd:
	Run, Monitorian.exe /set "DISPLAY\GSM5AB8\4&278bc23d&0&UID50725632" +20
	return

#+NumpadSub:
	Run, Monitorian.exe /set "DISPLAY\GSM5AB8\4&278bc23d&0&UID50725632" -20
	return
