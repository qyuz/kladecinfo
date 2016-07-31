Opt("WinTitleMatchMode", 2) ;SUBSTR
HotKeySet("^r", "verify")
HotKeySet("^u", "upload")
HotKeySet("^q", "focusCodeBlocks")
$WIN_TITLE = "Arduino 1"

Func verify()
   focusArduinoIDE("^r", "verify")
EndFunc

Func upload()
   focusArduinoIDE("^u", "upload")
EndFunc

Func focusArduinoIDE($hotKey, $funcName)  
   Local $hnd = WinGetHandle($WIN_TITLE)
   WinActivate($hnd)
   WinWait($WIN_TITLE)
   If (WinActive($WIN_TITLE)) Then
	  HotKeySet($hotKey)
	  Send($hotKey)
	  HotKeySet($hotKey, $funcName)
   Else
	  MsgBox(0, "Exiting", "Window couldnt activate")
	  Exit()
   EndIf
EndFunc

Func focusCodeBlocks() 
   WinActivate("Code::Blocks")
EndFunc

While True
WEnd