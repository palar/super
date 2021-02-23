@echo off

set cmd_color=f0
set dependencies_dir=%~dp0
if [%dependencies_dir:~-1%] == [\] set dependencies_dir=%dependencies_dir:~0,-1%
pushd "%dependencies_dir%\.."
set apps_dir=%CD%
if "%PATH:~-1%" == ";" set PATH=%PATH:~0,-1%
if not defined NEW_PATH set NEW_PATH=%PATH%;%apps_dir%\7-Zip\App;%apps_dir%\NirCmd\App
set PATH=%NEW_PATH%
set setup_title=%~n0
if not "%setup_title:_= %" == "%setup_title%" set setup_title=%setup_title:_= %
for /f "tokens=1" %%i in ("%setup_title%") do set app_name=%%i
if not "%setup_title: =%" == "%setup_title%" set setup_title="%setup_title%"
set app_folder=%app_name%
set version=*
set bit=64
if not defined ProgramFiles(x86) set bit=32
set temporary=FileZilla-%version%
for %%a in (Dependencies\Downloads\FileZilla_%version%_win%bit%*) do set setup_file=%%a
set a=%0
set b=%1
set c=%2
set d=%3
if defined c set c= %c%
if defined d set d= %d%
:: if [%b%] == [] start /max cmd /c "color %cmd_color% & %a% --wrapper %setup_title% --install"
if [%b%] == [] start %setup_title% cmd /c "color %cmd_color% & nircmd win center title %setup_title%>nul 2>&1 & %a% --wrapper %setup_title% --install"
call :start %b%%c%%d%
popd
goto end

:defaults
set file=%1
if not defined file set file=fzdefaults.xml
echo ^<?xml version="1.0" encoding="UTF-8" standalone="yes"?^>>%file%
echo ^<FileZilla3^>>>%file%
echo 	^<Settings^>>>%file%
:: echo 		^<Setting name="Proxy type"^>1^</Setting^>>>%file%
:: echo 		^<Setting name="Proxy host"^>127.0.0.1^</Setting^>>>%file%
:: echo 		^<Setting name="Proxy port"^>8118^</Setting^>>>%file%
echo 		^<Setting name="Language Code"^>en_US^</Setting^>>>%file%
echo 		^<Setting name="Last local directory"^>%~d0\^</Setting^>>>%file%
echo 		^<Setting name="Window position and size"^>1 83 5 1184 609 ^</Setting^>>>%file%
echo 		^<Setting name="Default editor"^>2%apps_dir%\Notepad++\App\notepad++.exe^</Setting^>>>%file%
echo 		^<Setting name="Always use default editor"^>1^</Setting^>>>%file%
echo 		^<Setting name="Config Location"^>%apps_dir%\%app_folder%\Data\settings\^</Setting^>>>%file%
echo 		^<Setting name="Kiosk mode"^>1^</Setting^>>>%file%
echo 		^<Setting name="Disable update check"^>1^</Setting^>>>%file%
echo 		^<Setting name="Cache directory"^>%apps_dir%\%app_folder%\Data\cache\^</Setting^>>>%file%
echo 	^</Settings^>>>%file%
echo ^</FileZilla3^>>>%file%
goto end

:error
echo Sorry, something went wrong.
goto end

:install
if not defined setup_file goto error
if not "%setup_file:.zip=%" == "%setup_file%" goto install-zip
call :uninstall
echo Installing %app_name%...
echo.
7z x %setup_file% -o%app_folder%\App -y>nul 2>&1
rd %app_folder%>nul 2>&1
if not exist %app_folder% goto error
cd %app_folder%
cd App
call :defaults
rd $PLUGINSDIR $R2 /q /s>nul 2>&1
del $R0 uninstall.exe.nsis>nul 2>&1
cd..
cd..
echo %app_folder% has been successfully installed.
goto end

:install-zip
call :uninstall
echo Installing %app_name%...
echo.
7z x %setup_file% -o%app_folder%>nul 2>&1
rd %app_folder%>nul 2>&1
if not exist %app_folder% goto error
cd %app_folder%
forfiles /m %temporary% /c "cmd /c ren @file App">nul 2>&1
call :defaults App\fzdefaults.xml
cd..
echo %app_folder% has been successfully installed.
goto end

:rd
if exist %1 rd %1 /q /s>nul 2>&1
if exist %1 goto error
goto end

:start
set first=%1
set second=%2
set third=%3
if defined first set first=%first:--=:%
if defined second set second= %second%
if defined third set third= %third%
call %first%%second%%third%
goto end

:uninstall
forfiles /p %app_folder% /m %temporary% /c "cmd /c rd @file /q /s">nul 2>&1
call :rd %app_folder%\App
rd %app_folder%>nul 2>&1
goto end

:wrapper
set first=%1
set second=%2
if defined first set first=%first:"=%
if defined second set second=%second:--=:%
title %first%
echo.
echo %first%
echo.
call %second%
echo.
set /p pause=Press Enter to continue... 
goto end

:end
