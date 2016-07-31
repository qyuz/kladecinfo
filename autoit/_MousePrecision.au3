Local $bool 
if $CmdLine[1] = "true" Then 
   $bool = True 
   Else 
	  $bool = False 
EndIf
ConsoleWrite($bool)
_EnableMouseAccel($bool)
If @error Then MsgBox(0, "Error", "An error occured: " & @error)

Func _EnableMouseAccel($ivState)
    
    Local Const $SPI_SETMOUSE = 4
    Local Const $SPIF_UPDATEINIFILE = 1
    Local Const $SPIF_SENDWININICHANGE = 2

    Local $mouseStruct = DllStructCreate("int[3]")
    
    DllStructSetData($mouseStruct, 1, 6*$ivState, 1)
    DllStructSetData($mouseStruct, 1, 10*$ivState, 2)
    DllStructSetData($mouseStruct, 1, $ivState, 3)
    
    Local $avResult = DllCall("user32.dll", "int", "SystemParametersInfo", "uint", $SPI_SETMOUSE, "uint", 0, "ptr", DllStructGetPtr($mouseStruct), "uint",  BitOR($SPIF_UPDATEINIFILE, $SPIF_SENDWININICHANGE))
    If @error Or Not $avResult[0] Then Return(SetError(1, 0, 0)) ; Failed to update settings
    
EndFunc