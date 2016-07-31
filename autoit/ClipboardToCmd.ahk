#IfWinActive ahk_class ConsoleWindowClass
^V::
SendInput {Raw}%clipboard%
return
#IfWinActive