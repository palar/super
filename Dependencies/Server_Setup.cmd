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
for %%a in (Dependencies\Downloads\nginx-%version%*) do set setup_file=%%a
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

:error
echo Sorry, something went wrong.
goto end

:install
if not defined setup_file goto error
call :uninstall
set action=%0
set action=%action::=--%
echo Installing %app_name%...
echo.
cd Dependencies
cmd /c Nginx_Setup.cmd %action%>nul 2>&1
:: cmd /c MariaDB_Setup.cmd %action%>nul 2>&1
cmd /c PHP_Setup.cmd %action%>nul 2>&1
cmd /c FileGator_Setup.cmd %action%>nul 2>&1
cd..
rd %app_folder%>nul 2>&1
if not exist %app_folder% goto error
echo %app_name% has been successfully installed.
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
set action=%0
set action=%action::=--%
cd Dependencies
cmd /c Nginx_Setup.cmd %action%>nul 2>&1
cmd /c MariaDB_Setup.cmd %action%>nul 2>&1
cmd /c PHP_Setup.cmd %action%>nul 2>&1
cmd /c FileGator_Setup.cmd %action%>nul 2>&1
cd..
rd %app_folder%\App>nul 2>&1
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
