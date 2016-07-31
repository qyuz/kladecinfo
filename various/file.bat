SET sourceFolder=cereth/dec12

SET ftpFolder=/d/%sourceFolder%
SET uploadFolder=/media/flashka/store/u/%sourceFolder%
SET ftpURL=ftp://pistore:%1@192.168.1.25/
SET tempFolder=d:\temp
SET sourcePath=%ftpURL%/%ftpFolder%

:eternity 

::rewrite last value
SET file=""
::get first line
SET /p file=<todo.txt
::iterate over elements in first line
for %%a in (%file%) do (
	if %%a=="" goto end

	c:\p\ffmpeg\bin\ffmpeg -y -i "%sourcePath%/%%~a" -codec:v libx264 -profile:v high -crf 23 -preset ultrafast -codec:a copy -vbr 4 -movflags faststart -vf scale=-1:540,format=yuv420p -f segment -segment_time 1711.65 -reset_timestamps 1 "%tempFolder%\%%~na_%%01d.mp4" 

	start /b upload.bat "%tempFolder%\%%~na.mp4" /%uploadFolder%/

	echo.
	echo.
	echo ---DONE CONVERTING %%a to %%~na.mp4 ---
)

more +1 todo.txt>ztemp.txt
more ztemp.txt>todo.txt
echo %file%>>done.txt
echo ---DONE WITH %file% LINE ---

goto eternity

:end
del ztemp.txt
echo "Finished"
pause
exit