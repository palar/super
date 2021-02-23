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
set commonfiles=CommonFiles
set toontrack=Toontrack
set powerdrumkit_version=*
set bassmidi_bit=64
set powerdrumkit_bit=64
set toontrack_bit=64
if not defined ProgramFiles(x86) (
	set bassmidi_bit=86
	set powerdrumkit_bit=32
	set toontrack_bit=32
)
set ezmix_presets=%toontrack%\EZmix\Presets
for %%a in (Dependencies\Downloads\MTPDK-%powerdrumkit_version%-VST-%powerdrumkit_bit%bit-Win-FULL.zip) do set powerdrumkit_setup_file=%%a
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

:del
if exist %1 del %1>nul 2>&1
if exist %1 goto error
goto end

:error
echo Sorry, something went wrong.
goto end

:install
call :uninstall
echo Installing %app_name%...
echo.
7z e Dependencies\Downloads\bassmidi_vsti.zip -o%commonfiles%\%app_folder% *%bassmidi_bit%\bass.dll *%bassmidi_bit%\bassmidi.dll *%bassmidi_bit%\BassMidiVsti.dll -r>nul 2>&1
7z e Dependencies\Downloads\%toontrack%.zip -o%commonfiles%\%app_folder% %toontrack_bit%-bit\EZmix.dll -r>nul 2>&1
7z e %powerdrumkit_setup_file% -o%commonfiles%\%app_folder% MT-PowerDrumKit.dll MT-PowerDrumKit-Content.pdk -r>nul 2>&1
rd %commonfiles%>nul 2>&1
if not exist %commonfiles% goto error
cd %commonfiles%
if not exist %app_folder% cd.. & goto error
cd..
echo %app_name% has been successfully installed.
7z x Dependencies\Downloads\EZmix_Packs.zip -o"%ProgramData%">nul 2>&1
pushd "%ProgramData%"
if not exist %ezmix_presets% popd & goto end
pushd %ezmix_presets%
call :del EMX_Ambient
call :del EMX_AndySneap
call :del EMX_BassToolbox
call :del EMX_ClassicAmps
call :del EMX_LeadVocals
call :del EMX_MasteringII
call :del EMX_MetalAmps
call :del EMX_TheMixToolbox
popd
popd
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
call :rd "%APPDATA%\%toontrack%"
call :rd "%ProgramData%\%toontrack%"
if not exist %commonfiles% goto end
cd %commonfiles%
if not exist %app_folder% goto uninstall-end
cd %app_folder%
del bass.dll bassmidi.dll BassMidiVsti.dll EZmix.dll MT-PowerDrumKit.dll MT-PowerDrumKit-Content.pdk>nul 2>&1
cd..
rd %app_folder%>nul 2>&1
:uninstall-end
cd..
rd %commonfiles%>nul 2>&1
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
