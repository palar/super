@echo off

set cmd_color=f0
set dependencies_dir=%~dp0
if [%dependencies_dir:~-1%] == [\] set dependencies_dir=%dependencies_dir:~0,-1%
pushd "%dependencies_dir%\.."
set apps_dir=%CD%
set ORIGINAL_PATH=%PATH%
if "%PATH:~-1%" == ";" set PATH=%PATH:~0,-1%
set SETUP_PATH=%PATH%;%apps_dir%\7-Zip\App;%apps_dir%\NirCmd\App;
set PATH=%SETUP_PATH%
set setup_title=%~n0
if not "%setup_title:_= %" == "%setup_title%" set setup_title=%setup_title:_= %
for /f "tokens=1" %%i in ("%setup_title%") do set app_name=%%i
if not "%setup_title: =%" == "%setup_title%" set setup_title="%setup_title%"
set app_folder=%app_name%
set version=*
set libflac_version=*
set bit=x64
set itunes_bit=64
set libflac_bit=64
if not defined ProgramFiles(x86) (
	set bit=x86
	set itunes_bit=
	set libflac_bit=86
)
for %%a in (Dependencies\Downloads\qaac_%version%.zip) do (
	set temporary=%%~na
	set setup_file=%%a
)
for %%a in (Dependencies\Downloads\iTunes%itunes_bit%Setup.exe) do set itunes_setup_file=%%a
set temp_app_path=%TEMP%\%app_folder%_Temp
set itunes_msi=iTunes%itunes_bit%.msi
set dlls=ASL.dll CoreAudioToolbox.dll CoreFoundation.dll icudt62.dll libdispatch.dll libicuin.dll libicuuc.dll objc.dll
for %%a in (Dependencies\Downloads\flac_dll-%libflac_version%-x%libflac_bit%.zip) do set libflac_setup_file=%%a
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
set PATH=%ORIGINAL_PATH%
goto end

:del
if exist %1 del %1>nul 2>&1
if exist %1 goto error
goto end

:error
echo Sorry, something went wrong.
goto end

:install
if not defined setup_file goto error
if not defined itunes_setup_file goto error
call :uninstall
echo Installing %app_name%...
echo.
7z e %setup_file% -o%app_folder%\App %temporary%\%bit%\* -r>nul 2>&1
rd %app_folder%>nul 2>&1
call :rd "%temp_app_path%"
7z x %itunes_setup_file% -o"%temp_app_path%" %itunes_msi%>nul 2>&1
cd %app_folder%
cd App
set app_path=%CD%
setlocal enabledelayedexpansion
for %%i in (*64.exe) do (
	set exe=%%i
	set cmd_file=!exe:64.exe=!.cmd
	echo @echo off>!cmd_file!
	echo set app_dir=%%~dp0>>!cmd_file!
	echo if [%%app_dir:~-1%%] == [\] set app_dir=%%app_dir:~0,-1%%>>!cmd_file!
	echo set exe_path=%%app_dir%%\!exe!>>!cmd_file!
	echo if not "%%exe_path: =%%" == "%%exe_path%%" set exe_path="%%exe_path%%">>!cmd_file!
	echo %%exe_path%% %%^*>>!cmd_file!
)
endlocal
pushd "%temp_app_path%"
msiexec /a %itunes_msi% TARGETDIR="%CD%\%itunes_msi:.msi=%" /quiet
robocopy %itunes_msi:.msi=%\iTunes %app_path% %dlls%>nul 2>&1
popd
call :rd "%temp_app_path%"
cd..
cd..
7z x %libflac_setup_file% -o%app_folder%\App *.dll>nul 2>&1
echo %app_name% has been successfully installed.
goto end

:rd
if exist %1 rd %1 /q /s>nul 2>&1
if exist %1 goto error
goto end

:ren
if not exist %1 goto error
if not exist %2 ren %1 %2>nul 2>&1
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
