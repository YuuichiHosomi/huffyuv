@ECHO OFF
rem ******************************************************************************
rem *
rem * huffyuv
rem *
rem * build_wdk.bat
rem *   Batch file "wrapper" for makefile.mak, used to build with WDK
rem *
rem * Distributed under the terms of the GNU GPL v2 or later.
rem *
rem *                                       (c) XhmikosR 2011
rem *                                       http://code.google.com/p/notepad2-mod/
rem *
rem ******************************************************************************

SETLOCAL ENABLEEXTENSIONS
CD /D %~dp0

SET PROJECT=huffyuv

rem Set the WDK directory
IF NOT DEFINED WDKBASEDIR SET "WDKBASEDIR=C:\WinDDK\7600.16385.1"

rem Check the building environment
IF NOT EXIST "%WDKBASEDIR%" CALL :SUBMSG "ERROR" "Specify your WDK directory!"

rem Check for the help switches
IF /I "%~1"=="help"   GOTO SHOWHELP
IF /I "%~1"=="/help"  GOTO SHOWHELP
IF /I "%~1"=="-help"  GOTO SHOWHELP
IF /I "%~1"=="--help" GOTO SHOWHELP
IF /I "%~1"=="/?"     GOTO SHOWHELP


rem Check for the first switch
IF "%~1" == "" (
  SET "BUILDTYPE=Build"
) ELSE (
  IF /I "%~1" == "Build"     SET "BUILDTYPE=Build"   & GOTO CHECKSECONDARG
  IF /I "%~1" == "/Build"    SET "BUILDTYPE=Build"   & GOTO CHECKSECONDARG
  IF /I "%~1" == "-Build"    SET "BUILDTYPE=Build"   & GOTO CHECKSECONDARG
  IF /I "%~1" == "--Build"   SET "BUILDTYPE=Build"   & GOTO CHECKSECONDARG
  IF /I "%~1" == "Clean"     SET "BUILDTYPE=Clean"   & GOTO CHECKSECONDARG
  IF /I "%~1" == "/Clean"    SET "BUILDTYPE=Clean"   & GOTO CHECKSECONDARG
  IF /I "%~1" == "-Clean"    SET "BUILDTYPE=Clean"   & GOTO CHECKSECONDARG
  IF /I "%~1" == "--Clean"   SET "BUILDTYPE=Clean"   & GOTO CHECKSECONDARG
  IF /I "%~1" == "Rebuild"   SET "BUILDTYPE=Rebuild" & GOTO CHECKSECONDARG
  IF /I "%~1" == "/Rebuild"  SET "BUILDTYPE=Rebuild" & GOTO CHECKSECONDARG
  IF /I "%~1" == "-Rebuild"  SET "BUILDTYPE=Rebuild" & GOTO CHECKSECONDARG
  IF /I "%~1" == "--Rebuild" SET "BUILDTYPE=Rebuild" & GOTO CHECKSECONDARG

  ECHO.
  ECHO Unsupported commandline switch!
  ECHO Run "%~nx0 help" for details about the commandline switches.
  CALL :SUBMSG "ERROR" "Compilation failed!"
)


:CHECKSECONDARG
rem Check for the second switch
IF "%~2" == "" (
  SET "ARCH=x86"
) ELSE (
  IF /I "%~2" == "x86"   SET "ARCH=x86" & GOTO START
  IF /I "%~2" == "/x86"  SET "ARCH=x86" & GOTO START
  IF /I "%~2" == "-x86"  SET "ARCH=x86" & GOTO START
  IF /I "%~2" == "--x86" SET "ARCH=x86" & GOTO START

  ECHO.
  ECHO Unsupported commandline switch!
  ECHO Run "%~nx0 help" for details about the commandline switches.
  CALL :SUBMSG "ERROR" "Compilation failed!"
)


:START
SET "INCLUDE=%WDKBASEDIR%\inc\api;%WDKBASEDIR%\inc\api\crt\stl60;%WDKBASEDIR%\inc\crt;%WDKBASEDIR%\inc\ddk"
SET "LIB=%WDKBASEDIR%\lib\crt\i386;%WDKBASEDIR%\lib\win7\i386"
SET "PATH=%WDKBASEDIR%\bin\x86;%WDKBASEDIR%\bin\x86\x86;%PATH%"

TITLE Building %PROJECT% x86 with WDK...
ECHO. & ECHO.

CALL :SUBNMAKE

CALL "installer\build_installer.bat" WDK_BUILD


:END
TITLE Building %PROJECT% with WDK - Finished!
ENDLOCAL
PAUSE
EXIT /B


:SUBNMAKE
nmake /NOLOGO /f "makefile.mak" %BUILDTYPE% %1
IF %ERRORLEVEL% NEQ 0 CALL :SUBMSG "ERROR" "Compilation failed!"
EXIT /B


:SHOWHELP
TITLE "%~nx0 %1"
ECHO. & ECHO.
ECHO Usage:   %~nx0 [Clean^|Build^|Rebuild] [x86]
ECHO.
ECHO Notes:   You can also prefix the commands with "-", "--" or "/".
ECHO          The arguments are not case sensitive.
ECHO. & ECHO.
ECHO Edit "%~nx0" and set your WDK directory.
ECHO You shouldn't need to make any changes other than that.
ECHO. & ECHO.
ECHO Executing "%~nx0" will use the defaults: "%~nx0 build x86"
ECHO.
ECHO If you skip the second argument the default one will be used. Example:
ECHO "%~nx0 rebuild" is the same as "%~nx0 rebuild x86"
ECHO.
ECHO WARNING: "%~nx0 x86" won't work.
ECHO.
ENDLOCAL
EXIT /B


:SUBMSG
ECHO. & ECHO ______________________________
ECHO [%~1] %~2
ECHO ______________________________ & ECHO.
IF /I "%~1"=="ERROR" (
  PAUSE
  EXIT
) ELSE (
  EXIT /B
)