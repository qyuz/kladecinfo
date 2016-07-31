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
Global $actionIntervalCount = 57 * 60 ;60 minutes
Global $msgBoxIntervalCount = 3 * 60 ;3 minutes
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
	  Elseif (@HOUR >= 9 And @HOUR <= 18) Then
		 MsgBox(0, "ÊÀ×ÀÒ", "ÏÅÐÑ 3 ÌÈÍÓÒÛ ÄÎ: " & till(''), 1)
	  EndIf
   EndIf
   ShowToolTip()
WEnd
;;;;;;;;

Func till($action) 
   If ($action = 'reset') Then
	  $msgBoxTill = ''
   ElseIf ( $msgBoxTill = '' ) Then
	  $msgBoxTill = _DateAdd('n', 3, _NowCalc())
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


   
