HotKeySet('{MEDIA_PLAY_PAUSE}', 'RefreshChrome')
Func RefreshChrome()
   $handle = WinGetHandle("")
   WinActivate("[REGEXPTITLE:.* - Google Chrome]")
   WinActivate($handle)
   Sleep(500)
   ControlSend("[REGEXPTITLE:.* - Google Chrome]", "", "", "{F5}")
   WinActivate($handle)
EndFunc



while(true)
Sleep(1000)   
WEnd