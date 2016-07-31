#include <Date.au3>

Global $paused
Global $showToolTip = False
Global $count = 0
Global $changeStatus = "Active"
Global $popupStatus = "Active (popup will disappear)"
Global $popupVanishInterval = 2000
Global $popupTimerInit = 0
Global $mainTimerInit = TimerInit()
Global $mainInterval = 1000
Global $conf = conf()
ConsoleWrite($conf[3])
Global $actionIntervalCount = $conf[0] * 60 ;60 minutes
Global $msgBoxIntervalCount = $conf[1] * 60 ;3 minutes
Global $msgBoxTill = ''

HotKeySet("![", "TogglePause")
;HotKeySet("{ESC}", "Terminate")
HotKeySet("!]", "ToggleToolTip") ;Shift-Alt-d
HotKeySet("!=", "IncMinute") ;Shift-Alt-d
HotKeySet("!-", "DecMinute") ;Shift-Alt-d
HotKeySet("^+!{Delete}", "RestartTimer")


;;;; Body of program would go here ;;;;
While True
   Sleep(100)
   If ( TimerDiff($mainTimerInit) > $mainInterval) Then
	  $mainTimerInit = TimerInit()
	  $count = $count + 1
   EndIf
   If ($count >= $actionIntervalCount) Then
	  If ( $count - $actionIntervalCount > $msgBoxIntervalCount ) Then
		 $count = 0
		 till('reset')
	  Elseif (@HOUR >= Int($conf[2]) And @HOUR <= Int($conf[3])) Then
		 MsgBox(4096, "You have stuff to do", $conf[4] & ' DO ' & till(''), 1)
	  EndIf
   EndIf
   ShowToolTip()
WEnd
;;;;;;;;

Func conf() 
   Local $confToFormat = 'Show me a popup every %s minutes for %s minutes starting from %s to %s hours inclusive with text %s'
   Local $confDefault = StringFormat($confToFormat, 43, 2, 9, 18, "YOU HAVE STUFF TO DO")
   Local $confPattern = StringFormat($confToFormat, "(.*)", "(.*)", "(.*)", "(.*)", "(.*)")
   Local $file = FileOpen("reminder.txt", 0)
   Local $fileText = FileReadLine($file)
   Local $conf = StringRegExp($fileText, $confPattern, 1)
   FileClose($file)
   If (UBound($conf) < 3) Then
	  $file = FileOpen("reminder.txt", 2)
	  FileWriteLine($file, $confDefault)
	  FileClose($file)
	  $conf = StringRegExp($confDefault, $confPattern, 1)
   EndIf
   Return $conf
EndFunc

Func till($action) 
   If ($action = 'reset') Then
	  $msgBoxTill = ''
   ElseIf ( $msgBoxTill = '' ) Then
	  $msgBoxTill = _DateAdd('n', $conf[1], _NowCalc())
   EndIf
   return $msgBoxTill
EndFunc

Func RestartTimer()
   $popupTimerInit = TimerInit()
   $count = 0
   ShowToolTip()
EndFunc

Func IncMinute()
   $count = $count + 60
   ShowToolTip()
EndFunc

Func DecMinute()
   $count = $count - 60
   ShowToolTip()
EndFunc

Func TogglePause()
   $popupTimerInit = TimerInit()
   $paused = Not $paused
   $showToolTip = $paused
   While $paused
	  $changeStatus = 'Paused'
	  $popupStatus = 'Paused (popup will disappear)'
	  ShowToolTip()
	  Sleep(100)
   WEnd
   $changeStatus = 'Active'
   $popupStatus = 'Active (popup will disappear)'
   ShowToolTip()
EndFunc 

Func Terminate()
    Exit 0
EndFunc 

Func ToggleToolTip()
   $showToolTip = Not $showToolTip
   ShowToolTip()
EndFunc 

Func ShowToolTip()
   Local $formattedTime = Sec2Time($count)
   If( $showToolTip = True) Then
	  ToolTip($formattedTime & ' ' & $changeStatus)
   ElseIf ( TimerDiff($popupTimerInit) < $popupVanishInterval) Then
	  ToolTip($formattedTime & ' ' & $popupStatus)
   Else
	  ToolTip('')
   EndIf
EndFunc 

Func Sec2Time($nr_sec)
   $sec2time_hour = Int($nr_sec / 3600)
   $sec2time_min = Int(($nr_sec - $sec2time_hour * 3600) / 60)
   $sec2time_sec = $nr_sec - $sec2time_hour * 3600 - $sec2time_min * 60
   Return StringFormat('%02d:%02d:%02d', $sec2time_hour, $sec2time_min, $sec2time_sec)
EndFunc 


   
