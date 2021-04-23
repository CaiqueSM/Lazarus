@echo off
c:\lazarus\fpc\2.2.4\bin\i386-win32\windres.exe --include c:/lazarus/fpc/22D83D~1.4/bin/I386-W~1/ -O res -o "C:\Users\caique\Desktop\Programação 1\Material Auxiliar\strMatching\project_str_matching.res" C:/Users/caique/Desktop/PROGRA~1/MATERI~1/STRMAT~1/PROJEC~1.RC --preprocessor=c:\lazarus\fpc\2.2.4\bin\i386-win32\cpp.exe
if errorlevel 1 goto linkend
SET THEFILE=C:\Users\caique\Desktop\Programação 1\Material Auxiliar\strMatching\project_str_matching.exe
echo Linking %THEFILE%
c:\lazarus\fpc\2.2.4\bin\i386-win32\ld.exe -b pe-i386 -m i386pe  --gc-sections   --subsystem windows --entry=_WinMainCRTStartup    -o "C:\Users\caique\Desktop\Programação 1\Material Auxiliar\strMatching\project_str_matching.exe" "C:\Users\caique\Desktop\Programação 1\Material Auxiliar\strMatching\link.res"
if errorlevel 1 goto linkend
c:\lazarus\fpc\2.2.4\bin\i386-win32\postw32.exe --subsystem gui --input "C:\Users\caique\Desktop\Programação 1\Material Auxiliar\strMatching\project_str_matching.exe" --stack 16777216
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occured while assembling %THEFILE%
goto end
:linkend
echo An error occured while linking %THEFILE%
:end
