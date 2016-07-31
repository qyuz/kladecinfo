@ECHO off
SET JAVA_HOME=C:\java\jdks\jdk1.7_45x64\jre
SET WDIR=C:\java\svn\kladecytI\web\js

groovy watchpti.groovy %WDIR%

pause
