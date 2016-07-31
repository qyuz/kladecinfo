SET sourceFolder=cereth/dec3

SET ftpFolder=/d/%sourceFolder%
SET uploadFolder=/media/flashka/store/u/%sourceFolder%

SET ftpURL=ftp://pi:%1@192.168.1.25/

SET tempFolder=d:\temp
SET sourcePath=%ftpURL%/%ftpFolder%

for %%a in (dec3-a595226972_31.flv dec3-a595226972_32.flv ) do c:\p\ffmpeg\bin\ffmpeg -i "%sourcePath%/%%~a" -codec:v libx264 -profile:v high -crf 23 -bufsize 2400k -maxrate 2400k -preset ultrafast -codec:a copy -vbr 4 -movflags faststart -vf scale=-1:720,format=yuv420p "%tempFolder%\%%~na.mp4" && start /b upload.bat "%tempFolder%\%%~na.mp4" /%uploadFolder%/ && echo. && echo. && echo ---DONE CONVERTING %%a to %%~na.mp4 ---
pause
