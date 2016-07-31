; IMPORTANT INFO ABOUT GETTING STARTED: Lines that start with a
; semicolon, such as this one, are comments.  They are not executed.

; This script has a special filename and path because it is automatically
; launched when you run the program directly.  Also, any text file whose
; name ends in .ahk is associated with the program, which means that it
; can be launched simply by double-clicking it.  You can have as many .ahk
; files as you want, located in any folder.  You can also run more than
; one .ahk file simultaneously and each will get its own tray icon.

; SAMPLE HOTKEYS: Below are two sample hotkeys.  The first is Win+Z and it
; launches a web site in the default browser.  The second is Control+Alt+N
; and it launches a new Notepad window (or activates an existing one).  To
; try out these hotkeys, run AutoHotkey again, which will load this file.


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


#z::Run www.autohotkey.com

XButton2:: 
return

XButton2 & w:: Send {LCtrl down}{w}{LCtrl up}
XButton2 & g:: Send {LCtrl down}{LShift down}{t}{LShift up}{LCtrl up}
XButton2 & r:: Send {LCtrl down}{r}{LCtrl up}
XButton2 & t:: Send {LCtrl down}{t}{LCtrl up}
XButton2 & f:: Send {UP}
XButton2 & d:: Send {left}
XButton2 & v:: Send {right}
XButton2 & c:: Send {down}
XButton2 & b:: Send {pgup}
XButton2 & e:: Send {pgdn}
XButton2 & Tab::Send {LCtrl down}{Tab}{LCtrl up}



; Note: From now on whenever you run AutoHotkey directly, this script
; will be loaded.  So feel free to customize it to suit your needs.

; Please read the QUICK-START TUTORIAL near the top of the help file.
; It explains how to perform common automation tasks such as sending
; keystrokes and mouse clicks.  It also explains more about hotkeys.
