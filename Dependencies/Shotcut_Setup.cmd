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
for %%a in (Dependencies\Downloads\shotcut-win64-%version%.zip) do set setup_file=%%a
set a=%0
set b=%1
set c=%2
set d=%3
if defined c set c= %c%
if defined d set d= %d%
:: if [%b%] == [] start /max cmd /c "color %cmd_color% & %a% wrapper %setup_title% install"
if [%b%] == [] start %setup_title% cmd /c "color %cmd_color% & nircmd win center title %setup_title%>nul 2>&1 & %a% wrapper %setup_title% install"
call :start %b%%c%%d%
popd
set PATH=%ORIGINAL_PATH%
goto end

:error
echo Sorry, something went wrong.
goto end

:install
if not defined setup_file goto error
call :uninstall
echo Installing %app_name%...
echo.
7z x %setup_file% -o%app_folder%>nul 2>&1
rd %app_folder%>nul 2>&1
if not exist %app_folder% goto error
call :ren %app_folder%\%app_folder% App
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
if defined first set first=:%first%
if defined second set second= %second%
if defined third set third= %third%
call %first%%second%%third%
goto end

:uninstall
call :rd %app_folder%\%temporary%
call :rd %app_folder%\App
rd %app_folder%>nul 2>&1
goto end

:wrapper
set first=%1
set second=%2
if defined first set first=%first:"=%
if defined second set second=:%second%
title %first%
echo.
echo %first%
echo.
call %second%
echo.
set /p pause=Press Enter to continue... 
goto end

:end
