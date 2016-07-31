SET ftpURL=ftp://pi:%1@192.168.1.25/
SET ftpFolder=/d/crumps/ff2
SET uploadFolder=/media/flashka/store/u/crumps/2

SET tempFolder=%cd%
SET sourcePath=%ftpURL%/%ftpFolder%
for %%a in ("Final Fantasy Month Day 2 - FF2 (PSP) part 5-a594865691_5.flv" "Final Fantasy Month Day 2 - FF2 (PSP) part 6-a594865691_6.flv" "Final Fantasy Month Day 2 - FF2 (PSP) part 7-a594865691_7.flv" "Final Fantasy Month Day 2 - FF2 (PSP) part 8-a594865691_8.flv" "Final Fantasy Month Day 2 - FF2 (PSP) part 9-a594865691_9.flv" "Final Fantasy Month Day 2 - FF2 (PSP) part 10-a594865691_10.flv" ) do c:\p\ffmpeg\bin\ffmpeg -threads 1 -i "%sourcePath%/%%~a" -codec:v libx264 -crf 23 -preset ultrafast -codec:a copy -vbr 4 -movflags faststart -vf scale=-1:540,format=yuv420p "%tempFolder%\%%~na.mp4" && "C:\Program Files\WinSCP\winscp.com" /script=upload.txt /parameter "%tempFolder%\%%~na.mp4" /%uploadFolder%/ && echo. && echo. && echo ---DONE CONVERTING %%a to %%~na.mp4 ---
pause
