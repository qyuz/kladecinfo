#include <MsgBoxConstants.au3>

Opt("WinTitleMatchMode", 2) ;SUBSTR
Example()

Func Example()
   Local $windowTitleSubstring = InputBox("Window title", "Window title substring is expected")
   If (@error) Then
	  Exit
   EndIf
   Local $wnds = WinList($windowTitleSubstring)
   Local $wndsCount = $wnds[0][0]
   
   If ($wndsCount = 0) Then
	  MsgBox($MB_OK, "Exiting", "Couldn't find windows with title substring """ & $windowTitleSubstring & """")
	  Exit
   EndIf
   
   Local $wndNames = ""
   For $i = 1 to $wndsCount
	  $wndNames = $wndNames & " " & $wnds[$i][0] & @CR&@LF
   Next
   Local $msgBoxText = ""
   $msgBoxText = "Windows found:"& @CR&@LF 
   $msgBoxText = $msgBoxText & $wndNames
   $msgBoxText = $msgBoxText & "Actions:" & @CR&@LF
   $msgBoxText = $msgBoxText & "  Yes - set them on top" & @CR&@LF 
   $msgBoxText = $msgBoxText & "  No - remove on stop state" & @CR&@LF 
   $msgBoxText = $msgBoxText & "  Cancel - cancel operation"
   
   Local $yesNoCancel = MsgBox($MB_YESNOCANCEL, "Found " & $wndsCount & " windows", $msgBoxText)
   
   If ($yesNoCancel = $IDYES Or $yesNoCancel = $IDNO) Then
	  For $i = 1 To $wndsCount
		 Local $hWnd = $wnds[$i][1]
		 If ($yesNoCancel = $IDYES) Then
			WinSetOnTop($hWnd, "", 1)
			WinSetOnTop($hWnd, "", 1)			
		 ElseIf ($yesNoCancel = $IDNO) Then
			WinSetOnTop($hWnd, "", 0)			
		 EndIf
	  Next
	  If ($yesNoCancel = $IDYES) Then
		 MsgBox($MB_OK, "On top", "On top!")
	  ElseIf ($yesNoCancel = $IDNO) Then
		 MsgBox($MB_OK, "Removed on top",  "Removed on top!")
	  EndIf
   Else 
	  Exit
   EndIf
EndFunc