#include <Misc.au3>

Local $hDLL = DllOpen("user32.dll")

dim $hexes [300]
$i = 0
While($i < 300) 
   $hexes[$i] = Hex($i)
   $i = $i + 1
WEnd

While 1
   $c = 0
   while($c < 300) 
	  if(_IsPressed($hexes[$c], $hDLL)) Then
		 ConsoleWrite($hexes[$c] & @CRLF)
	  endif
	  $c = $c + 1
   WEnd
   Sleep(500)
WEnd

DllClose($hDLL)
