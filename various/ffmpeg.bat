for %%a in ("Final Fantasy Month BEGINS! (FF 1 now!) part 25-a594563967_25.flv") do c:\p\ffmpeg\bin\ffmpeg -i %%a -codec:v libx264 -crf 23 -preset ultrafast -codec:a copy -vbr 4 -movflags faststart -vf scale=-1:540,format=yuv420p "u:\crumps\1\%%~na.mp4"