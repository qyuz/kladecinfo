#cs
	Name: Colemak to QWERTY
	Author: Crend King
	Description: Based on JBr00ks's Original Keyboard Layout
	Thanks to: JBr00ks, Toady and RazerM!
#ce

#include <Misc.au3>
#include <vkConstants.au3>
#include <MouseOnEvent.au3>
If _Singleton("C2Q", 1) = 0 Then
	MsgBox(262144, "Error", "Colemak to QWERTY is already running!")
	Exit
EndIf

$DLL = DllOpen("user32.dll")
$key_count = 16; number of key to remap
$xDown = False
_MouseSetOnEvent($MOUSE_XBUTTONDOWN_EVENT, "xDown", 0, 1)
_MouseSetOnEvent($MOUSE_XBUTTONUP_EVENT, "xUp", 0, 1)
Dim $lower_src_keys[$key_count] = ["a", "s", "d", "f", "g", "q", "w", "e", "r", "t", "z", "x", "c", "v", "b"]
Dim $upper_src_keys[$key_count] = ["A", "S", "D", "F", "G", "Q", "W", "E", "R", "T", "Z", "X", "C", "V", "B"]
Dim $lower_dest_keys[$key_count] = ["h", "j", "k", "l", ";", "y", "u", "i", "o", "p", "n", "m", ",", ".", "/"]
Dim $upper_dest_keys[$key_count] = ["H", "J", "K", "L", ":", "Y", "U", "I", "O", "P", "N", "M", "<", ">", "?"]
Dim $key_code[$key_count]	; key code for _IsPressed()

; get key codes
For $i = 0 To ($key_count - 1 )
	$key_code[$i] = Hex(Execute("$VK_" & $upper_src_keys[$i])) 
	ConsoleWrite($key_code[$i])
Next
 
For $i = 0 To ($key_count - 1)
	HotKeySet($lower_src_keys[$i], "Block")
	HotKeySet($upper_src_keys[$i], "Block") 
 Next
 
 HotKeySet("{CTRL}", "Block")
 
While 1
	Sleep(1)
	CheckKeys()
WEnd

Func xDown() 
   $xDown = True
   ConsoleWrite("down")
EndFunc

Func xUp() 
   $xDown = False
   ConsoleWrite("up")
EndFunc

Func Block()
   ConsoleWrite("Block")
EndFunc   ;==>Block
Func CheckKeys()
	For $i = 0 To ($key_count - 1)
		If _IsPressed($key_code[$i], $DLL) Then
			If _isPressed(06, $DLL) and $xDown Then
			   If _IsPressed(10, $DLL) = _GetCapsState() Then
				   HotKeySet($lower_dest_keys[$i])
				   Send($lower_dest_keys[$i], 1)
				   HotKeySet($lower_dest_keys[$i], "Block")
			   Else
				   HotKeySet($upper_dest_keys[$i])
				   Send($upper_dest_keys[$i], 1)
				   HotKeySet($upper_dest_keys[$i], "Block")
			   EndIf
			   
			   ; interruptable repeat when key is down and not up
			   For $j = 0 To 24
				   If _IsPressed($key_code[$i], $DLL) Then
					   Sleep(1)
				   Else
					   ExitLoop
				   EndIf
				Next
			Else 
			   HotKeySet($lower_src_keys[$i])
			   Send($lower_src_keys[$i], 1)
			   HotKeySet($lower_src_keys[$i], "Block")
			EndIf
		 EndIf
	Next
EndFunc   ;==>CheckKeys

Func _GetCapsState()
	$av_ret = DllCall($DLL, "int", "GetKeyState", "int", $VK_CAPITAL)
	Return $av_ret[0]
EndFunc   ;==>_GetCapsState
