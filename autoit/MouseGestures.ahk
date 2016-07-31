
LButtonHotkeyBlock := "false"
RButtonHotkeyBlock := "false"


#IfWinActive ahk_class MozillaWindowClass
LButton::
if LButtonHotkeyBlock = false 
{
MouseClick, left,,, 1, 0, D  ; Hold down the left mouse button.
RButtonHotkeyBlock := "true"
blockRButton := "false"
LButtonUpOnce := "false"
Loop
{
    Sleep, 5
    GetKeyState, LButtonState, LButton, P
    if LButtonState = U  ; The key has been released, so break out of the loop.
	break
    GetKeyState, RButtonState, RButton, P    
    if blockRButton = false
	if RButtonState = D
	{
		Send {Alt down}{Right}{Alt up}
                if LButtonUpOnce = false
			MouseClick, left,,, 1, 0, U  ; Release the mouse button.
                LButtonUpOnce := "true"
	        blockRButton := "true"
        }
    if RButtonState = U
    {
        blockRButton := "false"
    }        
}
if LButtonUpOnce = false
	MouseClick, left,,, 1, 0, U  ; Release the mouse button.
RButtonHotkeyBlock := "false"
}
return


#IfWinActive ahk_class MozillaWindowClass
RButton::
if RButtonHotkeyBlock = false 
{
LButtonHotkeyBlock := "true"
blockLButton := "false"
RButtonUpOnce := "false"
Loop
{
    Sleep, 10
    GetKeyState, RButtonState, RButton, P
    if RButtonState = U  ; The key has been released, so break out of the loop.
	break
    GetKeyState, LButtonState, LButton, P    
    if blockLButton = false
	if LButtonState = D
	{
		Send {Alt down}{Left}{Alt up}
                RButtonUpOnce := "true"
	        blockLButton := "true"
        }
    if LButtonState = U
    {
        blockLButton := "false"
    }        
}
if RButtonUpOnce = false
{
	MouseClick, right,,, 1, 0, D  ; Hold down the left mouse button.
	MouseClick, right,,, 1, 0, U  ; Release the mouse button.
}
LButtonHotkeyBlock := "false"
}
return

#IfWinActive ahk_class Chrome_WidgetWin_1
LButton::
if LButtonHotkeyBlock = false 
{
MouseClick, left,,, 1, 0, D  ; Hold down the left mouse button.
RButtonHotkeyBlock := "true"
blockRButton := "false"
LButtonUpOnce := "false"
Loop
{
    Sleep, 10
    GetKeyState, LButtonState, LButton, P
    if LButtonState = U  ; The key has been released, so break out of the loop.
	break
    GetKeyState, RButtonState, RButton, P    
    if blockRButton = false
	if RButtonState = D
	{
		Send {Alt down}{Right}{Alt up}
                if LButtonUpOnce = false
			MouseClick, left,,, 1, 0, U  ; Release the mouse button.
                LButtonUpOnce := "true"
	        blockRButton := "true"
        }
    if RButtonState = U
    {
        blockRButton := "false"
    }        
}
if LButtonUpOnce = false
	MouseClick, left,,, 1, 0, U  ; Release the mouse button.
RButtonHotkeyBlock := "false"
}
return


#IfWinActive ahk_class Chrome_WidgetWin_1
RButton::
if RButtonHotkeyBlock = false 
{
LButtonHotkeyBlock := "true"
blockLButton := "false"
RButtonUpOnce := "false"
Loop
{
    Sleep, 10
    GetKeyState, RButtonState, RButton, P
    if RButtonState = U  ; The key has been released, so break out of the loop.
	break
    GetKeyState, LButtonState, LButton, P    
    if blockLButton = false
	if LButtonState = D
	{
		Send {Alt down}{Left}{Alt up}
                RButtonUpOnce := "true"
	        blockLButton := "true"
        }
    if LButtonState = U
    {
        blockLButton := "false"
    }        
}
if RButtonUpOnce = false
{
	MouseClick, right,,, 1, 0, D  ; Hold down the left mouse button.
	MouseClick, right,,, 1, 0, U  ; Release the mouse button.
}
LButtonHotkeyBlock := "false"
}
return