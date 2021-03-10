@echo off
setlocal enabledelayedexpansion

set cmd_color=f0
set this=%~f0
if not "%this: =%" == "%this%" set this="%this%"
set this_backup=%~dp0%~n0_Backup%~x0
if not "%this_backup: =%" == "%this_backup%" set this_backup="%this_backup%"
set apps=7-Zip, aria2, Audacity, balcon, BusyBox, CCleaner, Chromium, curl, FFmpeg, FileZilla, FLAC, FluidSynth, foobar2000, "Free Encoder Pack", "Google Chrome", GRUB, HTTrack, ImgBurn, LAME, MediaInfo, "Microsoft Edge", "Microsoft Visual C++ 2015-2019 Redistributable", "MIDI Player", MinGit, "Mozilla Firefox", MPlayer, mpv, MuseScore, nano, NirCmd, Notepad++, Opera, "Opera GX" PeaZip, PicPick, png2ico, pngquant, PortableGit, Psiphon, qaac, REAPER, Shotcut, Skype, SoundFonts, TeamViewer, Telegram, TimeSync, "Visual Studio Code", "VLC media player", "VNC Viewer", VST, Wget, WordWeb, youtube-dl
set dependencies_dir=%~dp0
if [%dependencies_dir:~-1%] == [\] set dependencies_dir=%dependencies_dir:~0,-1%
set self=%~n0
set settings_ini=%dependencies_dir%\%self%.ini
set settings_ini_backup=%dependencies_dir%\%self%_Backup.ini
pushd "%dependencies_dir%\.."
set apps_dir=%CD%
set settings_dir=%apps_dir%\Settings
set commonfiles=%apps_dir%\CommonFiles
set soundfonts=%commonfiles%\SoundFonts
set soundfont=%soundfonts%\GeneralUser GS v*.sf2
set HOME=%settings_dir%
set is_speak=0
set is_admin=0
set users_file=users
set users_txt=%users_file%.txt
if not exist %users_txt% goto continue
set /p users=<%users_txt%
for %%i in (%users%) do (
	if /i "%USERNAME%" == "%%i" set is_admin=1
	goto continue
)
:continue
pushd "%apps_dir%\.."
set home_dir=%CD%
if not "%home_dir: =%" == "%home_dir%" set home_dir="%home_dir%"
popd
popd
set hostname=127.0.0.1
set psiphon_port=3128
set privoxy_port=8118
set old_privoxy_config=config.old.txt
set privoxy_config=config.txt
set match-all_action=match-all.action
set user_action=user.action
set proxy_server=
set http_proxy=
set https_proxy=
set start_page=about:blank
set chrome_proxy_settings=
set vlc_proxy_settings=
:: set user_agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:86.0) Gecko/20100101 Firefox/86.0
:: if not defined ProgramFiles(x86) set user_agent=%user_agent:Win64; x64=WOW64%
set bit=64
set ccleaner=64
set chrome=64
set mingw=64
set nano=x86_64
if not defined ProgramFiles(x86) (
	set bit=32
	set ccleaner=
	set chrome=32
	set mingw=32
	set nano=i686
)
for /f %%i in ('wmic path Win32_VideoController get CurrentHorizontalResolution /value ^| find "="') do set %%i
set screen_width=%CurrentHorizontalResolution%
set video_width=854
set video_height=480
:: https://github.com/curl/curl/wiki/DNS-over-HTTPS
:: set network_security_esni_enabled=true
:: set network_trr_uri=https://dns-family.adguard.com/dns-query
:: if %is_admin% == 0 set network_trr_uri=https://dns.adguard.com/dns-query
:: set network_trr_mode=3
set dependencies=Dependencies
set scripts=%dependencies%
set dependencies_downloads=%dependencies%\Downloads
set desktop=Desktop
set documents=Documents
set downloads=Downloads
set music=Music
set pictures=Pictures
set projects=Projects
set videos=Videos
set html=html
set html_apps=%html%\apps
set archive=%self%.zip
set list=%self%.txt
set setup=%scripts%\%self%_Setup.cmd
if "%PATH:~-1%" == ";" set PATH=%PATH:~0,-1%
if not defined SUPER_PATH set SUPER_PATH=%apps_dir%;%apps_dir%\7-Zip\App;%apps_dir%\aria2\App;%apps_dir%\balcon\App;%apps_dir%\curl\App\bin;%apps_dir%\FFmpeg\App\bin;%apps_dir%\FLAC\App;%apps_dir%\FluidSynth\App\bin;%apps_dir%\foobar2000\App\encoders;%apps_dir%\HTTrack\App\httrack;%apps_dir%\LAME\App;%apps_dir%\MediaInfo\App;%apps_dir%\MPlayer\App;%apps_dir%\mpv\App;%apps_dir%\nano\App\%nano%-w64-mingw32\bin;%apps_dir%\ngrok\App;%apps_dir%\NirCmd\App;%apps_dir%\Server\App\MariaDB\bin;%apps_dir%\Server\App\PHP;%apps_dir%\Node.js\App;%apps_dir%\png2ico\App;%apps_dir%\pngquant\App;%apps_dir%\qaac\App;%apps_dir%\Ruby\App\bin;%apps_dir%\Sass\App;%apps_dir%\Shotcut\App;%apps_dir%\VNC_Viewer\App;%apps_dir%\Wget\App;%apps_dir%\XAMPP\App\php;%apps_dir%\youtube-dl\App;%apps_dir%\CommonFiles\Microsoft_Visual_C++_2015-2019_Redistributable;%PATH%;
set PATH=%SUPER_PATH%
goto main

:7-zip
call :sanitize input %1
if not defined input (
	set input=%CD%
	if "%CD%" == "%dependencies_dir%" set input=%home_dir%
)
set input= %input:&=^&%
call :check-process %sevenzip_exe% 7-Zip
if not %process_status% == 0 goto end
set sevenzip_default_settings=reg delete %hkcu_software_sevenzip% /f ampersand reg add %hkcu_software_sevenzip_preferences% /v Panels /t REG_BINARY /d 0200000000000000a8020000 /f ampersand reg add %hkcu_software_sevenzip_preferences% /v Position /t REG_BINARY /d 1a0000001a0000001b0400002702000001000000 /f
set sevenzip_command_start=reg import "%sevenzip_reg%"
if not exist "%sevenzip_reg%" set sevenzip_command_start=%sevenzip_default_settings%
set sevenzip_command_end=md "%sevenzip_data_dir%" ampersand reg export %hkcu_software_sevenzip% "%sevenzip_reg%" /y
if %is_admin% == 0 (
	set sevenzip_command_start=%sevenzip_default_settings%
	set sevenzip_command_end=rd "%sevenzip_data_dir%" /q /s
)
if exist "%local_sevenzip%" goto 7-zip_default
if exist "%local_sevenzip_x86%" goto 7-zip_default
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & %sevenzip_command_start:ampersand=&% & "%sevenzip_exe_path%"%input% & %sevenzip_command_end:ampersand=&% & reg delete %hkcu_software_sevenzip% /f & %this% speak "7-Zip was closed"">nul 2>&1
goto end
:7-zip_default
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%sevenzip_exe_path%"%input% & %this% speak "7-Zip was closed"">nul 2>&1
goto end

:about
echo A terminal emulator and command-line interface (CLI).
goto end

:app
pushd "%apps_dir%"
set app_url=%1
if not defined app_url goto end
set app=chrome
set app_mode=app
if [%app_url%] == [gmail] set app_url=https://mail.google.com/mail
if [%app_url%] == [google-drive] set app_url=https://drive.google.com/
if [%app_url%] == [onedrive] set app_url=https://onedrive.live.com/
if [%app_url%] == [outlook] set app_url=https://outlook.live.com/
if [%app_url%] == [spotify] set app_url=https://open.spotify.com/
if [%app_url%] == [youtube-music] set app_url=https://music.youtube.com/
if [%app_url%] == [youtube-on-tv] (
	set "user_agent=Mozilla/5.0 (SMART-TV; LINUX; Tizen 5.5) AppleWebKit/537.36 (KHTML, like Gecko) 69.0.3497.106.1/5.5 TV Safari/537.36"
	set app=chromium
	set app_mode=kiosk
	set app_url=https://www.youtube.com/tv
)
if [%app_url%] == [youtube] set app_url=https://www.youtube.com/
call :%app% %app_mode% %app_url%
popd
goto end

:audacity
call :require Audacity
call :sanitize input %1
if defined input set input= %input:&=^&%
call :check-process "%audacity_exe_path%" Audacity
if not %process_status% == 0 (
	if defined input set input=%input:^=%
	start "" "%audacity_exe_path%"!input!
	goto end
)
call :md "%audacity_config_dir%"
if exist "%audacity_data_dir%" robocopy "%audacity_data_dir%" "%audacity_config_dir%" /mir>nul 2>&1
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & ren "%localappdata_audacity%" Audacity_Backup & "%audacity_exe_path%"%input% & rd "%localappdata_audacity%" /q /s & ren "%localappdata_audacity%_Backup" Audacity & robocopy "%audacity_config_dir%" "%audacity_data_dir%" /mir & rd "%audacity_config_dir%" /q /s & %this% speak "Audacity was closed"">nul 2>&1
goto end

:backup
call :backup-cmd-and-ini
call :backup-and-restore
goto end

:backup-and-compress
pushd "%apps_dir%"
del %archive% %list%>nul 2>&1
for %%i in (%dependencies_downloads%\*.*) do (
	set line=%%i
	echo !line:\=/!>>%list%
)
for /d %%i in (%dependencies_downloads%\*) do (
	for %%j in (%%i\*.*) do (
		set line=%%j
		echo !line:\=/!>>%list%
	)
)
7z a -tzip %archive% README.md %self%.cmd %list% %dependencies_downloads%\aria2-*.zip %dependencies_downloads%\nircmd*.zip 7-Zip\App %scripts%\*.cmd %scripts%\*.ini %html% ngrok\ Settings\ Shortcuts\>nul 2>&1
popd
goto end

:backup-and-restore
for %%* in (%apps_dir%) do set destination_folder=%%~n*
set option=%1
if not defined option goto backup-and-restore_location
if [%option%] == [restore] goto backup-and-restore_from
:backup-and-restore_from
set restore_source=
set /p restore_source=Source: 
if not defined restore_source goto backup-and-restore_from
set restore_source=%restore_source:"=%
set default_restore_source=%restore_source:~0,1%:\%destination_folder%
if [%restore_source%] == [%restore_source:~0,1%] set restore_source=%default_restore_source%
if [%restore_source:~-1%] == [:] set restore_source=%default_restore_source%
if [%restore_source:~-2%] == [:\] set restore_source=%default_restore_source%
if [%restore_source:~-1%] == [\] set restore_source=%restore_source:~0,-1%
for %%* in ("%restore_source%") do set working_folder=%%~n*
if /i not "%destination_folder%" == "%working_folder%" set restore_source=%restore_source%\%destination_folder%
call :sanitize restore_source "%restore_source:"=%"
if not exist %restore_source% goto backup-and-restore_from
for %%* in ("%apps_dir%") do call :sanitize location "%%~dp*"
set source=%restore_source:"=%
goto backup-and-restore_start
:backup-and-restore_location
set location=
set /p location=Location: 
if not defined location goto backup-and-restore_location
if [%location%] == [%location:~0,1%] set location=%location%:\
if [%location:~-1%] == [\] set location=%location:~0,-1%
call :sanitize location "%location:"=%"
if not exist %location% goto backup-and-restore_location
set source=%apps_dir%
:backup-and-restore_start
for %%* in (%location%) do (
	set destination_path=%%~dp*
	set working_folder=%%~n*
)
if [%destination_path:~-1%] == [\] set destination_path=%destination_path:~0,-1%
if /i "%working_folder%" == "%destination_folder%" call :sanitize location %destination_path%
pushd %location%
call :md %destination_folder%>nul 2>&1
if not exist %destination_folder% goto backup-and-restore
cd %destination_folder%
robocopy "%source%" . /xf %users_file% %users_txt%
robocopy "%source%\7-Zip" 7-Zip /mir /xd Data
:: robocopy "%source%\CommonFiles" CommonFiles /mir /xd VST
robocopy "%source%\%dependencies%" %dependencies% /mir
robocopy "%source%\%html%" %html% /mir /xd filegator
:: robocopy "%source%\%html_apps%" %html_apps% /mir
robocopy "%source%\ngrok" ngrok /mir
robocopy "%source%\NirCmd" NirCmd /mir
robocopy "%source%\Psiphon\Data" Psiphon\Data /mir
robocopy "%source%\Settings" Settings /mir /xf known_hosts
cd..
popd
goto end

:backup-cmd-and-ini
pushd "%apps_dir%"
cd %dependencies%
call :rd "%self%_Backup"
call :md "%self%_Backup"
cd "%self%_Backup"
robocopy ..\ . %self%.*>nul 2>&1
call :ren %self%.* %self%_Backup.*
robocopy . ..\ %self%_Backup.*>nul 2>&1
cd..
call :rd "%self%_Backup"
cd..
popd
goto end

:busybox
cmd /c %self% center BusyBox terminal "" busybox
goto end

:ccleaner
call :require CCleaner
call :check-process %ccleaner_exe% CCleaner
if not %process_status% == 0 goto end
pushd "%apps_dir%"
if not exist CCleaner (
	popd
	goto end
)
cd CCleaner
cd App
echo [Options]>%ccleaner_ini%
echo HomeScreen=^2>>%ccleaner_ini%
echo DefaultDetailedView=^2>>%ccleaner_ini%
echo UpdateBackground=^0>>%ccleaner_ini%
echo UpdateCheck=^0>>%ccleaner_ini%
echo DelayTemp=^0>>%ccleaner_ini%
echo HideWarnings=^1>>%ccleaner_ini%
echo BackupPrompt=^0>>%ccleaner_ini%
echo JumplistTasks=^0>>%ccleaner_ini%
echo HelpImproveCCleaner=^0>>%ccleaner_ini%
echo PrefsPrivacyShowOffers1stParty=^0>>%ccleaner_ini%
echo ShowCleanWarning=False>>%ccleaner_ini%
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & %ccleaner_exe% & del %ccleaner_ini% & reg delete %hkcu_software_piriform% /f & reg delete %hklm_software_piriform% /f & %this% speak "CCleaner was closed"">nul 2>&1
cd..
cd..
popd
goto end

:cd-ripper
:: call :require MPlayer
call :require "VLC media player"
set drive=
set /p drive=Drive: 
if not defined drive goto cd-ripper
set drive=%drive:~0,1%:
set count=
for %%i in (%drive%\*.cda) do set /a count+=1
if not defined count goto cd-ripper
:cd-ripper_codec
set codec=
set /p codec=Codec: 
if not defined codec goto cd-ripper_codec
cd /d %home_dir%
:cd-ripper_location
set location=
set /p location=Location: 
if not defined location goto cd-ripper_location
call :sanitize location "%location:"=%"
if not exist %location% goto cd-ripper_location
pushd %location%
echo.
set track=
:cd-ripper_loop
set /a track+=1
set index=%track%
if %track% leq 9 set index=0%track%
set wav_file="%index% Track.wav"
:: mplayer -ao pcm:fast -ao pcm:file=%wav_file% -cdrom-device %drive% cdda://%track%
call :md "%vlc_config_dir%"
"%vlc_exe_path%" --intf=dummy cdda:///%drive%/ --ignore-config --cdda-track=%track% --sout="#transcode{acodec=s16l,channels=2}:std{access=file,mux=wav,dst=%wav_file:"='%}" vlc://quit
call :transcode %wav_file% %codec% rip
if /i not [%codec%] == [wav] call :del %wav_file%
if %track% lss %count% goto cd-ripper_loop
rd "%vlc_config_dir%" /q /s
echo.
popd
goto cd-ripper

:cdn
call :require Wget
pushd "%apps_dir%"
:: -N --no-if-modified-since
for %%i in (%html_dependencies%) do wget --no-check-certificate --no-hsts --directory-prefix=%html% --force-directories %%i
popd
goto end

:check-privilege
set process_name=%1
set process_description=%2
if not defined process_name goto end
if not defined process_description set process_description=%process_name::=%
set process_description=%process_description:"=%
set privilege=0
openfiles>nul 2>&1
if not errorlevel 1 set privilege=1
if not %privilege% == 1 echo %process_description% requires administrator privileges.
goto end

:check-process
set process_name=%1
set process_name=%process_name:"=%
if not defined process_name goto end
set command=tasklist /fi "imagename eq %process_name%" /nh
if not "%process_name::=%" == "%process_name%" set command=wmic process get ExecutablePath
set process_description=%2
if not defined process_description set process_description=%process_name%
set process_description=%process_description:"=%
%command% | find /i "%process_name%">nul && (
set process_status=1
echo %process_description% is already running.
) || (
set process_status=0
)
goto end

:checksum
set algorithm=
set /p algorithm=Algorithm: 
if not defined algorithm goto checksum
:checksum_input_file
set input_file=
set /p input_file=File: 
if not defined input_file goto checksum_input_file
if not exist "%input_file:"=%" goto checksum_input_file
call :sanitize input_file "%input_file:"=%"
echo.
for /f "tokens=* delims=" %%i in ('certutil -hashfile "%input_file:"=%" %algorithm%') do (
	set line=%%i
	if /i "!line:%algorithm%=!" == "!line!" (
		if /i "!line:certutil=!" == "!line!" set checksum_result=!line!
	)
)
if not defined checksum_result (
	call :error
	goto checksum_end
)
echo %checksum_result: =%
:checksum_end
echo.
goto checksum_input_file

:chrome
call :require "Google Chrome"
call :sanitize input %1
set unsanitized_input=%1
if defined unsanitized_input call :sanitize input %2
if not defined unsanitized_input set unsanitized_input=%start_page%
if [%unsanitized_input%] == [app] set chrome_mode=--new-window --%unsanitized_input%=
if [%unsanitized_input%] == [incognito] set chrome_mode=--%unsanitized_input% 
if [%unsanitized_input%] == [kiosk] set chrome_mode=--%unsanitized_input% 
if [%unsanitized_input%] == [tv] set chrome_mode=--new-window --start-fullscreen --app=
if not defined input set input=%start_page%
set input= %chrome_mode%%input:&=^&%
call :check-process "%chrome_exe_path%" "Google Chrome">nul 2>&1
if not %process_status% == 0 (
	start "" "%chrome_exe_path%" --user-data-dir="%chrome_data_dir%"%input:^=%
	goto end
)
call :check-process privoxy.exe Privoxy>nul 2>&1
if not %process_status% == 1 (
	if %is_admin% == 0 cmd /c %this% superproxy
)
call :settings
if %is_admin% == 0 call :rd "%chrome_data_dir%"
if defined install_chrome_extensions call :chrome-extensions "%chrome_data_dir%" "%install_chrome_extensions%"
set chrome_switches=!chrome_switches:--user-data-dir=--user-data-dir="%chrome_data_dir%"!
:: if %is_admin% == 0 call :rd "%chrome_dictionaries_dir%"
set chrome_clean_appdata=echo.
if %is_admin% == 1 set chrome_clean_appdata=rd "%local_google_dir%" /q /s
:: call :disable-chrome-history "%chrome_profile_dir%"
set chrome_command=%this% disable-chrome-history "%chrome_profile_dir%"
:: if %is_admin% == 0 set chrome_command=rd "%chrome_dictionaries_dir%" "%chrome_data_dir%" /q /s ampersand rd "%chrome_app_dir%" "%google_data_dir%" "%google_dir%"
if exist "%local_chrome_exe_path%" goto chrome_default
if exist "%local_chromium_exe_path%" goto chrome_default
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & ren "%local_chrome_dir%" Chrome_Backup & "%chrome_exe_path%"%chrome_switches%%input% & %chrome_command:ampersand=&% & rd "%local_chrome_dir%" "%local_google_software_reporter_tool_dir%" /q /s & ren "%local_chrome_dir%_Backup" Chrome & rd "%local_google_dir%" & %chrome_clean_appdata% & reg delete %hkcu_software_google% /f & %this% clear-recent-items & %this% speak "Chrome was closed"">nul 2>&1
goto end
:chrome_default
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%chrome_exe_path%"%chrome_switches%%input% & %chrome_command:ampersand=&% & %this% clear-recent-items & %this% speak "Chrome was closed"">nul 2>&1
goto end

:chrome-extensions
set destination=%1
if not defined destination goto end
set destination=%destination:"=%
set installed_extensions=%2
if not defined installed_extensions goto end
set installed_extensions=%installed_extensions:"=%
set count=
for %%i in (%installed_extensions%) do (
	set /a count+=1
	set extension_path=%destination%\Extensions\%%i
	if not exist !extension_path! 7z x "%apps_dir%\%dependencies_downloads%\%%i.crx" -o!extension_path!>nul 2>&1
	if exist !extension_path! (
		if !count! gtr 1 if defined enabled_extensions set enabled_extensions=!enabled_extensions!,
		set enabled_extensions=!enabled_extensions!!extension_path!
	)
)
if defined enabled_extensions (
	set disable_extensions_except=--disable-extensions-except="%enabled_extensions%"
	set load_extension=--load-extension="%enabled_extensions%"
)
set chrome_switches=!chrome_switches:--disable-extensions=%disable_extensions_except%!
set chrome_switches=!chrome_switches:--load-extension=%load_extension%!
set chromium_switches=!chromium_switches:--disable-extensions=%disable_extensions_except%!
set chromium_switches=!chromium_switches:--load-extension=%load_extension%!
set edge_switches=!edge_switches:--disable-extensions=%disable_extensions_except%!
set edge_switches=!edge_switches:--load-extension=%load_extension%!
goto end

:chromium
call :require Chromium
call :sanitize input %1
set unsanitized_input=%1
if defined unsanitized_input call :sanitize input %2
if not defined unsanitized_input set unsanitized_input=%start_page%
if [%unsanitized_input%] == [app] set chromium_mode=--new-window --%unsanitized_input%=
if [%unsanitized_input%] == [incognito] set chromium_mode=--%unsanitized_input% 
if [%unsanitized_input%] == [kiosk] set chromium_mode=--%unsanitized_input% 
if [%unsanitized_input%] == [tv] set chromium_mode=--new-window --start-fullscreen --app=
if not defined input set input=%start_page%
set input= %chromium_mode%%input:&=^&%
call :check-process "%chromium_exe_path%" Chromium>nul 2>&1
if not %process_status% == 0 (
	start "" "%chromium_exe_path%" --user-data-dir="%chromium_data_dir%"%input:^=%
	goto end
)
call :check-process privoxy.exe Privoxy>nul 2>&1
if not %process_status% == 1 (
	if %is_admin% == 0 cmd /c %this% superproxy
)
call :settings
if %is_admin% == 0 call :rd "%chromium_data_dir%"
if defined install_chromium_extensions call :chrome-extensions "%chromium_data_dir%" "%install_chromium_extensions%"
set chromium_switches=!chromium_switches:--user-data-dir=--user-data-dir="%chromium_data_dir%"!
:: if %is_admin% == 0 call :rd "%chromium_dictionaries_dir%"
set chromium_clean_appdata=echo.
if %is_admin% == 1 set chromium_clean_appdata=rd "%local_chromium_dir%" /q /s
:: call :disable-chrome-history "%chromium_profile_dir%"
set chromium_command=%this% disable-chrome-history "%chromium_profile_dir%"
:: if %is_admin% == 0 set chromium_command=rd "%chromium_dictionaries_dir%" "%chromium_data_dir%" /q /s ampersand rd "%chromium_dir%"
if exist "%local_chromium_exe_path%" goto chromium_default
if exist "%local_chrome_exe_path%" goto chromium_default
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & ren "%local_chromium_dir%" Chromium_Backup & "%chromium_exe_path%"%chromium_switches%%input% & %chromium_command:ampersand=&% & rd "%local_chromium_dir%" /q /s & ren "%local_chromium_dir%_Backup" Chromium & %chromium_clean_appdata% & reg delete %hkcu_software_chromium% /f & reg delete %hkcu_software_google% /f & %this% clear-recent-items & %this% speak "Chromium was closed"">nul 2>&1
goto end
:chromium_default
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%chromium_exe_path%"%chromium_switches%%input% & %chromium_command:ampersand=&% & %this% clear-recent-items & %this% speak "Chromium was closed"">nul 2>&1
goto end

:clear-recent-items
pushd "%APPDATA%\Microsoft\Windows\Recent"
call :del *.lnk
call :del AutomaticDestinations\*.automaticDestinations-ms
call :del CustomDestinations\*.customDestinations-ms
popd
goto end

:close
set window_title=%1
if not defined window_title goto end
nircmd win close stitle %window_title%
goto end

:code
call :require "Visual Studio Code"
call :sanitize input %1
if defined input set input= %input:&=^&%
call :check-process "%vscode_exe_path%" "Visual Studio Code">nul 2>&1
if not %process_status% == 0 (
	if defined input set input=%input:^=%
	cmd /c "start "" "%vscode_exe_path%"!input!"
	goto end
)
call :rd "%vscode_data_dir%"
call :md "%vscode_user_data_dir%\User"
echo {>%vscode_settings%
echo     "editor.parameterHints": false,>>%vscode_settings%
echo     "editor.wordWrap": "on",>>%vscode_settings%
echo     "workbench.colorTheme": "Quiet Light",>>%vscode_settings%
echo     "workbench.startupEditor": "newUntitledFile",>>%vscode_settings%
echo     "window.newWindowDimensions": "maximized",>>%vscode_settings%
echo     "files.autoSave": "afterDelay",>>%vscode_settings%
echo     "update.mode": "none",>>%vscode_settings%
echo     "telemetry.enableCrashReporter": false,>>%vscode_settings%
echo     "telemetry.enableTelemetry": false,>>%vscode_settings%
echo     "git.ignoreMissingGitWarning": true>>%vscode_settings%
echo }>>%vscode_settings%
if exist "%local_vscode%" goto code_default
if exist "%local_vscode_x86%" goto code_default
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & ren "%appdata_code%" Code_Backup & "%vscode_exe_path%"%input% & rd "%appdata_code%" "%vscode_data_dir%" /q /s & ren "%appdata_code%_Backup" Code & %this% speak "Visual Studio Code was closed"">nul 2>&1
goto end
:code_default
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%vscode_exe_path%"%input% & rd "%vscode_data_dir%" /q /s & %this% speak "Visual Studio Code was closed"">nul 2>&1
goto end

:corporate-app
set company=%1
if not defined company goto end
for %%i in (microsoft, google, mozilla) do (
	if /i "%company::=%" == "%%i" (
		set app_label=%2
		if not defined app_label goto end
	)
)
call :%app_label% %3 %4
goto end

:del
if exist %1 del %1>nul 2>&1
if exist %1 goto end
goto end

:delete
call :permanently-delete
goto end

:disable-chrome-history
if %is_admin% == 1 goto end
set dir=%1
call :sanitize dir "%dir:"=%"
if not exist %dir% goto end
pushd %dir%
type nul>History
type nul>History-journal
type nul>Shortcuts
type nul>Shortcuts-journal
popd
goto end

:disconnect
pushd "%apps_dir%"
call :kill privoxy.exe
cd %scripts%
cmd /c Privoxy_Setup uninstall
cd..
call :kill psiphon3.exe
reg delete %hkcu_software_psiphon3% /f>nul 2>&1
call :rd "%appdata_psiphon3%"
popd
goto end

:dns-resolvers
if "%2" == "adguard" call :set-dns-resolvers %1 "176.103.130.130,176.103.130.131" "2a00:5a60::ad1:0ff,2a00:5a60::ad2:0ff">nul 2>&1
if "%2" == "adguard-family-protection" call :set-dns-resolvers %1 "176.103.130.132,176.103.130.134" "2a00:5a60::bad1:0ff,2a00:5a60::bad2:0ff">nul 2>&1
if "%2" == "cleanbrowsing-adult-filter" call :set-dns-resolvers %1 "185.228.168.10,185.228.169.11" "2a0d:2a00:1::1,2a0d:2a00:2::1">nul 2>&1
if "%2" == "cleanbrowsing-family-filter" call :set-dns-resolvers %1 "185.228.168.168,185.228.169.168" "2a0d:2a00:1::,2a0d:2a00:2::">nul 2>&1
if "%2" == "cleanbrowsing-security-filter" call :set-dns-resolvers %1 "185.228.168.9,185.228.169.9" "2a0d:2a00:1::2,2a0d:2a00:2::2">nul 2>&1
if "%2" == "cloudflare" call :set-dns-resolvers %1 "1.1.1.1,1.0.0.1" "2606:4700:4700::1111,2606:4700:4700::1001">nul 2>&1
if "%2" == "dns.sb" call :set-dns-resolvers %1 "185.222.222.222,185.184.222.222" "2a09::,2a09::1">nul 2>&1
if "%2" == "google" call :set-dns-resolvers %1 "8.8.8.8,8.8.4.4" "2001:4860:4860::8888,2001:4860:4860::8844">nul 2>&1
if "%2" == "opendns" call :set-dns-resolvers %1 "208.67.222.222,208.67.220.220" "2620:119:35::35,2620:119:53::53">nul 2>&1
if "%2" == "opendns-familyshield" call :set-dns-resolvers %1 "208.67.222.123,208.67.220.123" "2620:119:35::123,2620:119:53::123">nul 2>&1
if "%2" == "quad9" call :set-dns-resolvers %1 "9.9.9.9,149.112.112.112" "2620:fe::fe,2620:fe::9">nul 2>&1
if "%2" == "quad9-secured" call :set-dns-resolvers %1 "9.9.9.11,149.112.112.11" "2620:fe::11,2620:fe::fe:11">nul 2>&1
if "%2" == "quad9-unsecured" call :set-dns-resolvers %1 "9.9.9.10,149.112.112.10" "2620:fe::10,2620:fe::fe:10">nul 2>&1
if "%2" == "reset" call :set-dns-resolvers %1 "" "">nul 2>&1
goto end

:download
call :require aria2
if [%1] == [curl] call :require curl
if [%1] == [wget] call :require Wget
cd /d %home_dir%
:download_location
set location=
set /p location=Location: 
if not defined location set location=%USERPROFILE%\Downloads
call :sanitize location "%location:"=%"
if not exist %location% goto download_location
echo.
echo The files will be saved in %location%
echo.
:download_input_file
set input_file=
set /p input_file=File: 
if not defined input_file goto download_input_file
if [%1] == [curl] (
	echo.
	pushd %location%
	curl --continue-at - --remote-header-name --remote-name --remote-time "%input_file:"=%"
	popd
	echo.
	goto download_input_file
)
if [%1] == [wget] (
	echo.
	wget --continue --directory-prefix=%location% --no-check-certificate --no-hsts --no-if-modified-since --timestamping "%input_file:"=%"
	goto download_input_file
)
aria2c --check-certificate=false --conditional-get=true --dir=%location% --max-connection-per-server=16 --remote-time=true "%input_file:"=%"
echo.
goto download_input_file

:download-adminer
call :require aria2
set adminer_master_file=%dependencies_downloads%\adminer-master.zip
pushd "%apps_dir%"
aria2c --check-certificate=false --conditional-get=true --dir="%apps_dir%\%html_apps%\adminer" --max-connection-per-server=16 --out=adminer.php --remote-time=true https://www.adminer.org/latest-mysql-en.php
if not exist %adminer_master_file% (
	aria2c --check-certificate=false --conditional-get=true --dir=%dependencies_downloads% --max-connection-per-server=16 --remote-time=true https://github.com/vrana/adminer/archive/master.zip
) else (
	call :rd %html_apps%\adminer\plugins
)
if not exist %html_apps%\adminer\plugins call :require Adminer
if not exist %html_apps%\adminer\plugins (
	popd
	goto error
)
:download-adminer_clean
call :del %adminer_master_file%
if exist %adminer_master_file% goto download-adminer-adminer_clean
popd
goto end

:download-edge
call :require Wget
set version=%1
if not defined version goto end
pushd "%apps_dir%"
if not exist %dependencies% (
	popd
	goto end
)
cd Dependencies
cd Downloads
:: for %%i in (64,86) do (
for %%i in (64) do (
	set edge_bit=%%i
	set setup_file=MicrosoftEdge_X!edge_bit!_%version%.exe
	if not exist !setup_file! (
		wget --continue --timestamping https://api.shuax.com/v2/download/edge/stable/x!edge_bit!
		call :ren x!edge_bit! !setup_file!
	)
)
cd..
cd..
popd
goto end

:download-ngrok
call :require aria2
set ngrok_bit=amd64
if not defined ProgramFiles(x86) set ngrok_bit=386
set ngrok_setup_file=%dependencies_downloads%\ngrok-stable-windows-%ngrok_bit%.zip
pushd "%apps_dir%"
if not exist %ngrok_setup_file% (
	aria2c --check-certificate=false --conditional-get=true --dir=%dependencies_downloads% --max-connection-per-server=16 --remote-time=true %ngrok_base_url%/!ngrok_setup_file:%dependencies_downloads%\=!
) else (
	call :rd ngrok
)
if not exist ngrok call :require ngrok
if not exist ngrok (
	popd
	goto error
)
:download-ngrok_clean
call :del %ngrok_setup_file%
if exist %ngrok_setup_file% goto download-ngrok_clean
popd
goto end

:edge
call :require "Microsoft Edge"
call :sanitize input %1
set unsanitized_input=%1
if defined unsanitized_input call :sanitize input %2
if not defined unsanitized_input set unsanitized_input=%start_page%
if [%unsanitized_input%] == [app] set edge_mode=--new-window --%unsanitized_input%=
if [%unsanitized_input%] == [inprivate] set edge_mode=-%unsanitized_input% 
if not defined input set input=%start_page%
set input= %edge_mode%%input:&=^&%
call :check-process "%edge_exe_path%" "Microsoft Edge">nul 2>&1
if not %process_status% == 0 (
	start "" "%edge_exe_path%" --user-data-dir="%edge_data_dir%"%input:^=%
	goto end
)
call :check-process privoxy.exe Privoxy>nul 2>&1
if not %process_status% == 1 (
	if %is_admin% == 0 cmd /c %this% superproxy
)
call :settings
if %is_admin% == 0 call :rd "%edge_data_dir%"
if defined install_edge_extensions call :chrome-extensions "%edge_data_dir%" "%install_edge_extensions%"
set edge_switches=!edge_switches:--user-data-dir=--user-data-dir="%edge_data_dir%"!
:: if %is_admin% == 0 call :rd "%edge_dictionaries_dir%"
set edge_clean_appdata=echo.
if %is_admin% == 1 set edge_clean_appdata=rd "%local_edge_dir%" /q /s
:: call :disable-chrome-history "%edge_profile_dir%"
set edge_command=%this% disable-chrome-history "%edge_profile_dir%"
:: if %is_admin% == 0 set edge_command=rd "%edge_dictionaries_dir%" "%edge_data_dir%" /q /s ampersand rd "%edge_dir%"
if exist "%local_edge_exe_path%" goto edge_default
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & ren "%local_edge_dir%" Edge_Backup & "%edge_exe_path%"%edge_switches%%input% & %edge_command:ampersand=&% & rd "%local_edge_dir%" /q /s & ren "%local_edge_dir%_Backup" Edge & %edge_clean_appdata% & reg delete %hkcu_software_edge% /f & reg delete %hkcu_software_edgeupdate% /f & %this% clear-recent-items & %this% speak "Edge was closed"">nul 2>&1
goto end
:edge_default
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%edge_exe_path%"%edge_switches%%input% & %edge_command:ampersand=&% & %this% clear-recent-items & %this% speak "Edge was closed"">nul 2>&1
goto end

:error
echo Sorry, something went wrong.
goto end

:escape
set variable=%1
set value=%2
set %variable%=%value%
if not defined %variable% goto end
set new_value=%value:&=escape_ampersand%
set %variable%=%new_value%
goto end

:filezilla
call :require FileZilla
call :check-process %filezilla_exe% FileZilla
if not %process_status% == 0 goto end
set ORIGINAL_HOME=%HOME%
set HOME=%~d0\%projects%
if "%home_dir:"=%" == "%~d0\" set HOME=%home_dir%%projects%
if exist "%local_filezilla%" goto filezilla_default
if exist "%local_filezilla_x86%" goto filezilla_default
if %is_admin% == 0 call :rd "%filezilla_config_location%"
set filezilla_command=echo.
:: if %is_admin% == 0 set filezilla_command=rd "%filezilla_config_location%" /q /s
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%filezilla_exe_path%" & %filezilla_command% & %this% speak "FileZilla was closed"">nul 2>&1
set HOME=%ORIGINAL_HOME%
goto end
:filezilla_default
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%filezilla_exe_path%" & %this% speak "FileZilla was closed"">nul 2>&1
set HOME=%ORIGINAL_HOME%
goto end

:firefox
call :require "Mozilla Firefox"
:: call :require Notepad++
call :sanitize input %1
if [%1] == [private] set firefox_mode=-private-window 
if defined firefox_mode call :sanitize input %2
if not defined input set input=%start_page%
set input= %firefox_mode%%input:&=^&%
call :check-process "%firefox_exe_path%" "Mozilla Firefox">nul 2>&1
if not %process_status% == 0 (
	start "" "%firefox_exe_path%"%input:^=% -profile "%firefox_data_dir%"
	goto end
)
call :check-process privoxy.exe Privoxy>nul 2>&1
if not %process_status% == 1 (
	if %is_admin% == 0 cmd /c %this% superproxy
)
call :settings
if %is_admin% == 0 call :rd "%firefox_data_dir%"
if not exist "%firefox_distribution_dir%" call :md "%firefox_distribution_dir%"
echo {>%firefox_policies%
echo   "policies": {>>%firefox_policies%
:: echo     "BlockAboutAddons": true,>>%firefox_policies%
:: echo     "BlockAboutConfig": true,>>%firefox_policies%
:: echo     "BlockAboutProfiles": true,>>%firefox_policies%
:: echo     "BlockAboutSupport": true,>>%firefox_policies%
echo     "CaptivePortal": false,>>%firefox_policies%
echo     "DisableSetDesktopBackground": true,>>%firefox_policies%
echo     "DisableMasterPasswordCreation": true,>>%firefox_policies%
echo     "DisableAppUpdate": true,>>%firefox_policies%
echo     "DisableDeveloperTools": true,>>%firefox_policies%
echo     "DisableFeedbackCommands": true,>>%firefox_policies%
echo     "DisableFirefoxScreenshots": true,>>%firefox_policies%
echo     "DisableFirefoxAccounts": true,>>%firefox_policies%
echo     "DisableFirefoxStudies": true,>>%firefox_policies%
echo     "DisableForgetButton": true,>>%firefox_policies%
echo     "DisableFormHistory": true,>>%firefox_policies%
echo     "DisablePasswordReveal": true,>>%firefox_policies%
echo     "DisablePocket": true,>>%firefox_policies%
echo     "DisableProfileImport": true,>>%firefox_policies%
echo     "DisableSystemAddonUpdate": true,>>%firefox_policies%
echo     "DisableTelemetry": true,>>%firefox_policies%
echo     "DisplayMenuBar": "never",>>%firefox_policies%
if defined network_trr_uri (
	echo     "DNSOverHTTPS": {>>%firefox_policies%
	echo       "Enabled": true,>>%firefox_policies%
	echo       "ProviderURL": "%network_trr_uri%",>>%firefox_policies%
	echo       "Locked": true>>%firefox_policies%
	echo     },>>%firefox_policies%
)
echo     "DontCheckDefaultBrowser": true,>>%firefox_policies%
echo     "FirefoxHome": {>>%firefox_policies%
echo       "Search": false,>>%firefox_policies%
echo       "TopSites": false,>>%firefox_policies%
echo       "Highlights": false,>>%firefox_policies%
echo       "Pocket": false,>>%firefox_policies%
echo       "Snippets": false,>>%firefox_policies%
echo       "Locked": true>>%firefox_policies%
echo     },>>%firefox_policies%
echo     "NetworkPrediction": false,>>%firefox_policies%
echo     "NewTabPage": false,>>%firefox_policies%
echo     "NoDefaultBookmarks": true,>>%firefox_policies%
echo     "OfferToSaveLogins": false,>>%firefox_policies%
echo     "PasswordManagerEnabled": false,>>%firefox_policies%
echo     "Preferences": {>>%firefox_policies%
echo       "browser.tabs.warnOnClose": false,>>%firefox_policies%
echo       "media.gmp-gmpopenh264.enabled": false,>>%firefox_policies%
echo       "media.gmp-widevinecdm.enabled": false,>>%firefox_policies%
echo       "places.history.enabled": false,>>%firefox_policies%
echo       "ui.key.menuAccessKeyFocuses": false>>%firefox_policies%
echo     },>>%firefox_policies%
echo     "Proxy": {>>%firefox_policies%
call :check-process privoxy.exe Privoxy>nul 2>&1
if not %process_status% == 0 (
	echo       "Mode": "manual",>>%firefox_policies%
	echo       "Locked": false,>>%firefox_policies%
	echo       "HTTPProxy": "%hostname%:%privoxy_port%",>>%firefox_policies%
	echo       "SSLProxy": "%hostname%:%firefox_ssl_port%">>%firefox_policies%

)
echo     },>>%firefox_policies%
echo     "SanitizeOnShutdown": {>>%firefox_policies%
echo       "Cache": false,>>%firefox_policies%
echo       "Cookies": false,>>%firefox_policies%
echo       "Downloads": true,>>%firefox_policies%
echo       "FormData": true,>>%firefox_policies%
echo       "History": true,>>%firefox_policies%
echo       "Sessions": true,>>%firefox_policies%
echo       "SiteSettings": true,>>%firefox_policies%
echo       "OfflineApps": true,>>%firefox_policies%
echo       "Locked": true>>%firefox_policies%
echo     },>>%firefox_policies%
echo     "SearchSuggestEnabled": false,>>%firefox_policies%
echo     "UserMessaging": {>>%firefox_policies%
echo       "WhatsNew": false,>>%firefox_policies%
echo       "ExtensionRecommendations": false,>>%firefox_policies%
echo       "FeatureRecommendations": false,>>%firefox_policies%
echo       "UrlbarInterventions": false>>%firefox_policies%
echo     }>>%firefox_policies%
echo   }>>%firefox_policies%
echo }>>%firefox_policies%
if not exist "%firefox_data_dir%" call :md "%firefox_data_dir%"
echo user_pref("app.normandy.enabled", false);>>%firefox_preferences%
echo user_pref("browser.cache.disk.capacity", 0);>>%firefox_preferences%
echo user_pref("browser.contentblocking.category", "strict");>>%firefox_preferences%
echo user_pref("browser.newtabpage.activity-stream.asrouter.providers.onboarding", "");>>%firefox_preferences%
:: echo user_pref("browser.newtabpage.activity-stream.migrationExpired", true);>>%firefox_preferences%
echo user_pref("browser.sessionstore.max_tabs_undo", 0);>>%firefox_preferences%
echo user_pref("browser.startup.homepage_override.mstone", "ignore");>>%firefox_preferences%
echo user_pref("browser.tabs.remote.autostart", false);>>%firefox_preferences%
echo user_pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"customizableui-special-spring1\",\"urlbar-container\",\"customizableui-special-spring2\",\"downloads-button\",\"library-button\",\"sidebar-button\",\"fxa-toolbar-menu-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"ublock0_raymondhill_net-browser-action\"],\"dirtyAreaCache\":[\"nav-bar\"],\"currentVersion\":16,\"newElementCount\":2}");>>%firefox_preferences%
echo user_pref("dom.webnotifications.enabled", false);>>%firefox_preferences%
echo user_pref("extensions.autoDisableScopes", 0);>>%firefox_preferences%
echo user_pref("extensions.activeThemeID", "firefox-compact-light@mozilla.org");>>%firefox_preferences%
echo user_pref("geo.enabled", false);>>%firefox_preferences%
echo user_pref("media.gmp-gmpopenh264.visible", false);>>%firefox_preferences%
echo user_pref("media.gmp-manager.url", "data:text/plain,");>>%firefox_preferences%
echo user_pref("media.gmp-widevinecdm.visible", false);>>%firefox_preferences%
if defined network_security_esni_enabled echo user_pref("network.security.esni.enabled", %network_security_esni_enabled%);>>%firefox_preferences%
if defined network_trr_mode echo user_pref("network.trr.mode", %network_trr_mode%);>>%firefox_preferences%
if defined network_trr_uri echo user_pref("network.trr.uri", "%network_trr_uri%");>>%firefox_preferences%
echo user_pref("privacy.donottrackheader.enabled", true);>>%firefox_preferences%
echo user_pref("privacy.firstparty.isolate", true);>>%firefox_preferences%
echo user_pref("reader.parse-on-load.enabled", false);>>%firefox_preferences%
echo user_pref("toolkit.cosmeticAnimations.enabled", false);>>%firefox_preferences%
:: echo user_pref("view_source.editor.external", true);>>%firefox_preferences%
:: echo user_pref("view_source.editor.path", "%notepad_exe_path:\=\\%");>>%firefox_preferences%
call :firefox-extensions clean
if defined install_firefox_extensions call :firefox-extensions "%install_firefox_extensions%"
set firefox_clean_appdata=echo.
if %is_admin% == 1 set firefox_clean_appdata=rd "%localappdata_mozilla%" "%locallow_mozilla%" "%appdata_mozilla%" "%programdata_mozilla%" /q /s
set firefox_command=echo.
:: if %is_admin% == 0 set firefox_command=rd "%firefox_data_dir%" /q /s
if exist "%local_firefox%" goto firefox_default
if exist "%local_firefox_x86%" goto firefox_default
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & ren "%localappdata_mozilla%" Mozilla_Backup & ren "%locallow_mozilla%" Mozilla_Backup & ren "%appdata_mozilla%" Mozilla_Backup & ren "%programdata_mozilla%" Mozilla_Backup & "%firefox_exe_path%"%input% -profile "%firefox_data_dir%" & %this_backup% wait "%firefox_exe_path%" & rd "%firefox_distribution_dir%" /q /s & rd "%localappdata_mozilla%" /q /s & ren "%localappdata_mozilla%_Backup" Mozilla & rd "%locallow_mozilla%" /q /s & ren "%locallow_mozilla%_Backup" Mozilla & rd "%appdata_mozilla%" /q /s & ren "%appdata_mozilla%_Backup" Mozilla & rd "%programdata_mozilla%" /q /s & ren "%programdata_mozilla%_Backup" Mozilla & %firefox_clean_appdata% & %firefox_command% & %this% firefox-extensions clean & reg delete %hkcu_software_mozilla% /f & %this% clear-recent-items & %this% speak "Firefox was closed"">nul 2>&1
goto end
:firefox_default
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%firefox_exe_path%"%input% -profile "%firefox_data_dir%" & %this_backup% wait "%firefox_exe_path%" & %firefox_command% & %this% clear-recent-items & %this% speak "Firefox was closed"">nul 2>&1
goto end

:firefox-extensions
set installed_extensions=%1
if not defined installed_extensions goto end
set installed_extensions=%installed_extensions:"=%
call :md "%firefox_extensions_dir%"
if /i "%installed_extensions%" == "clean" (
	call :rd "%firefox_extensions_dir%"
	goto end
)
pushd "%firefox_extensions_dir%"
for %%i in (%installed_extensions%) do (
	for /f "tokens=1* delims=/" %%x in ("%%i") do (
		robocopy "%apps_dir%\%dependencies_downloads%" . %%x.xpi>nul 2>&1
		call :ren %%x.xpi %%y.xpi
	)
)
popd
goto end

:fluidsynth
call :require FluidSynth
call :require SoundFonts
call :sanitize input %1
if defined input set input= %input:&=^&%
start "%0" cmd /c "color %cmd_color% & nircmd win center title %0 & title FluidSynth -%input% & echo. & fluidsynth%fluidsynth_options% %soundfont%%input% & %this% speak "FluidSynth was closed""
goto end

:flux
call :require f.lux
pushd "%apps_dir%"
call :kill %flux_exe%
if exist "%local_flux_exe_path%" goto flux_default
reg delete "%flux_michael_herf%" /f>nul 2>&1
reg add "%flux_preferences%" /v alarm /t REG_DWORD /d 0 /f>nul 2>&1
reg add "%flux_preferences%" /v data /t REG_DWORD /d 0 /f>nul 2>&1
reg add "%flux_preferences%" /v DisableUpdate /t REG_DWORD /d 1 /f>nul 2>&1
reg add "%flux_preferences%" /v fullscreendisable /t REG_DWORD /d 1 /f>nul 2>&1
reg add "%flux_preferences%" /v Latitude /t REG_DWORD /d 1101 /f>nul 2>&1
reg add "%flux_preferences%" /v Longitude /t REG_DWORD /d 12440 /f>nul 2>&1
reg add "%flux_preferences%" /v SlowFade /t REG_DWORD /d 0 /f>nul 2>&1
reg add "%flux_preferences%" /v SoftwareMouse /t REG_DWORD /d 1 /f>nul 2>&1
reg add "%flux_preferences%" /v veryfast /t REG_DWORD /d 1 /f>nul 2>&1
reg add "%flux_preferences%" /v waketime /t REG_DWORD /d 360 /f>nul 2>&1
:flux_default
if not exist Flux (
	popd
	goto end
)
cd Flux
cd App
start %flux_exe% /noshow
cd..
cd..
popd
if [%1] == [stop] goto flux-stop
goto end

:flux-stop
call :check-process %flux_exe% f.lux>nul 2>&1
if not %process_status% == 0 (
	call :kill %flux_exe%
	goto flux-stop
)
if exist "%local_flux_exe_path%" goto end
call :rd "%localappdata_flux%"
reg delete "%flux_michael_herf%" /f>nul 2>&1
goto end

:folders
call :md %desktop%
call :md %documents%
call :md %downloads%
call :md %music%
call :md %pictures%
call :md %projects%
call :md %videos%
goto end

:foobar2000
call :require foobar2000
call :check-process "%foobar2000_exe_path%" foobar2000
if not %process_status% == 0 (
	start "" "%foobar2000_exe_path%"
	goto end
)
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%foobar2000_exe_path%" & %this% speak "foobar2000 was closed"">nul 2>&1
goto end

:gimp
call :require GIMP
call :sanitize input %1
if defined input set input= %input:&=^&%
call :check-process "%gimp_exe_path%" GIMP
if not %process_status% == 0 (
	if defined input set input=%input:^=%
	start "" "%gimp_exe_path%"!input!
	goto end
)
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & robocopy "%gimp_data_dir%\Local\babl-0.1" "%localappdata_babl%" /e & robocopy "%gimp_data_dir%\Local\gegl-0.4" "%localappdata_gegl%" /e & robocopy "%gimp_data_dir%\Local\GIMP" "%localappdata_gimp%" /e & robocopy "%gimp_data_dir%\Local\gtk-2.0" "%localappdata_gtk%" /e & "%gimp_exe_path%"%input% & robocopy "%localappdata_babl%" "%gimp_data_dir%\Local\babl-0.1" /e /move /purge & robocopy "%localappdata_gegl%" "%gimp_data_dir%\Local\gegl-0.4" /e /move /purge & robocopy "%localappdata_gimp%" "%gimp_data_dir%\Local\GIMP" /e /move /purge & robocopy "%localappdata_gtk%" "%gimp_data_dir%\Local\gtk-2.0" /e /move /purge & robocopy "%LOCALAPPDATA%" "%gimp_data_dir%\Local" recently-used.xbel /mov & %this% speak "GIMP was closed"">nul 2>&1
goto end

:google
call :corporate-app %0 %1 %2 %3
goto end

:imgburn
call :require ImgBurn
call :sanitize input %1
if defined input set input= %input:&=^&%
call :check-process %imgburn_exe% ImgBurn
if not %process_status% == 0 goto end
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & type nul>"%imgburn_settings%" & "%imgburn_exe_path%"%input% /PORTABLE /SETTINGS "%imgburn_settings%" & rd "%imgburn_log_files_dir%" /q /s & %this% speak "ImgBurn was closed"">nul 2>&1
goto end

:install
set first=%0
set first=%first::=%
set second=%1
if defined second set second= %second%
call :setup %first%%second%
goto end

:install-and-create-shortcut
set shortcuts_location=%1
set shortcut_name=%2
set app_name=%2
set app_name=%app_name:"=%
if not "%app_name:LibreOffice =%" == "%app_name%" set app_name=LibreOffice
if not "%app_name: =%" == "%app_name%" set app_name="%app_name%"
if not exist "%shortcuts_location:"=%\%shortcut_name:"=%.lnk" (
 	call :require %app_name%
 	call :shortcut %1 %2 %3 %4
)
if not exist "%shortcuts_location:"=%\%shortcut_name:"=%.lnk" call :shortcut %1 %2 %3 %4
goto end

:kill
set process=%1
if not defined process goto end
set process="%process:"=%"
taskkill /f /im %process% /t>nul 2>&1
goto end

:kodi
call :require "Microsoft Visual C++ 2015-2019 Redistributable"
call :require Kodi
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%kodi_exe_path%" -p & %this% speak "Kodi was closed""
goto end

:laragon
call :require Laragon
call :check-process %laragon_exe% Laragon
if not %process_status% == 0 goto end
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%laragon_exe_path%" & %this% speak "Laragon was closed"">nul 2>&1
goto end

:libreoffice
set app_label=%0
set app_label=%app_label::=%
call :require LibreOffice
call :sanitize input %1
if not [%1] == [] (
	set first=%1
	if "!first:~0,2!" == "--" set first=!first:--=!
	if [!first!] == [reset] goto libreoffice_reset
	for %%i in (calc, impress, writer) do (
		if /i [%%i] == [!first!] (
			set app_mode=--!first!
			call :sanitize input %2
		)
	)
)
if defined input set input= %input:&=^&%
if defined app_mode set input= %app_mode%%input%
call :check-process "%libreoffice_exe_path%" LibreOffice
if not %process_status% == 0 (
	if defined input set input=%input:^=%
	start "" "%libreoffice_exe_path%"!input!
	goto end
)
if %is_admin% == 0 (
	robocopy "%libreoffice_default_settings_dir%" "%libreoffice_settings_dir%" /mir>nul 2>&1
	echo ^<?xml version="1.0" encoding="UTF-8"?^>>%libreoffice_settings%
	echo ^<oor:items xmlns:oor="http://openoffice.org/2001/registry" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"^>>>%libreoffice_settings%
	echo ^<item oor:path="%libreoffice_view%"^>^<prop oor:name="NotebookbarIconSize" oor:op="fuse"^>^<value^>1^</value^>^</prop^>^</item^>>>%libreoffice_settings%
	echo ^<item oor:path="%libreoffice_view%"^>^<prop oor:name="ShowTipOfTheDay" oor:op="fuse"^>^<value^>false^</value^>^</prop^>^</item^>>>%libreoffice_settings%
	echo ^<item oor:path="%libreoffice_view%"^>^<prop oor:name="SidebarIconSize" oor:op="fuse"^>^<value^>1^</value^>^</prop^>^</item^>>>%libreoffice_settings%
	echo ^<item oor:path="%libreoffice_view%"^>^<prop oor:name="SymbolSet" oor:op="fuse"^>^<value^>0^</value^>^</prop^>^</item^>>>%libreoffice_settings%
	echo ^<item oor:path="%libreoffice_view%"^>^<prop oor:name="SymbolStyle" oor:op="fuse"^>^<value^>auto^</value^>^</prop^>^</item^>>>%libreoffice_settings%
	echo ^<item oor:path="%libreoffice_toolbar_mode%"^>^<prop oor:name="ActiveCalc" oor:op="fuse"^>^<value^>notebookbar_compact.ui^</value^>^</prop^>^</item^>>>%libreoffice_settings%
	echo ^<item oor:path="%libreoffice_toolbar_mode%"^>^<prop oor:name="ActiveImpress" oor:op="fuse"^>^<value^>notebookbar_compact.ui^</value^>^</prop^>^</item^>>>%libreoffice_settings%
	echo ^<item oor:path="%libreoffice_toolbar_mode%"^>^<prop oor:name="ActiveWriter" oor:op="fuse"^>^<value^>notebookbar_compact.ui^</value^>^</prop^>^</item^>>>%libreoffice_settings%
	echo ^<item oor:path="%libreoffice_toolbar_mode%/Applications%libreoffice_toolbar_mode%:Application['Calc']"^>^<prop oor:name="Active" oor:op="fuse"^>^<value^>notebookbar_compact.ui^</value^>^</prop^>^</item^>>>%libreoffice_settings%
	echo ^<item oor:path="%libreoffice_toolbar_mode%/Applications%libreoffice_toolbar_mode%:Application['Impress']"^>^<prop oor:name="Active" oor:op="fuse"^>^<value^>notebookbar_compact.ui^</value^>^</prop^>^</item^>>>%libreoffice_settings%
	echo ^<item oor:path="%libreoffice_toolbar_mode%/Applications%libreoffice_toolbar_mode%:Application['Writer']"^>^<prop oor:name="Active" oor:op="fuse"^>^<value^>notebookbar_compact.ui^</value^>^</prop^>^</item^>>>%libreoffice_settings%
	echo ^<item oor:path="%libreoffice_update_check%"^>^<prop oor:name="AutoCheckEnabled" oor:op="fuse" oor:type="xs:boolean"^>^<value^>false^</value^>^</prop^>^</item^>>>%libreoffice_settings%
	echo ^<item oor:path="%libreoffice_setup_product%"^>^<prop oor:name="ooSetupLastVersion" oor:op="fuse"^>^<value^>%libreoffice_last_version%^</value^>^</prop^>^</item^>>>%libreoffice_settings%
	echo ^</oor:items^>>>%libreoffice_settings%
)
if not exist "%libreoffice_program_dir%" goto end
pushd "%libreoffice_program_dir%"
if not exist intro_original.png call :ren intro.png intro_original.png
if not exist intro.png call :ren intro_backup.png intro.png
if not exist intro_backup.png call :ren intro.png intro_backup.png
if not exist intro.png call :ren intro_original.png intro.png
popd
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%libreoffice_exe_path%"%input% & %this% %app_label% reset & %this% speak "LibreOffice was closed"">nul 2>&1
goto end
:libreoffice_reset
if %is_admin% == 0 robocopy "%libreoffice_default_settings_dir%" "%libreoffice_settings_dir%" /mir 
pushd "%libreoffice_program_dir%"
if not exist intro_original.png call :ren intro.png intro_original.png
if not exist intro.png call :ren intro_backup.png intro.png
popd
goto end

:lockfile
set app_label=%1
if not defined app_label goto end
set app_label=%app_label::=%
set lock_file="%apps_dir%\%app_label%.lock"
set lock_status=1
if not exist %lock_file% (
	set lock_status=0
	type nul>%lock_file%
)
if [%2] == [unlock] call :del %lock_file%
goto end

:main
if not defined cmd_color set cmd_color=07
set color=color %cmd_color%
pushd "%apps_dir%"
if not exist NirCmd cmd /c %scripts%\NirCmd_Setup install>nul 2>&1
popd
call :escape a %0
call :escape b %1
call :escape c %2
call :escape d %3
call :escape e %4
call :escape f %5
if not defined b set b=terminal
if [%b%] == [terminal] (
	set c=Terminal
	call :escape d %2
	if not defined d set d=%cmd_color%
)
if defined d (
	set remote_sync=%d:"=%
	if /i "!remote_sync!" == "remote-sync" set c=Server_+_Remote_sync
	set d= %d%
)
if defined e set e= %e%
if defined f set f= %f%
set admin="%apps_dir%\NirCmd\App\nircmd.exe" elevate cmd /c
set opening=Opening %c:_= %...
set title=%c:_= %
set center="%apps_dir%\NirCmd\App\nircmd.exe" win center ititle "%opening%"
set disable="%apps_dir%\NirCmd\App\nircmd.exe" win disable ititle "%opening%"
set hide="%apps_dir%\NirCmd\App\nircmd.exe" win hide ititle "%opening%"
set max="%apps_dir%\NirCmd\App\nircmd.exe" win max ititle "%opening%"
:: set setsize="%apps_dir%\NirCmd\App\nircmd.exe" win setsize title "%opening%" 26, 26, 993, 519
if [%b%] == [admin-center] %admin% "%color% & title %opening% & %center% & echo. & %a% wrapper %c%%d%%e%%f%" & exit
if [%b%] == [admin-max] %admin% "%color% & title %opening% & %center% & %max% & echo. & %a% wrapper %c%%d%%e%%f%" & exit
if [%b%] == [admin-run] %admin% "%color% & title %opening% & %center% & %disable% & echo. & %hide% & %a%%d%%e%%f%" & exit
if [%b%] == [center] start "%opening%" cmd /c "%color% & %center% & echo. & %a% wrapper %c%%d%%e%%f%" & exit
if [%b%] == [max] start "%opening%" /max cmd /c "%color% & echo. & %a% wrapper %c%%d%%e%%f%" & exit
if [%b%] == [run] start "%opening%" cmd /c "%color% & %center% & %disable% & echo. & %hide% & %a%%d%%e%%f%" & exit
if [%b%] == [terminal] start "%opening%" cmd /c "%color% & %center% & echo. & %a% wrapper %c% %b%%d%" & exit
call :settings
for /f "tokens=*" %%x in (%settings_ini%) do (
	set line=%%x
	if not "!line:~0,1!" == "[" (
		if not "!line:~0,1!" == ";" set !line!
	)
)
set ccleaner_exe=!ccleaner_exe:.exe=%ccleaner%.exe!
set ccleaner_exe_path=!ccleaner_exe_path:.exe=%ccleaner%.exe!
for %%c in (Downloads\%chrome%-bit\*_chrome_installer.exe) do set chrome_installer=%%~nc
for %%c in (Downloads\*_chrome_installer.exe) do set chrome_installer=%%~nc
for /f "tokens=1* delims=_" %%c in ("%chrome_installer%") do set prodversion=%%c
for %%l in (Downloads\LibreOfficePortable_*_Multilingual*.paf.exe) do set libreoffice_installer=%%~nl
for /f "tokens=2* delims=_" %%l in ("%libreoffice_installer%") do set libreoffice_version=%%l
for /f "tokens=1,2* delims=." %%l in ("%libreoffice_version%") do set libreoffice_last_version=%%l.%%m
for %%e in (Downloads\MicrosoftEdge_*) do set edge_installer=%%~ne
for /f "tokens=3* delims=_" %%e in ("%edge_installer%") do set edge_version=%%e
set edge_app_dir=%edge_app_dir%\%edge_version%
set edge_exe_path=%edge_app_dir%\%edge_exe%
set edge_dictionaries_dir=%edge_app_dir%\Dictionaries
set local_edge_app_dir=%local_edge_dir%\Application\%edge_version%
set local_edge_exe_path=%local_edge_app_dir%\%edge_exe%
for %%v in (Downloads\%vnc_viewer_exe%) do set vnc_viewer_installer=%%~nv
for /f "tokens=3* delims=-" %%v in ("%vnc_viewer_installer%") do set vnc_viewer_version=%%v
set vnc_viewer_bit=64
if not defined ProgramFiles(x86) set vnc_viewer_bit=32
set vnc_viewer_exe=VNC-Viewer-%vnc_viewer_version%-Windows-%vnc_viewer_bit%bit.exe
set vnc_viewer_exe_path=%vnc_viewer_app_dir%\%vnc_viewer_exe%
call :md "%TEMP%"
echo Silence is golden.>"%TEMP%\%self%.tmp"
:: call :windows-update disable>nul 2>&1
:: call :kill MpCmdRun.exe
:: call :kill OneDrive.exe
:: call :kill OneDriveStandaloneUpdater.exe
call :clear-recent-items
if [%b%] == [wrapper] goto start-wrapper
call :lockfile %b%
if not %lock_status% == 0 goto end
call :start %b% %c%%d%%e%%f%
call :lockfile %b% unlock
goto end

:md
if not exist %1 md %1>nul 2>&1
if not exist %1 goto end
goto end

:microsoft
call :corporate-app %0 %1 %2 %3
goto end

:midi-player
call :require "MIDI Player"
call :require SoundFonts
pushd "%apps_dir%"
if not exist MIDI_Player (
	popd
	goto end
)
cd MIDI_Player
cd App
if exist "Sample Playlist.vpl" call :del "Sample Playlist.vpl"
reg add "%hkcu_software_midi_player%\SessionTip" /v ShowTips /t REG_DWORD /d 0
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%midi_player_exe%" & reg delete %hkcu_software_vanbasco% /f & %this% speak "MIDI Player was closed""
cd..
cd..
popd
goto end

:mingit
cmd /c %self% center MinGit terminal "" mingit
goto end

:mozilla
call :corporate-app %0 %1 %2 %3
goto end

:mpv
call :require mpv
call :require youtube-dl
call :sanitize input %1
if defined input set input= %input:&=^&%
set mpv_loop=playlist
call :mpv_config
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%mpv_exe_path%"%input% & %this% speak "mpv was closed""
goto end

:mpv_config
call :require BusyBox
call :md "%mpv_config_dir%"
set pictures_dir=%home_dir%\%pictures%
if "%home_dir:"=%" == "%~d0\" set pictures_dir=%home_dir%%pictures%
for /f "tokens=1* delims=:" %%a in ("%pictures_dir%") do set pictures_dir_without_drive_letter=%%b
if %screen_width% lss 2560 set mpv_width=1280
if %screen_width% lss 1920 set mpv_width=854
if %mpv_width% == 854 set mpv_height=480
if %mpv_width% == 1280 set mpv_height=720
set mpv_autofit=%mpv_width%
set mpv_autofit-larger=%mpv_width%x%mpv_height%
%apps_dir%\BusyBox\App\sed.exe "s/%%mpv_autofit%%/%mpv_autofit:\=\/%/;s/%%mpv_autofit-larger%%/%mpv_autofit-larger:\=\/%/;s/%%mpv_loop%%/%mpv_loop:\=\/%/;s/%%pictures_dir%%/%pictures_dir_without_drive_letter:\=\/%/;s/%%mpv_stream_format%%/%mpv_stream_format%/" "%settings_dir%\mpv\portable_config\mpv.conf">"%mpv_config_dir%\mpv.conf"
goto end

:musescore
call :require MuseScore
call :sanitize input %1
if defined input set input= %input:&=^&%
call :check-process "%musescore_exe_path%" MuseScore
if not %process_status% == 0 (
	if defined input set input=%input:^=%
	start "" "%musescore_exe_path%"!input!
	goto end
)
if not exist "%musescore_data_dir%" call :md "%musescore_data_dir%"
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%musescore_exe_path%" --config-folder "%musescore_data_dir%"%input% & rd "%localappdata_cache%" "%localappdata_musescore%" /q /s & reg delete "%hkcu_software_musescoredotorg%" /f & reg delete "%hkcu_software_qtproject%" /f & %this% speak "MuseScore was closed"">nul 2>&1
goto end

:nano
call :require BusyBox
call :require nano
call :sanitize input %1
if defined input set input= %input:&=^&%
set ORIGINAL_ALLUSERSPROFILE=%ALLUSERSPROFILE%
set ALLUSERSPROFILE=%settings_dir%
for /f "tokens=1* delims=:" %%a in ("%apps_dir%") do set apps_dir_without_drive_letter=%%b
%apps_dir%\BusyBox\App\sed.exe "s/%%apps_dir%%/%apps_dir_without_drive_letter:\=\/%/" "%settings_dir%\nanorc.txt">"%settings_dir%\nanorc"
start "%0" cmd /c "nircmd win center title %0 & title nano & nano%input% & %this% speak "nano was closed""
nircmd win center ititle nano
set ALLUSERSPROFILE=%ORIGINAL_ALLUSERSPROFILE%
goto end

:ngrok
set ngrok_port=
set /p ngrok_port=Port: 
if not defined ngrok_port goto ngrok
start "%0" cmd /c "nircmd win center title %0 & title ngrok - %ngrok_port% & ngrok http %ngrok_port% & %this% speak "ngrok was closed""
goto ngrok

:notepad++
call :require BusyBox
call :require Notepad++
call :sanitize input %1
if defined input set input= %input:&=^&%
call :check-process "%notepad_exe_path%" Notepad++>nul 2>&1
if not %process_status% == 0 (
	if defined input set input=%input:^=%
	start "" "%notepad_exe_path%"!input!
	goto end
)
if exist "%local_notepad%" goto notepad++_default
if exist "%local_notepad_x86%" goto notepad++_default
%apps_dir%\BusyBox\App\sed.exe -i "s/isMaximized=\"no\"/isMaximized=\"yes\"/;s/Wrap=\"no\"/Wrap=\"yes\"/" "%notepad_app_dir%\config.xml">nul 2>&1
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & ren "%localappdata_notepad%" Notepad++_Backup & "%notepad_exe_path%"%input% & rd "%localappdata_notepad%" /q /s & ren "%localappdata_notepad%_Backup" Notepad++ & %this% speak "Notepad++ was closed"">nul 2>&1
goto end
:notepad++_default
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%notepad_exe_path%"%input% & %this% speak "Notepad++ was closed"">nul 2>&1
goto end

:notes
echo https://www.7-zip.org/
echo https://aria2.github.io/ or https://github.com/aria2/aria2/releases/latest
echo https://www.asio4all.org/
echo https://www.audacityteam.org/
echo https://www.ccleaner.com/ccleaner/download
echo https://tools.shuax.com/chrome/
echo https://chromium.woolyss.com/
echo https://curl.haxx.se/windows/ or https://curl.se/windows/
echo https://sass-lang.com/ or https://github.com/sass/dart-sass/releases/latest
echo https://github.com/filegator/filegator/releases/latest
echo https://filezilla-project.org/download.php
echo https://rarewares.org/lossless.php
echo https://github.com/FluidSynth/fluidsynth/releases or https://github.com/FluidSynth/fluidsynth/releases/latest
echo https://www.foobar2000.org/
echo https://www.foobar2000.org/encoderpack
echo https://www.gimp.org/downloads/
echo https://ftp.gnu.org/gnu/grub/
echo https://www.httrack.com/
echo http://innounp.sourceforge.net/
:: echo https://kodi.tv/download/849
echo https://www.rarewares.org/mp3-lame-bundle.php
echo https://www.libreoffice.org/download/portable-versions/
echo https://downloads.mariadb.org/
echo https://mediaarea.net/en/MediaInfo/Download/Windows
echo https://sourceforge.net/projects/mpv-player-windows/files/stable/
echo https://tools.shuax.com/edge/
echo http://mplayerwin.sourceforge.net/
echo https://www.powerdrumkit.com/download76187.php
:: echo https://musescore.org/
echo https://files.lhmouse.com/nano-win/
echo https://nginx.org/
:: echo https://nodejs.org/
echo https://notepad-plus-plus.org/
call :random opera>nul 2>&1
echo https://download%random_opera%.operacdn.com/pub/opera/desktop/
echo https://download%random_opera%.operacdn.com/pub/opera_gx/
echo https://giorgiotani.github.io/PeaZip/peazip-portable.html or https://github.com/giorgiotani/PeaZip/releases/latest
echo https://windows.php.net/download/
echo https://github.com/git-for-windows/git/releases/latest
echo https://www.privoxy.org/
echo https://sites.google.com/site/qaacpage/cabinet or https://github.com/nu774/qaac/releases/latest
echo https://www.reaper.fm/
echo https://www.imgburn.com/
echo https://www.shotcut.org/download/ or https://github.com/mltframework/shotcut/releases/latest
:: echo https://github.com/telegramdesktop/tdesktop/releases/latest
:: echo https://www.thunderbird.net/
echo https://www.videolan.org/
echo https://code.visualstudio.com/updates
echo https://go.microsoft.com/fwlink/?Linkid=850641
echo https://go.microsoft.com/fwlink/?LinkID=623231
echo https://www.realvnc.com/en/connect/download/viewer/
echo https://eternallybored.org/misc/wget/
echo https://sourceforge.net/projects/xampp/files/XAMPP%20Windows/
echo https://github.com/ytdl-org/youtube-dl/releases/latest
echo https://accounts.google.com/AccountChooser?service=mail^&continue=https://mail.google.com/mail/
echo google_search_link_fix/jid0-XWJxt5VvCXkKzQK99PhZqAn7Xbg@jetpack
echo ublock_origin/uBlock0@raymondhill.net
echo %%artist%%\%%album%%\%%tracknumber%% %%title%% -- %%%%
echo grub-install --boot-directory=_:\boot \\.\PHYSICALDRIVE_
goto end

:open
if [%b%] == [] goto end
set media_player=mpv
set midi_player=fluidsynth
set office_suite=libreoffice
set text_editor=notepad++
set web_browser=firefox
if [%~x1] == [.docx] set default_app=%office_suite%
if [%~x1] == [.kar] set default_app=%midi_player%
if [%~x1] == [.m4a] set default_app=%media_player%
if [%~x1] == [.mid] set default_app=%midi_player%
if [%~x1] == [.mp4] set default_app=%media_player%
if [%~x1] == [.odt] set default_app=%office_suite%
if [%~x1] == [.pptx] set default_app=%office_suite%
if [%~x1] == [.txt] set default_app=%text_editor%
if [%~x1] == [.xlsx] set default_app=%office_suite%
if not defined default_app goto end
call :%default_app% %1
goto end

:opera
call :require Opera
call :sanitize input %1
set unsanitized_input=%1
if defined unsanitized_input call :sanitize input %2
if not defined unsanitized_input set unsanitized_input=%start_page%
if [%unsanitized_input%] == [private] set opera_mode=--%unsanitized_input% 
if not defined input set input=%start_page%
set input= %opera_mode%%input:&=^&%
for /d %%a in ("%opera_app_dir%\*") do (
	set opera_exe_path=%%a\opera.exe
	goto opera-check-process
)
:opera-check-process
call :check-process "%opera_exe_path%" Opera>nul 2>&1
if not %process_status% == 0 (
	start "" "%opera_launcher_exe_path%" --user-data-dir="%opera_data_dir%"%input:^=%
	goto end
)
call :check-process privoxy.exe Privoxy>nul 2>&1
if not %process_status% == 1 (
	if %is_admin% == 0 cmd /c %this% superproxy
)
call :settings
if %is_admin% == 0 call :rd "%opera_data_dir%"
if defined install_opera_extensions call :opera-extensions "%opera_data_dir%" "%install_opera_extensions%"
set opera_switches=!opera_switches:--user-data-dir=--user-data-dir="%opera_data_dir%"!
set opera_command=echo.
:: if %is_admin% == 0 set opera_command=rd "%opera_data_dir%" /q /s
if exist "%local_opera%" goto opera_default
if exist "%local_opera_all%" goto opera_default
if exist "%local_opera_all_x86%" goto opera_default
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%opera_launcher_exe_path%"%opera_switches%%input% & %this_backup% wait "%opera_exe_path%" & rd "%appdata_opera%" /q /s & %opera_command% & reg delete "%hkcu_software_opera_software%" /f & %this% speak "Opera was closed"">nul 2>&1
goto end
:opera_default
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%opera_launcher_exe_path%"%opera_switches%%input% & %this_backup% wait "%opera_exe_path%" & %opera_command% & %this% speak "Opera was closed"">nul 2>&1
goto end

:opera_gx
call :require "Opera GX"
call :sanitize input %1
set unsanitized_input=%1
if defined unsanitized_input call :sanitize input %2
if not defined unsanitized_input set unsanitized_input=%start_page%
if [%unsanitized_input%] == [private] set opera_gx_mode=--%unsanitized_input% 
if not defined input set input=%start_page%
set input= %opera_gx_mode%%input:&=^&%
for /d %%a in ("%opera_gx_app_dir%\*") do (
	set opera_gx_exe_path=%%a\opera.exe
	goto opera_gx-check-process
)
:opera_gx-check-process
call :check-process "%opera_gx_exe_path%" "Opera GX">nul 2>&1
if not %process_status% == 0 (
	start "" "%opera_gx_launcher_exe_path%" --user-data-dir="%opera_gx_data_dir%"%input:^=%
	goto end
)
call :check-process privoxy.exe Privoxy>nul 2>&1
if not %process_status% == 1 (
	if %is_admin% == 0 cmd /c %this% superproxy
)
call :settings
if %is_admin% == 0 call :rd "%opera_gx_data_dir%"
if defined install_opera_gx_extensions call :opera-extensions "%opera_gx_data_dir%" "%install_opera_gx_extensions%"
set opera_gx_switches=!opera_gx_switches:--user-data-dir=--user-data-dir="%opera_gx_data_dir%"!
set opera_gx_command=echo.
:: if %is_admin% == 0 set opera_gx_command=rd "%opera_gx_data_dir%" /q /s
if exist "%local_opera_gx%" goto opera_gx_default
if exist "%local_opera_gx_all%" goto opera_gx_default
if exist "%local_opera_gx_all_x86%" goto opera_gx_default
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%opera_gx_launcher_exe_path%"%opera_gx_switches%%input% & %this_backup% wait "%opera_gx_exe_path%" & rd "%appdata_opera%" /q /s & %opera_gx_command% & reg delete "%hkcu_software_opera_software%" /f & %this% speak "Opera GX was closed"">nul 2>&1
goto end
:opera_gx_default
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%opera_gx_launcher_exe_path%"%opera_gx_switches%%input% & %this_backup% wait "%opera_gx_exe_path%" & %opera_gx_command% & %this% speak "Opera GX was closed"">nul 2>&1
goto end

:opera-extensions
set destination=%1
if not defined destination goto end
set destination=%destination:"=%
set installed_extensions=%2
if not defined installed_extensions goto end
set installed_extensions=%installed_extensions:"=%
set count=
for %%i in (%installed_extensions%) do (
	set /a count+=1
	set extension_path=%destination%\Extensions\%%i
	if not exist !extension_path! 7z x "%apps_dir%\%dependencies_downloads%\%%i.nex" -o!extension_path!>nul 2>&1
	if exist !extension_path! (
		if !count! gtr 1 if defined enabled_extensions set enabled_extensions=!enabled_extensions!,
		set enabled_extensions=!enabled_extensions!!extension_path!
	)
)
if defined enabled_extensions (
	set disable_extensions_except=--disable-extensions-except="%enabled_extensions%"
	set load_extension=--load-extension="%enabled_extensions%"
)
set opera_switches=!opera_switches:--disable-extensions=%disable_extensions_except%!
set opera_switches=!opera_switches:--load-extension=%load_extension%!
set opera_gx_switches=!opera_gx_switches:--disable-extensions=%disable_extensions_except%!
set opera_gx_switches=!opera_gx_switches:--load-extension=%load_extension%!
goto end

:peazip
call :require PeaZip
call :check-process %peazip_exe% PeaZip
if not %process_status% == 0 goto end
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%peazip_exe_path%" & %this% speak "PeaZip was closed"">nul 2>&1
goto end

:permanently-delete
cd /d %home_dir%
set file=%1
if not defined file set /p file=File: 
if not defined file goto permanently-delete
call :escape file "%file:"=%"
set file=%file:escape_ampersand=&%
type nul>%file%
del %file%
goto permanently-delete

:picpick
call :require PicPick
call :sanitize input %1
if defined input set input= %input:&=^&%
call :check-process "%picpick_exe_path%" PicPick
if not %process_status% == 0 (
	if defined input set input=%input:^=%
	start "" "%picpick_exe_path%"!input!
	goto end
)
if exist "%local_picpick%" goto picpick_default
if exist "%local_picpick_x86%" goto picpick_default
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & ren "%appdata_picpick%" PicPick_Backup & ren "%programdata_picpick%" PicPick_Backup & "%picpick_exe_path%"%input% & rd "%appdata_picpick%" "%programdata_picpick%" /q /s & ren "%appdata_picpick%_Backup" PicPick & ren "%programdata_picpick%_Backup" PicPick & %this% speak "PicPick was closed"">nul 2>&1
goto end
:picpick_default
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%picpick_exe_path%"%input% & %this% speak "PicPick was closed"">nul 2>&1
goto end

:ping
set ping_hostname=%1
if not defined ping_hostname goto end
ping -n 1 %ping_hostname% | find /i "Reply from ">nul && (
set ping_status=1
) || (
set ping_status=0
)
goto end

:pngquant
call :require "Microsoft Visual C++ 2015-2019 Redistributable"
call :require pngquant
cd /d %home_dir%
:pngquant_input_file
set input_file=
set /p input_file=PNG image: 
if not defined input_file goto pngquant_input_file
if not exist %input_file% goto pngquant_input_file
call :sanitize input_file "%input_file:"=%"
for %%* in (%input_file%) do (
	set input_dir=%%~dp*
	set output_filename=%%~n*
)
call :escape input_dir "%input_dir%"
call :unescape input_dir %input_dir%
set output_folder="pngquant (8-bit)"
pushd %input_dir%
echo.
call :md %output_folder%>nul 2>&1
if not exist %output_folder% (
	popd
	goto end
)
pngquant --force --verbose 256 "%output_filename%.png"
cd %output_folder%
robocopy ..\ . "%output_filename%-fs8.png" /mov>nul 2>&1
call :del "%output_filename%.png"
call :ren "%output_filename%-fs8.png" "%output_filename%.png"
cd..
rd %output_folder%>nul 2>&1
echo.
popd
goto pngquant

:portablegit
cmd /c %self% center PortableGit terminal "" portablegit
goto end

:power-off
call :disconnect
call :flux-stop
call :server-stop
call :xampp-stop
call :reset
set switch=
if [%1] == [restart] set switch=r
if not defined switch set switch=s
shutdown /%switch% /t 0
goto end

:privoxy
call :require Privoxy
pushd "%apps_dir%"
if not exist Privoxy (
	popd
	goto end
)
cd Privoxy
cd App
call :privoxy_config %privoxy_port%
if not [%1] == [] echo forward / %1>>%privoxy_config%
echo forward 127.*.*.* .>>%privoxy_config%
echo forward 192.168.*.* .>>%privoxy_config%
echo forward localhost .>>%privoxy_config%
if not [%1] == [] (
	echo forward *.googlevideo.com .>>%privoxy_config%
	echo forward *.youtube.com .>>%privoxy_config%
)
echo hostname Windows>>%privoxy_config%
echo keep-alive-timeout 300>>%privoxy_config%
echo { \>>%match-all_action%
echo +add-header{Connection: keep-alive} \>>%match-all_action%
echo +session-cookies-only \>>%match-all_action%
echo +set-image-blocker{blank} \>>%match-all_action%
echo }>>%match-all_action%
echo / # Match all URLs>>%match-all_action%
echo.>>%user_action%
echo { \>>%user_action%
echo +block \>>%user_action%
echo +handle-as-empty-document \>>%user_action%
echo }>>%user_action%
if %is_admin% == 0 for %%i in (%hosts_block%) do echo  .%%i>>%user_action%
start /min privoxy.exe
cd..
cd..
popd
goto end

:privoxy_config
set listen=%1
if not defined listen set listen=8118
if not exist %privoxy_config% goto end
call :ren %privoxy_config% %old_privoxy_config%
for /f "tokens=*" %%x in (%old_privoxy_config%) do (
	set line=%%x
	if not "!line:~0,1!" == "#" (
		set line=!line: # Actions that are applied to all sites and maybe overruled later on.=!
		set line=!line:   # Main actions file=!
		set line=!line:      # User customizations=!
		set line=!line:  = !
		set line=!line:listen-address 127.0.0.1=listen-address !
		if not [%listen%] == [8118] set line=!line:8118=%listen%!
		echo !line!>>%privoxy_config%
	)
)
call :del %old_privoxy_config%
echo connection-sharing ^0>>%privoxy_config%
echo default-server-timeout 60>>%privoxy_config%
goto end

:psiphon
call :require Psiphon
call :disconnect
pushd "%apps_dir%"
if not exist Psiphon (
	popd
	goto end
)
set psiphon_default_settings=reg add %hkcu_software_psiphon3% /v DisableTimeouts /t REG_DWORD /d 1 ampersand reg add %hkcu_software_psiphon3% /v LocalHTTPProxyPort /t REG_DWORD /d %psiphon_port% /f ampersand reg add %hkcu_software_psiphon3% /v LocalSOCKSProxyPort /t REG_DWORD /d 1080 /f ampersand reg add %hkcu_software_psiphon3% /v SkipBrowser /t REG_DWORD /d 1 /f ampersand reg add %hkcu_software_psiphon3% /v SkipProxySettings /t REG_DWORD /d 1 /f ampersand reg add %hkcu_software_psiphon3% /v SSHParentProxySkip /t REG_DWORD /d 1 /f ampersand reg add %hkcu_software_psiphon3% /v UIWindowPlacement /t REG_SZ /d "{\"rcNormalPosition.bottom\":726,\"rcNormalPosition.left\":26,\"rcNormalPosition.right\":806,\"rcNormalPosition.top\":26,\"showCmd\":1}" /f
if not exist "%psiphon_reg%" (
	set psiphon_command_start=%psiphon_default_settings%
) else (
	call :registry "%psiphon_reg%"
	set psiphon_command_start=reg import "%psiphon_reg%"
)
set psiphon_command_end=md "%psiphon_data_dir%" ampersand reg export %hkcu_software_psiphon3% "%psiphon_reg%" /y ampersand %this% registry "%psiphon_reg%"
:: if %is_admin% == 0 (
:: 	set psiphon_command_start=%psiphon_default_settings%
:: 	set psiphon_command_end=rd "%psiphon_data_dir%" /q /s
:: )
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & %psiphon_command_start:ampersand=&% & %psiphon_exe_path% & %psiphon_command_end:ampersand=&% & start /min cmd /c "%this% disconnect" & %this% speak "Psiphon was closed"">nul 2>&1
popd
call :privoxy %hostname%:%psiphon_port%
goto end

:random
set random_type=%1
if not defined random_type goto end
if [%random_opera%] == [opera] goto random_opera
if [%random_type%] == [port] goto random_port
:random_opera
set random_opera_max=4
set /a random_opera=%random% %% %random_opera_max% + 1
if %random_opera% gtr %random_opera_max% goto random_opera
echo %random_opera%
goto end
:random_port
set random_port_max=65535
set /a random_port=%random% %% %random_port_max% + 49152
if %random_port% gtr %random_port_max% goto random_port
echo %random_port%
goto end

:rd
if exist %1 rd %1 /q /s>nul 2>&1
if exist %1 goto end
goto end

:reaper
call :require FFmpeg
call :require REAPER
call :require SoundFonts
call :require VST
call :sanitize input %1
if defined input set input= %input:&=^&%
call :check-process "%reaper_exe_path%" REAPER
if not %process_status% == 0 (
	if defined input set input=%input:^=%
	start "" "%reaper_exe_path%"!input!
	goto end
)
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%reaper_exe_path%"%input% & rd "%reaper_media_dir%" & reg delete %hkcu_software_kdptm% /f & %this% speak "REAPER was closed"">nul 2>&1
goto end

:registry
set temporary_reg=Temporary.reg
type %1>%temporary_reg%
echo Windows Registry Editor Version 5.00>%1
echo.>>%1
for /f "tokens=* delims=" %%x in (%temporary_reg%) do (
	set line=%%x
	set line=!line:"=quot!
	if not "!line!" == "quot" (
		if [!line:~-1!] == [}] set line=!line!quot
			if not "!line!" == "Windows Registry Editor Version 5.00" echo !line:quot=^"!>>%1
	)
)
del %temporary_reg%
goto end

:remote-sync
call :require aria2
call :backup-cmd-and-ini
call :backup-and-compress
pushd "%apps_dir%"
set remote-sync_port=8080
call :server "%USERPROFILE%"
:remote-sync_remote
set remote=
set /p remote=IP address: 
if not defined remote goto remote-sync_remote
if "%remote%" == "::1" set remote=127.0.0.1
if "%remote%" == "localhost" set remote=127.0.0.1
if %remote::=% == %remote% set remote=%remote%:%remote-sync_port%
echo.
call :md %dependencies%
if not exist %dependencies% goto remote-sync_error
cd %dependencies%
call :del %archive%
aria2c --check-certificate=false --conditional-get=true --max-connection-per-server=16 --remote-time=true http://%remote%/%archive%>nul 2>&1
if not exist %archive% (
	cd..
	popd
	goto remote-sync_error
)
7z e %archive% -o..\ %list% -aoa>nul 2>&1
7z e %archive% -o..\%scripts% %setup% -aoa>nul 2>&1
cd..
set count=
for /f %%i in (%list%) do set /a count+=1
set number=
for /f "tokens=*" %%i in (%list%) do (
	set /a number+=1
	set index=!number!
	if !number! leq 9 (
		if %count% leq 99 set index=0!number!
	)
	set remote_file=%%i
	set file=!remote_file:/=\!
	echo  (!index! of %count%^) %CD:\= ^> % ^> !file:\= ^> !
	call :escape remote_file "http://%remote%/!remote_file!"
	if not "!file: =!" == "!file!" set file="!file!"
	aria2c --check-certificate=false --conditional-get=true --max-connection-per-server=16 --out=!file! --remote-time=true !remote_file!>nul 2>&1
)
call :server-stop
start "%0_install" cmd /c "nircmd win min title %0_install & nircmd win hide title %0_install & %setup% install & del %archive% %dependencies%\%archive%"
goto end
:remote-sync_error
call :server-stop
echo Sorry, something went wrong.
goto end

:ren
if not exist %1 goto error
if not exist %2 ren %1 %2>nul 2>&1
goto end

:require
pushd "%apps_dir%"
set app=%1
set app_folder=%app:"=%
if /i "%app_folder%" == "f.lux" set app_folder=%app_folder:f.=F%
:: if /i "%app_folder%" == "FFmpeg" (
:: 	set app=Shotcut
:: 	set app_folder=!app!
:: )
if /i "%app_folder%" == "Free Encoder Pack" set app_folder=foobar2000\App\encoders
if /i "%app_folder%" == "Google Chrome" set app_folder=%app_folder: =\App\%
if /i "%app_folder%" == "LibreOffice" set app_folder=%app_folder%Portable
if /i "%app_folder%" == "MariaDB" set app_folder=Server\App\%app_folder%
if /i "%app_folder%" == "Microsoft Edge" set app_folder=%app_folder:Microsoft =%
if /i "%app_folder%" == "Microsoft Visual C++ 2015-2019 Redistributable" set app_folder=CommonFiles\%app_folder%
if /i "%app_folder%" == "Mozilla Firefox" set app_folder=%app_folder:Mozilla =%
if /i "%app_folder%" == "Mozilla Thunderbird" set app_folder=%app_folder:Mozilla =%
if /i "%app_folder%" == "Nginx" set app_folder=Server\App\%app_folder%
if /i "%app_folder%" == "Opera GX" set app_folder=%app_folder: =_%
if /i "%app_folder%" == "PHP" set app_folder=Server\App\%app_folder%
if /i "%app_folder%" == "SoundFonts" set app_folder=CommonFiles\%app_folder%
if /i "%app_folder%" == "Visual Studio Code" set app_folder=%app_folder:Visual Studio =VS%
if /i "%app_folder%" == "VLC media player" set app_folder=%app_folder: media player=%
if /i "%app_folder%" == "VNC Viewer" set app_folder=%app_folder: =_%
if "%app_folder:CommonFiles\=%" == "%app_folder%" (
	if "%app_folder:\App=%" == "%app_folder%" set app_folder=%app_folder%\App
)
if not "%app_folder: =%" == "%app_folder%" set app_folder="%app_folder%"
rd %app_folder%>nul 2>&1
if not exist %app_folder% (
	set app_name=%app%
	set app_name=!app_name:"=!
	set app_name=!app_name: =_!
	cmd /c %scripts%\!app_name: =_!_Setup install>nul 2>&1
)
if /i "%app:"=%" == "Soundfonts" (
	for /f "delims=" %%s in ("%soundfont%") do call :sanitize soundfont "%%~dps%%~nxs"
)
popd
goto end

:reset
reg delete "%hkcu_software%\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU" /f>nul 2>&1
reg delete "%hkcu_software%\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /f>nul 2>&1
reg delete %hkcu_software%\Microsoft\Windows\CurrentVersion\Explorer\Modules\GlobalSettings\Sizer /f>nul 2>&1
if /i not "%1" == "all" goto reset-end
reg delete %hkcu_software%\Microsoft\Windows\Shell\BagMRU /f>nul 2>&1
reg delete %hkcu_software%\Microsoft\Windows\Shell\Bags /f>nul 2>&1
:reset-end
call :kill explorer.exe
start explorer.exe
goto end

:restart
call :power-off restart
goto end

:restore
call :backup-and-restore restore
goto end

:sanitize
set variable=%1
set value=%2
set %variable%=%value%
if not defined %variable% goto end
set new_value=%value:&=escape_ampersand%
set new_value=%new_value:(=open_parenthesis%
set new_value=%new_value:)=close_parenthesis%
set new_value=%new_value:"=%
set current_directory=%CD:&=escape_ampersand%
if [%current_directory:~-1%] == [\] set current_directory=%current_directory:~0,-1%
if "%new_value%" == "." set new_value=%current_directory%
if "%new_value::=%" == "%new_value%" set new_value=%current_directory%\%new_value%
if [%new_value:~-1%] == [:] set new_value=%new_value::=:\%
if [%new_value:~-2%] == [:\] goto sanitize_end
if not "%new_value:/=%" == "%new_value%" (
	set new_value="%new_value%"
	goto sanitize_end
)
if not "%new_value: =%" == "%new_value%" set new_value="%new_value%"
:sanitize_end
set new_value=%new_value:open_parenthesis=(%
set new_value=%new_value:close_parenthesis=)%
set %variable%=%new_value:escape_ampersand=&%
goto end

:sass
call :require Sass
call :lockfile %0 unlock
cd /d %home_dir%
:sass_location
set location=
set /p location=Location: 
if not defined location goto sass_location
call :sanitize location "%location:"=%"
if not exist %location% goto sass_location
pushd %location%
cd..
:: start "%0" /d %cd% cmd /c "nircmd win center title %0 & title %location% - Sass & echo. & echo Sass & echo. & echo Source SASS files  : %location% & echo Compiled CSS files : %cd%\css & echo. & sass --watch scss:css --no-source-map"
start "%0" /d %cd% cmd /c "nircmd win center title %0 & title %location% - Sass & echo. & echo Sass & echo. & echo Source SASS files  : %location% & echo Compiled CSS files : %cd%\css & echo. & sass --watch scss\app.scss:css\app.css --no-source-map"
start "%0" /d %cd% cmd /c "nircmd win center title %0 & title %location% - Sass & echo. & echo Sass & echo. & echo Source SASS files  : %location% & echo Compiled CSS files : %cd%\css & echo. & sass --watch scss\admin.scss:css\admin.min.css scss\app.scss:css\app.min.css scss\custom.scss:css\custom.min.css scss\main.scss:css\main.min.css --no-source-map --style compressed"
popd
goto sass_location

:server
call :check-process httpd.exe Apache>nul 2>&1
if not %process_status% == 0 goto end
if [%2] == [start-php] (
	pushd "%apps_dir%"
	cd Server
	pushd Data
	goto server_php
)
if [%1] == [stop] (
	nircmd win close title "Server - Super"
	call :speak "Server was closed"
	goto server-stop
)
call :server-stop
call :require BusyBox
call :require "Microsoft Visual C++ 2015-2019 Redistributable"
call :require Server
pushd "%apps_dir%"
if not exist Server\App\Nginx\conf goto server_end
cd Server
call :md Data
if not exist Data (
	cd..
	goto server_end
)
pushd Data
pushd ..\App\Nginx
for /f "tokens=1* delims=:" %%a in ("%apps_dir%") do set apps_dir_without_drive_letter=%%b
set projects_dir=%home_dir%\%projects%
if "%home_dir:"=%" == "%~d0\" set projects_dir=%home_dir%%projects%
for /f "tokens=1* delims=:" %%a in ("%projects_dir%") do set projects_dir_without_drive_letter=%%b
%apps_dir%\BusyBox\App\sed.exe "s/%%apps_dir%%/%apps_dir_without_drive_letter:\=\/%/;s/%%html%%/%apps_dir_without_drive_letter:\=\/%\/%html%/;s/%%html_apps%%/%apps_dir_without_drive_letter:\=\/%\/%html_apps:\=\/%/;s/%%projects_dir%%/%projects_dir_without_drive_letter:\=\/%/" "%settings_dir%\nginx\conf\nginx.conf">conf\nginx.conf
set server_title=%0-nginx
start "%server_title%" cmd /c "nircmd win center title %server_title% & nircmd win min title %server_title% & nircmd win hide title %server_title% & nircmd win activate stitle "Server - Super" & nginx -c "%CD:\=/%/conf/nginx.conf""
popd
:: if %is_admin% == 0 goto server_php
:: if not exist MariaDB mysql_install_db --datadir="%CD%\MariaDB">nul 2>&1
:: set server_title=%0-mariadb
:: start "%server_title%" cmd /c "nircmd win center title %server_title% & nircmd win min title %server_title% & nircmd win hide title %server_title% & nircmd win activate stitle "Server - Super" & mysqld --defaults-file="%CD%\MariaDB\my.ini" --standalone"
:server_php
if not exist "%apps_dir%\%html_apps%\filegator" (
	popd
	goto server_end
)
cd /d %home_dir%
set location=%1
if not defined location set /p location=Location: 
if not defined location set location=%USERPROFILE%
call :sanitize location "%location:"=%"
if not exist %location% goto server_php
call :server-filegator %location%
popd
cd Data
call :md PHP
%apps_dir%\BusyBox\App\sed.exe "s/max_execution_time = 30/max_execution_time = 120/;s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/;s/;extension=mysqli/extension=mysqli/;s/;extension_dir = \"ext\"/extension_dir = \"%apps_dir:\=\\%\\Server\\App\\PHP\\ext\"/;s/;extension=openssl/extension=openssl/" ..\App\PHP\php.ini-development>PHP\php.ini
set server_title=%0-php
start "%server_title%" cmd /c "nircmd win center title %server_title% & nircmd win min title %server_title% & nircmd win hide title %server_title% & nircmd win activate stitle "Server - Super" & php-cgi -b 127.0.0.1:9000 -c "%CD%\PHP\php.ini" & %this% server %location% start-php"
cd..
if [%1] == [] (
	pushd Data
	goto server_php
)
:server_end
popd
goto end

:server-filegator
set repository=%1
if not defined repository goto end
set repository=%repository:"=%
if "%repository:~-2%" == ":\" set repository=%repository:~0,-1%
if "%repository:~-1%" == ":" set repository=%repository%\Media
if "%repository%" == "%USERPROFILE%" set repository=%repository%\Media
pushd "%apps_dir%"
if not exist %html_apps%\filegator goto end
cd %html_apps%\filegator
%apps_dir%\BusyBox\App\sed.exe "s/https:\/\/filegator.io/dist/;s/100 \* 1024 \* 1024, \/\/ 100/4096 \* 1024 \* 1024, \/\/ 4096/;s/__DIR__.'\/private\/tmp\/'/'%TEMP:\=\\%'/;s/__DIR__.'\/repository'/'%repository:\=\\%'/;s/'add_to_head' => ''/'add_to_head' => '<link rel="icon" href="dist\/favicon.ico">'/" configuration_sample.php>configuration.php
popd
goto end

:server-stop
del "%LOCALAPPDATA%\Tempmultipart_*">nul 2>&1
pushd "%apps_dir%"
if not exist Server\App\Nginx\conf goto server-stop_end
cd Server
pushd App\Nginx
:server-stop_nginx
call :check-process nginx.exe Nginx>nul 2>&1
if not %process_status% == 0 (
	nginx -s quit>nul 2>&1
	goto server-stop_nginx
)
popd
cd..
:server-stop_end
call :check-process php-cgi.exe PHP>nul 2>&1
if not %process_status% == 0 call :close ":server-php"
call :check-process mysqld.exe MariaDB>nul 2>&1
if not %process_status% == 0 (
	mysqladmin -u root shutdown
	call :del "Server\App\MariaDB\Data\%COMPUTERNAME%.*"
)
popd
goto end

:set-dns-resolvers
set one=%1
set two=%2
set three=""
if not defined one goto end
if not defined two set two=""
if not defined three set three=""
set one="%one:"=%"
set two=%two:"=%
set three=%three:"=%
if not defined two netsh interface ipv4 set dnsservers name=%one% source=dhcp
set index=0
for %%i in (%two%) do (
	set /a index+=1
	if !index! equ 1 netsh interface ipv4 set dnsservers name=%one% source=static address=%%i validate=no
	if !index! gtr 1 netsh interface ipv4 add dnsservers name=%one% address=%%i validate=no index=!index!
)
if not defined three netsh interface ipv6 set dnsservers name=%one% source=dhcp
set index=0
for %%i in (%three%) do (
	set /a index+=1
	if !index! equ 1 netsh interface ipv6 set dnsservers name=%one% source=static address=%%i validate=no
	if !index! gtr 1 netsh interface ipv6 add dnsservers name=%one% address=%%i validate=no index=!index!
)
ipconfig /flushdns
goto end

:settings
call :check-process privoxy.exe Privoxy>nul 2>&1
if not %process_status% == 1 goto settings_end
set proxy_server=%hostname%:%privoxy_port%
set http_proxy=http://%proxy_server%
set https_proxy=http://%proxy_server%
set chrome_proxy_settings=--proxy-server=%proxy_server%
set firefox_ssl_port=%privoxy_port%
set vlc_proxy_settings= --http-proxy=http://%proxy_server%/
:: set start_page=http://config.privoxy.org/
:: set hosts_block=
:settings_end
if defined chrome_hosts (
	if %is_admin% == 0 (
		if not defined hosts_block (
			set hosts_block=adminer.org
		) else (
			set hosts_block=adminer.org, %hosts_block%
		)
		set count=
		set chrome_hosts_block=
		for %%i in (!hosts_block!) do (
			set /a count+=1
			if count gtr 1 (
				if defined chrome_hosts_block set chrome_hosts_block=!chrome_hosts_block!, 
			)
			set chrome_hosts_block=!chrome_hosts_block!%%i/0.0.0.0
		)
		set chrome_hosts=%chrome_hosts%, !chrome_hosts_block!
	)
)
set count=
set host_resolver_rules=
set proxy_bypass_list=
for %%i in (%chrome_hosts%) do (
	set /a count+=1
	for /f "tokens=1* delims=/" %%x in ("%%i") do (
		if count gtr 1 (
			if defined host_resolver_rules set host_resolver_rules=!host_resolver_rules!, 
			if defined proxy_bypass_list set proxy_bypass_list=!proxy_bypass_list!, 
		)
		set host_resolver_rules=!host_resolver_rules!MAP *%%x %%y
		set proxy_bypass_list=!proxy_bypass_list!*%%x
	)
)
if %is_admin% == 1 (
	set chrome_switches=!chrome_switches:--disk-cache-dir=--disk-cache-dir="Z:\Cache" --disk-cache-size=1!
	set chromium_switches=!chromium_switches:--disk-cache-dir=--disk-cache-dir="Z:\Cache" --disk-cache-size=1!
	set edge_switches=!edge_switches:--disk-cache-dir=--disk-cache-dir="Z:\Cache" --disk-cache-size=1!
) else (
	set chrome_switches=!chrome_switches: --disk-cache-dir=!
	set chromium_switches=!chromium_switches: --disk-cache-dir=!
	set edge_switches=!edge_switches: --disk-cache-dir=!
)
if defined host_resolver_rules (
	set chrome_switches=!chrome_switches:--host-resolver-rules=--host-resolver-rules="%host_resolver_rules%"!
	set chromium_switches=!chromium_switches:--host-resolver-rules=--host-resolver-rules="%host_resolver_rules%"!
	set edge_switches=!edge_switches:--host-resolver-rules=--host-resolver-rules="%host_resolver_rules%, MAP *msn.com 0.0.0.0"!
	set opera_switches=!opera_switches:--host-resolver-rules=--host-resolver-rules="%host_resolver_rules%, MAP *opera.com 0.0.0.0"!
	set opera_gx_switches=!opera_gx_switches:--host-resolver-rules=--host-resolver-rules="%host_resolver_rules%, MAP *opera.com 0.0.0.0"!
) else (
	set chrome_switches=!chrome_switches: --host-resolver-rules=!
	set chromium_switches=!chromium_switches: --host-resolver-rules=!
	set edge_switches=!edge_switches: --host-resolver-rules=!
	set opera_switches=!opera_switches: --host-resolver-rules=!
	set opera_gx_switches=!opera_gx_switches: --host-resolver-rules=!
)
if defined chrome_proxy_settings (
	set chrome_switches=!chrome_switches:--proxy-server=%chrome_proxy_settings%!
	set chromium_switches=!chromium_switches:--proxy-server=%chrome_proxy_settings%!
	set edge_switches=!edge_switches:--proxy-server=%chrome_proxy_settings%!
	set opera_switches=!opera_switches:--proxy-server=%chrome_proxy_settings%!
	set opera_gx_switches=!opera_gx_switches:--proxy-server=%chrome_proxy_settings%!
) else (
	set chrome_switches=!chrome_switches: --proxy-server=!
	set chromium_switches=!chromium_switches: --proxy-server=!
	set edge_switches=!edge_switches: --proxy-server=!
	set opera_switches=!opera_switches: --proxy-server=!
	set opera_gx_switches=!opera_gx_switches: --proxy-server=!
)
call :check-process privoxy.exe Privoxy>nul 2>&1
if not %process_status% == 1 set proxy_bypass_list=
if defined proxy_bypass_list (
	set chrome_switches=!chrome_switches:--proxy-bypass-list=--proxy-bypass-list="%proxy_bypass_list%"!
	set chromium_switches=!chromium_switches:--proxy-bypass-list=--proxy-bypass-list="%proxy_bypass_list%"!
	set edge_switches=!edge_switches:--proxy-bypass-list=--proxy-bypass-list="%proxy_bypass_list%, *msn.com"!
	set opera_switches=!opera_switches:--proxy-bypass-list=--proxy-bypass-list="%proxy_bypass_list%, *opera.com"!
	set opera_gx_switches=!opera_gx_switches:--proxy-bypass-list=--proxy-bypass-list="%proxy_bypass_list%, *opera.com"!
) else (
	set chrome_switches=!chrome_switches: --proxy-bypass-list=!
	set chromium_switches=!chromium_switches: --proxy-bypass-list=!
	set edge_switches=!edge_switches: --proxy-bypass-list=!
	set opera_switches=!opera_switches: --proxy-bypass-list=!
	set opera_gx_switches=!opera_gx_switches: --proxy-bypass-list=!
)
if defined user_agent (
	set chrome_switches=!chrome_switches:--user-agent=--user-agent="%user_agent%"!
	set chromium_switches=!chromium_switches:--user-agent=--user-agent="%user_agent%"!
	set edge_switches=!edge_switches:--user-agent=--user-agent="%user_agent%"!
	set opera_switches=!opera_switches:--user-agent=--user-agent="%user_agent%"!
	set opera_gx_switches=!opera_gx_switches:--user-agent=--user-agent="%user_agent%"!
) else (
	set chrome_switches=!chrome_switches: --user-agent=!
	set chromium_switches=!chromium_switches: --user-agent=!
	set edge_switches=!edge_switches: --user-agent=!
	set opera_switches=!opera_switches: --user-agent=!
	set opera_gx_switches=!opera_gx_switches: --user-agent=!
)
if defined chrome_profile (
	set chrome_switches=!chrome_switches:--profile-directory=--profile-directory="%default_profile%"!
	set chromium_switches=!chromium_switches:--profile-directory=--profile-directory="%default_profile%"!
	set edge_switches=!edge_switches:--profile-directory=--profile-directory="%default_profile%"!
) else (
	set chrome_switches=!chrome_switches: --profile-directory=!
	set chromium_switches=!chromium_switches: --profile-directory=!
	set edge_switches=!edge_switches: --profile-directory=!
)
goto end

:setup
set switch=%1
if not defined switch set switch=install
pushd "%apps_dir%"
for %%i in (%apps%) do (
	set new_app_name=
	set app_name=%%i
	set app_name=!app_name:"=!
	set app_name=!app_name: =_!
	cmd /c %scripts%\!app_name!_Setup.cmd %switch%!new_app_name!>nul 2>&1
)
popd
if [%2] == [shortcuts] call :shortcuts>nul 2>&1
goto end

:shortcut
set shortcut_name=%2
if not defined shortcut_name goto end
set shortcut_parameters=%3
if not defined shortcut_parameters goto end
set shortcut_parameters=%shortcut_parameters:"=%
if /i "run" == "%shortcut_parameters:~0,3%" set shortcut_parameters=run %shortcut_name: =_% %shortcut_parameters:run =%
if /i not "%shortcut_parameters:admin-run=%" == "%shortcut_parameters%" set shortcut_parameters=admin-run %shortcut_name: =_% %shortcut_parameters:admin-run =%
set shortcut_parameters="%shortcut_parameters:"=%"
call :sanitize icon %4
if not defined icon goto shortcut_no_icon
:: if not exist %icon% goto shortcut_no_icon
nircmd shortcut %this% %1 %2 %shortcut_parameters% %icon% "" min
goto end
:shortcut_no_icon
nircmd shortcut %this% %1 %2 %shortcut_parameters% "" "" min
goto end

:shortcuts
set shortcuts_name=%1
echo Creating shortcuts, please wait...
set desktop_shortcuts="~$folder.desktop$"
call :sanitize shortcuts "%apps_dir%\Shortcuts"
if not [%shortcuts_name%] == [desktop] goto shortcuts_main
if exist %shortcuts% nircmd shortcut %shortcuts% %desktop_shortcuts% Apps
:: call :shortcut %desktop_shortcuts% "7-Zip File Manager" "run 7-zip" "%sevenzip_exe_path%"
:: call :install-and-create-shortcut %desktop_shortcuts% Chromium "run chromium" "%chromium_exe_path%"
:: call :install-and-create-shortcut %desktop_shortcuts% foobar2000 "run foobar2000" "%foobar2000_exe_path%"
:: call :install-and-create-shortcut %desktop_shortcuts% "Google Chrome" "run chrome" "%chrome_exe_path%"
:: call :install-and-create-shortcut %desktop_shortcuts% "LibreOffice Calc" "run libreoffice calc" "%libreoffice_scalc_exe_path%"
:: call :install-and-create-shortcut %desktop_shortcuts% "LibreOffice Impress" "run libreoffice impress" "%libreoffice_simpress_exe_path%"
:: call :install-and-create-shortcut %desktop_shortcuts% "LibreOffice Writer" "run libreoffice writer" "%libreoffice_swriter_exe_path%"
:: call :install-and-create-shortcut %desktop_shortcuts% "Mozilla Firefox" "run firefox" "%firefox_exe_path%"
:: call :install-and-create-shortcut %desktop_shortcuts% mpv "run mpv" "%mpv_exe_path%"
:: call :install-and-create-shortcut %desktop_shortcuts% Notepad++ "run notepad++" "%notepad_exe_path%"
:: call :install-and-create-shortcut %desktop_shortcuts% Opera "run opera" "%opera_launcher_exe_path%"
:: call :install-and-create-shortcut %desktop_shortcuts% Skype "run skype" "%skype_exe_path%"
:: call :install-and-create-shortcut %desktop_shortcuts% TeamViewer "run teamviewer" "%teamviewer_exe_path%"
:: call :install-and-create-shortcut %desktop_shortcuts% "VLC media player" "run vlc" "%vlc_exe_path%"
:: call :install-and-create-shortcut %desktop_shortcuts% WordWeb "run wordweb" "%wordweb_exe_path%"
goto end
:shortcuts_main
call :del "%shortcuts:"=%\*.lnk"
call :shortcut %shortcuts% 7-Zip "run 7-zip" "%sevenzip_exe_path%"
call :shortcut %shortcuts% Audacity "run audacity" "%audacity_exe_path%"
call :shortcut %shortcuts% Backup "center Backup backup" %ComSpec%
call :shortcut %shortcuts% "BusyBox (admin)" "admin-center BusyBox terminal ~q~q busybox" "%busybox_exe_path%"
call :shortcut %shortcuts% BusyBox "center BusyBox terminal ~q~q busybox" "%busybox_exe_path%"
call :shortcut %shortcuts% CCleaner "admin-run ccleaner" "%ccleaner_exe_path%"
call :shortcut %shortcuts% "CD ripper" "center CD_ripper cd-ripper" %ComSpec%
call :shortcut %shortcuts% Checksum "center Checksum checksum" %ComSpec%
:: call :shortcut %shortcuts% "Chrome (incognito)" "run chrome incognito" "%chrome_exe_path%"
call :shortcut %shortcuts% Chrome "run chrome" "%chrome_exe_path%"
:: call :shortcut %shortcuts% "Chromium (incognito)" "run chromium incognito" "%chromium_exe_path%"
call :shortcut %shortcuts% Chromium "run chromium" "%chromium_exe_path%"
call :shortcut %shortcuts% Delete "center Delete delete" %ComSpec%
call :shortcut %shortcuts% Disconnect "run disconnect"
call :shortcut %shortcuts% "Download (aria2)" "center Download_(aria2) download" %ComSpec%
call :shortcut %shortcuts% "Download (curl)" "center Download_(curl) download curl" %ComSpec%
call :shortcut %shortcuts% "Download (Wget)" "center Download_(Wget) download wget" %ComSpec%
:: call :shortcut %shortcuts% Download "center Download download" %ComSpec%
:: call :shortcut %shortcuts% "Edge (InPrivate)" "run edge inprivate" "%edge_exe_path%"
call :shortcut %shortcuts% Edge "run edge" "%edge_exe_path%"
call :shortcut %shortcuts% "f.lux (stop)" "run flux stop" "%flux_exe_path%"
call :shortcut %shortcuts% f.lux "run flux" "%flux_exe_path%"
call :shortcut %shortcuts% FileZilla "run filezilla" "%filezilla_exe_path%"
:: call :shortcut %shortcuts% "Firefox (private)" "run firefox private" "%firefox_exe_path%"
call :shortcut %shortcuts% Firefox "run firefox" "%firefox_exe_path%"
call :shortcut %shortcuts% foobar2000 "run foobar2000" "%foobar2000_exe_path%"
call :shortcut %shortcuts% GIMP "run gimp" "%gimp_exe_path%"
call :shortcut %shortcuts% Gmail "run app gmail"
call :shortcut %shortcuts% "Google Drive" "run app google-drive"
call :shortcut %shortcuts% GRUB "admin-center GRUB terminal ~q~q grub" %ComSpec%
call :shortcut %shortcuts% ImgBurn "run imgburn" "%imgburn_exe_path%"
:: call :shortcut %shortcuts% Kodi "run kodi" "%kodi_exe_path%"
call :shortcut %shortcuts% Laragon "run laragon" "%laragon_exe_path%"
call :shortcut %shortcuts% "LibreOffice Calc" "run libreoffice calc" "%libreoffice_scalc_exe_path%"
call :shortcut %shortcuts% "LibreOffice Impress" "run libreoffice impress" "%libreoffice_simpress_exe_path%"
call :shortcut %shortcuts% "LibreOffice Writer" "run libreoffice writer" "%libreoffice_swriter_exe_path%"
:: call :shortcut %shortcuts% LibreOffice "run libreoffice" "%libreoffice_soffice_exe_path%"
call :shortcut %shortcuts% "MIDI Player" "run midi-player" "%midi_player_exe_path%"
:: call :shortcut %shortcuts% "MinGit (admin)" "admin-center MinGit terminal ~q~q mingit" "%ComSpec%"
call :shortcut %shortcuts% MinGit "center MinGit terminal ~q~q mingit" "%ComSpec%"
:: call :shortcut %shortcuts% "Mozilla Thunderbird" "run thunderbird" "%thunderbird_exe_path%"
call :shortcut %shortcuts% mpv "run mpv" "%mpv_exe_path%"
:: call :shortcut %shortcuts% MuseScore "run musescore" "%musescore_exe_path%"
call :shortcut %shortcuts% nano "run nano" %ComSpec%
call :shortcut %shortcuts% ngrok "center ngrok ngrok" %ComSpec%
:: call :shortcut %shortcuts% "Node.js (admin)" "admin-center Node.js terminal ~q~q nodejs" "%nodejs_exe_path%"
:: call :shortcut %shortcuts% Node.js "center Node.js terminal ~q~q nodejs" "%nodejs_exe_path%"
call :shortcut %shortcuts% Notepad++ "run notepad++" "%notepad_exe_path%"
call :shortcut %shortcuts% OneDrive "run app onedrive"
:: call :shortcut %shortcuts% "Opera (private)" "run opera private" "%opera_launcher_exe_path%"
:: call :shortcut %shortcuts% "Opera GX (private)" "run opera_gx private" "%opera_gx_launcher_exe_path%"
call :shortcut %shortcuts% "Opera GX" "run opera_gx" "%opera_gx_launcher_exe_path%"
call :shortcut %shortcuts% Opera "run opera" "%opera_launcher_exe_path%"
call :shortcut %shortcuts% Outlook "run app outlook"
call :shortcut %shortcuts% PeaZip "run peazip" "%peazip_exe_path%"
:: call :shortcut %shortcuts% "Permanently delete" "center Permanently_delete permanently-delete" %ComSpec%
call :shortcut %shortcuts% PicPick "run picpick" "%picpick_exe_path%"
call :shortcut %shortcuts% pngquant "center pngquant pngquant" %ComSpec%
:: call :shortcut %shortcuts% "PortableGit (admin)" "admin-center PortableGit terminal ~q~q portablegit" "%ComSpec%"
call :shortcut %shortcuts% PortableGit "center PortableGit terminal ~q~q portablegit" "%ComSpec%"
call :shortcut %shortcuts% Superproxy "run superproxy"
call :shortcut %shortcuts% Psiphon "run psiphon" "%psiphon_exe_path%"
call :shortcut %shortcuts% REAPER "run reaper" "%reaper_exe_path%"
call :shortcut %shortcuts% "Remote sync" "center Remote_sync remote-sync" %ComSpec%
call :shortcut %shortcuts% Restore "center Restore restore" %ComSpec%
call :shortcut %shortcuts% Sass "center Sass sass" %ComSpec%
call :shortcut %shortcuts% "Server (stop)" "run server stop" "%nginx_exe_path%"
call :shortcut %shortcuts% Server "center Server_-_Super server" "%nginx_exe_path%"
call :shortcut %shortcuts% Shortcuts "center Shortcuts shortcuts" %ComSpec%
call :shortcut %shortcuts% Shotcut "run shotcut" "%shotcut_exe_path%"
call :shortcut %shortcuts% Skype "run skype" "%skype_exe_path%"
call :shortcut %shortcuts% Spotify "run app spotify"
call :shortcut %shortcuts% "Stream (audio)" "center Stream_(audio) stream audio" %ComSpec%
call :shortcut %shortcuts% Stream "center Stream stream" %ComSpec%
call :shortcut %shortcuts% TeamViewer "run teamviewer" "%teamviewer_exe_path%"
:: call :shortcut %shortcuts% Telegram "run telegram" "%telegram_exe_path%"
call :shortcut %shortcuts% "Terminal (admin)" "admin-center Terminal terminal" %ComSpec%
call :shortcut %shortcuts% Terminal "center Terminal terminal" %ComSpec%
call :shortcut %shortcuts% TimeSync "admin-run timesync" "%timesync_exe_path%"
call :shortcut %shortcuts% "Transcode (many)" "center Transcode_(many) transcode-many" %ComSpec%
call :shortcut %shortcuts% "Transcode (one)" "center Transcode_(one) transcode-one" %ComSpec%
call :shortcut %shortcuts% Update "center Update update" %ComSpec%
call :shortcut %shortcuts% "Visual Studio Code" "run code" "%vscode_exe_path%"
call :shortcut %shortcuts% "VLC media player" "run vlc" "%vlc_exe_path%"
call :shortcut %shortcuts% "VNC Viewer" "run vnc-viewer" "%vnc_viewer_exe_path%"
call :shortcut %shortcuts% WordWeb "run wordweb" "%wordweb_exe_path%"
call :shortcut %shortcuts% "XAMPP (stop)" "run xampp stop" "%xampp_stop_exe_path%"
call :shortcut %shortcuts% XAMPP "center XAMPP_-_Super xampp" "%xampp_start_exe_path%"
call :shortcut %shortcuts% "YouTube Music" "run app youtube-music"
call :shortcut %shortcuts% "YouTube on TV" "run app youtube-on-tv"
call :shortcut %shortcuts% YouTube "run app youtube"
call :shortcut %shortcuts% youtube-dl "center youtube-dl youtube-dl" %ComSpec%
goto end

:shotcut
call :require Shotcut
call :sanitize input %1
if defined input set input= %input:&=^&%
call :check-process "%shotcut_exe_path%" Shotcut
if not %process_status% == 0 (
	if defined input set input=%input:^=%
	start "" "%shotcut_exe_path%"!input!
	goto end
)
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%shotcut_exe_path%" --noupgrade --gpu --clear-recent --appdata %shotcut_data_dir%%input% & reg delete "%hkcu_software_qtproject%" /f & %this% speak "Shotcut was closed"">nul 2>&1
goto end

:skype
call :require Skype
call :sanitize input %1
if defined input set input= %input:&=^&%
call :check-process "%skype_exe_path%" Skype
if not %process_status% == 0 (
	if defined input set input=%input:^=%
	start "" "%skype_exe_path%"!input! --datapath="%skype_data_dir%"
	goto end
)
if %is_admin% == 0 call :rd "%skype_data_dir%"
set skype_command=echo.
if %is_admin% == 0 set skype_command=rd "%skype_data_dir%" /q /s
if exist "%local_skype%" goto skype_default
if exist "%local_skype_x86%" goto skype_default
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & ren "%appdata_skype%" Skype_Backup & ren "%skype_for_desktop_datapath%" "Skype for Desktop_Backup" & "%skype_exe_path%"%input% --datapath="%skype_data_dir%" & %skype_command:ampersand=&% & rd "%appdata_skype%" "%skype_for_desktop_datapath%" /q /s & ren "%appdata_skype%_Backup" Skype & ren "%skype_for_desktop_datapath%_Backup" "Skype for Desktop" & reg delete %hkcu_startup% /v "Skype for Desktop" /f & %this% speak "Skype was closed"">nul 2>&1
goto end
:skype_default
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%skype_exe_path%"%input% --datapath="%skype_data_dir%" & %this% speak "Skype was closed"">nul 2>&1
goto end

:speak
if not %is_speak% == 1 goto end
call :require balcon
set text=%1
balcon -n "Microsoft Zira Desktop" -t "%text:"=%"
goto end

:start
set first=%1
set second=%2
set third=%3
set fourth=%4
set fifth=%5
if defined first set first=:%first%
if defined second set second= %second%
if defined third set third= %third%
if defined fourth set fourth= %fourth%
if defined fifth set fifth= %fifth%
call %first%%second%%third%%fourth%%fifth%
goto end

:start-wrapper
call :start %b% %c%%d%%e%%f%
goto end

:startup
call :sanitize startup "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
if [%1] == [disable] goto startup_disable
:: call :flux
call :server "%USERPROFILE%"
call :shortcut %startup% Startup "run startup"
goto end
:startup_disable
:: call :flux-stop
call :server-stop
call :del "%startup:"=%\Startup.lnk"
goto end

:stream
call :require mpv
call :require youtube-dl
if [%1] == [audio] set mpv_stream_format=%mpv_stream_format_audio%
:stream_input_url
set input_url=
set /p input_url=URL: 
if not defined input_url goto stream_input_url
call :escape input_url "%input_url:"=%"
set input_url=%input_url:"=%
if /i not "%input_url:youtube.com=%" == "%input_url%" (
	if /i not "%input_url:playlist=%" == "%input_url%" set mpv_loop=playlist
)
call :escape input_url "%input_url:"=%"
call :mpv_config
echo.
echo Playing: %input_url:escape_ampersand=^&%
echo.
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%mpv_exe_path%" %input_url:escape_ampersand=^&% & %this% speak "mpv was closed""
goto stream_input_url

:superproxy
call :disconnect
call :privoxy %1
goto end

:teamviewer
call :require TeamViewer
call :check-process %teamviewer_exe% TeamViewer
if not %process_status% == 0 goto end
if exist "%local_teamviewer_exe_path%" goto teamviewer_default
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & rd "%localappdata_teamviewer%" /q /s & ren "%appdata_teamviewer%" TeamViewer_Backup & "%teamviewer_exe_path%" & rd "%localappdata_teamviewer%" "%appdata_teamviewer%" /q /s & ren "%appdata_teamviewer%_Backup" TeamViewer & reg delete %hkcu_software_teamviewer% /f & %this% speak "TeamViewer was closed"">nul 2>&1
goto end
:teamviewer_default
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%local_teamviewer_exe_path%" & %this% speak "TeamViewer was closed"">nul 2>&1
goto end

:telegram
call :require Telegram
call :sanitize input %1
if defined input set input= -- %input:&=^&%
call :check-process "%telegram_exe_path%" Telegram
if not %process_status% == 0 (
	if defined input set input=%input:^=%
	start "" "%telegram_exe_path%"!input! -workdir "%telegram_data_dir%"
	goto end
)
call :md "%telegram_data_dir%"
if exist %local_telegram% goto telegram_default
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%telegram_exe_path%"%input% -externalupdater -workdir "%telegram_data_dir%" & reg delete %hkcu_software_telegram% /f & %this% speak "Telegram was closed"">nul 2>&1
goto end
:telegram_default
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%telegram_exe_path%"%input% -externalupdater -workdir "%telegram_data_dir%" & %this% speak "Telegram was closed"">nul 2>&1
goto end

:terminal
set terminal_color=%1
set terminal_color=%terminal_color:"=%
if not defined terminal_color set terminal_color=%cmd_color%
if defined terminal_color set terminal_color=/t:%terminal_color% 
if [%2] == [busybox] (
	call :require BusyBox
	set PATH=%apps_dir%\BusyBox\App;%PATH:)=^)%
)
if [%2] == [mingit] (
	call :require MinGit
	set PATH=%apps_dir%\MinGit\App\cmd;%apps_dir%\MinGit\App\mingw%mingw%\bin;%apps_dir%\MinGit\App\usr\bin;%PATH:)=^)%
)
if [%2] == [nodejs] (
	call :require Node.js
	set PATH=%apps_dir%\Node.js\App;%PATH:)=^)%
)
if [%2] == [portablegit] (
	call :require PortableGit
	set PATH=%apps_dir%\PortableGit\App\cmd;%apps_dir%\PortableGit\App\mingw%mingw%\bin;%apps_dir%\PortableGit\App\usr\bin;%PATH:)=^)%
)
doskey open=%this% open $*
prompt $p$_$$$s
cd /d %home_dir%
if [%2] == [grub] (
	call :require GRUB
	pushd "%apps_dir%"
	if not exist GRUB (
		popd
		goto end
	)
	cd GRUB
	cd App
)
set ORIGINAL_ALLUSERSPROFILE=%ALLUSERSPROFILE%
set ALLUSERSPROFILE=%settings_dir%
cmd %terminal_color%/k
set ALLUSERSPROFILE=%ORIGINAL_ALLUSERSPROFILE%
exit
goto end

:thunderbird
call :require "Mozilla Thunderbird"
if %is_admin% == 0 call :rd "%thunderbird_data_dir%"
call :md "%thunderbird_data_dir%"
echo user_pref("app.update.enabled", false);>>%thunderbird_preferences%
echo user_pref("mail.shell.checkDefaultClient", false);>>%thunderbird_preferences%
echo user_pref("mail.winsearch.firstRunDone", true);>>%thunderbird_preferences%
set thunderbird_command=echo.
if %is_admin% == 0 set thunderbird_command=rd "%thunderbird_data_dir%" /q /s
if exist "%local_thunderbird%" goto thunderbird_default
if exist "%local_thunderbird_x86%" goto thunderbird_default
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & ren "%localappdata_thunderbird%" Thunderbird_Backup & ren "%appdata_mozilla%" Mozilla_Backup & ren "%appdata_thunderbird%" Thunderbird_Backup & "%thunderbird_exe_path%" -profile "%thunderbird_data_dir%" & rd "%localappdata_thunderbird%" /q /s & ren "%localappdata_thunderbird%_Backup" Thunderbird & rd "%appdata_mozilla%" /q /s & ren "%appdata_mozilla%_Backup" Mozilla & rd "%appdata_thunderbird%" /q /s & ren "%appdata_thunderbird%_Backup" Thunderbird & if %is_admin% == 1 rd "%localappdata_thunderbird%" "%appdata_mozilla%" "%appdata_thunderbird%" /q /s & %thunderbird_command% & reg delete %hkcu_software_thunderbird% /f & %this% clear-recent-items & %this% speak "Thunderbird was closed"">nul 2>&1
goto end
:thunderbird_default
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%thunderbird_exe_path%" -profile "%thunderbird_data_dir%" & %thunderbird_command% & %this% clear-recent-items & %this% speak "Thunderbird was closed"">nul 2>&1
goto end

:timesync
call :require TimeSync
call :check-privilege %0 TimeSync
if not %privilege% == 1 goto end
call :check-process %timesync_exe% TimeSync
if not %process_status% == 0 goto end
pushd "%apps_dir%"
if not exist TimeSync (
	popd
	goto end
)
cd TimeSync
cd App
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & del %timesync_config% & %timesync_exe% & del %timesync_config% & %this% speak "TimeSync was closed"">nul 2>&1
cd..
cd..
popd
goto end

:transcode
call :require FFmpeg
call :require FLAC
call :require FluidSynth
call :require "Free Encoder Pack"
call :require LAME
call :require MediaInfo
call :require "Microsoft Visual C++ 2015-2019 Redistributable"
call :require SoundFonts
call :escape input_file %1
if not defined input_file goto end
call :escape input_dir "%CD%"
set input_dir=%input_dir:"=%
if not [%input_file:\=%] == [%input_file%] set input_dir=%~dp1
if [%input_dir:~-1%] == [\] set input_dir=%input_dir:~0,-1%
call :unescape input_dir "%input_dir:"=%"
call :unescape input_file "%input_dir:"=%\%~nx1"
set input_format=%~x1
set input_format=%input_format:~1%
if /i [%input_format%] == [kar] set input_format=mid
if /i [%input_format%] == [mid] (
	call :unescape temporary_input_file "%input_dir:"=%\%~n1.wav"
	fluidsynth%fluidsynth_options% -T wav -F !temporary_input_file! %soundfont% %input_file%
)
:: mediainfo --Inform="Audio;%%Duration%%" %input_file%>transcode_duration.txt
:: set /p transcode_duration=<transcode_duration.txt
:: set /a transcode_duration=%transcode_duration% / 1000>nul 2>&1
:: call :del transcode_duration.txt
set options=
set output_folder=Transcoded
call :unescape output_name "%~n1"
set output_file="%output_name:"=%.%2"
pushd %input_dir%
if /i not [%3] == [rip] (
	call :md %output_folder%>nul 2>&1
	if not exist %output_folder% (
		popd
		goto end
	)
	cd %output_folder%
)
robocopy ..\ . folder.jpg>nul 2>&1
attrib +h +s folder.jpg>nul 2>&1
if /i [%2] == [aac] goto transcode_aac
if /i [%2] == [avi] goto transcode_avi
if /i [%2] == [flac] goto transcode_flac
if /i [%2] == [mkv] goto transcode_mkv
if /i [%2] == [mp3] goto transcode_mp3
if /i [%2] == [mp4] goto transcode_mp4
if /i [%2] == [png] goto transcode_png
if /i [%2] == [proxy] goto transcode_proxy
if /i [%2] == [tv] goto transcode_tv
if /i [%2] == [wav] goto transcode_wav
if /i [%2] == [youtube] goto transcode_youtube
:transcode_aac
call :require qaac
:: set output_file="%output_name:"=% -- %transcode_duration%.m4a"
set output_file="%output_name:"=%.m4a"
set qaac_options=qaac -v 256 -q 2 --no-smart-padding -o %output_file%
call :del %output_file%
if /i [%input_format%] == [flac] %qaac_options% %input_file%
if /i [%input_format%] == [mid] (
	%qaac_options% %temporary_input_file%
	call :del %temporary_input_file%
)
if /i [%input_format%] == [wav] %qaac_options% %input_file%
goto transcode_end
:transcode_avi
set output_file="%output_name:"=%.avi"
call :del %output_file%
ffmpeg -hide_banner -i %input_file% -vf scale=640:-1 -codec:v mpeg4 -vtag xvid -qscale:v 3 -codec:a libmp3lame -qscale:a 3 %output_file%
goto transcode_end
:transcode_flac
set output_file="%output_name:"=%.flac"
set flac_options=flac --best --output-name=%output_file% --verify
call :del %output_file%
if /i [%input_format%] == [flac] %flac_options% %input_file%
if /i [%input_format%] == [mid] %flac_options% %temporary_input_file%
if /i [%input_format%] == [wav] %flac_options% %input_file%
goto transcode_end
:transcode_mkv
set output_file="%output_name:"=%.mkv"
call :del %output_file%
:: -vf scale=%video_width%:-1
ffmpeg -i %input_file% -c:v libx264 -preset slow -crf 18 -c:a copy -pix_fmt yuv420p %output_file%
goto transcode_end
:transcode_mp3
set options=-codec:a libmp3lame -qscale:a 0
set output_file="%output_name:"=%.mp3"
call :del %output_file%
if /i [%input_format%] == [flac] (
	for /f "tokens=* delims=" %%i in ('metaflac --export-tags-to - %input_file%') do set %%i
	set id3_tags=--add-id3v2 --tt "!title!" --ta "!artist!" --tl "!album!" --ty "!date!" --tn "!tracknumber!"
	if exist folder.jpg set id3_tags=!id3_tags! --ti folder.jpg
	flac --decode --stdout %input_file% | lame !id3_tags! --preset extreme - %output_file%
)
if /i [%input_format%] == [m4a] goto transcode_default
if /i [%input_format%] == [mid] lame --preset extreme %temporary_input_file% %output_file%
if /i [%input_format%] == [mp4] goto transcode_default
if /i [%input_format%] == [wav] lame --preset extreme %input_file% %output_file%
if /i [%input_format%] == [webm] goto transcode_default
goto transcode_end
:transcode_mp4
:: set options=-vf scale=640:-1,hue=s=0.9,vignette=PI/4
set options=-vf scale=%video_width%:-1 -c:a copy
set output_file="%output_name:"=%.mp4"
call :del %output_file%
if /i [%input_format%] == [mkv] goto transcode_default
if /i [%input_format%] == [mp4] goto transcode_default
goto transcode_end
:transcode_png
set options=-vf scale=640:-1
set output_file="%output_name:"=%.png"
call :del %output_file%
if /i [%input_format%] == [png] goto transcode_default
goto transcode_end
:transcode_proxy
set options=-c:v libx264 -preset ultrafast -crf 0 -vf scale=426:-1 -c:a copy
set output_file="%output_name:"=%.mp4"
call :del %output_file%
if /i [%input_format%] == [mkv] goto transcode_default
if /i [%input_format%] == [mp4] goto transcode_default
goto transcode_end
:transcode_tv
set tv_folder=H.264+PCM
call :md %tv_folder%
set output_file="%tv_folder%\%output_name:"=%.mkv"
call :del %output_file%
ffmpeg -i %input_file% -c:v copy -c:a pcm_s16le %output_file%
rd %tv_folder%>nul 2>&1
goto transcode_end
:transcode_wav
set output_file="%output_name:"=%.wav"
if /i not [%3] == [rip] call :del %output_file%
if /i [%input_format%] == [flac] (
	flac --decode --output-name=%output_file% %input_file%
	goto transcode_end
)
if /i [%input_format%] == [mid] (
	move %temporary_input_file% .>nul 2>&1
	goto transcode_end
)
if /i [%input_format%] == [wav] (
	goto transcode_end
) else (
	goto transcode_default
)
goto transcode_end
:transcode_youtube
set temporary_m4a_file="%output_name:"=%.m4a"
set output_file="%output_name:"=%.mp4"
call :del %temporary_m4a_file%
call :del %output_file%
ffmpeg -hide_banner -i %input_file% -f wav - | fhgaacenc --cbr 384 --profile lc - %temporary_m4a_file%
ffmpeg -hide_banner -i %input_file% -i %temporary_m4a_file% -c:v copy -c:a copy -map 0:v -map 1:a %output_file%
call :del %temporary_m4a_file%
goto transcode_end
:transcode_default
if defined options set options= %options%
ffmpeg -hide_banner -i %input_file%%options% %output_file%
goto transcode_end
:transcode_end
if defined temporary_input_file call :del %temporary_input_file%
if /i not [%3] == [rip] (
	cd..
	rd %output_folder%>nul 2>&1
)
popd
goto end

:transcode-many
set codec=
set /p codec=Codec: 
if not defined codec goto transcode-many
cd /d %home_dir%
:transcode-many_input_dir
set input_dir=
set /p input_dir=Source: 
if not defined input_dir goto transcode-many_input_dir
if not exist %input_dir% goto transcode-many_input_dir
call :sanitize input_dir "%input_dir:"=%"
pushd %input_dir%
echo.
for %%x in ("%input_dir:"=%\*.*") do (
	call :escape input_file "%%x"
	call :transcode !input_file! %codec%
)
echo.
popd
goto transcode-many

:transcode-one
set codec=
set /p codec=Codec: 
if not defined codec goto transcode-one
cd /d %home_dir%
:transcode-one_input_file
set input_file=
set /p input_file=File: 
if not defined input_file goto transcode-one_input_file
if not exist %input_file% goto transcode-one_input_file
call :sanitize input_file "%input_file:"=%"
for %%* in (%input_file%) do set input_dir=%%~dp*
call :escape input_dir "%input_dir%"
call :unescape input_dir %input_dir%
pushd %input_dir%
echo.
call :escape input_file "%input_file:"=%"
call :transcode %input_file% %codec%
echo.
popd
goto transcode-one

:unescape
set variable=%1
set value=%2
set %variable%=%value%
if not defined %variable% goto end
set %variable%=%value:escape_ampersand=&%
goto end

:uninstall
set first=%0
set first=%first::=%
set second=%1
if defined second set second= %second%
call :server-stop
call :kill %ccleaner_exe%
call :setup %first%%second%
goto end

:update
call :require aria2
pushd "%apps_dir%"
aria2c --check-certificate=false --conditional-get=true --dir="%dependencies_dir%\Downloads" --max-connection-per-server=16 --remote-time=true http://www.cross-plus-a.com/balcon.zip
:: aria2c --check-certificate=false --conditional-get=true --dir="%dependencies_dir%\Downloads" --max-connection-per-server=16 --remote-time=true https://frippery.org/files/busybox/busybox.exe
aria2c --check-certificate=false --conditional-get=true --dir="%dependencies_dir%\Downloads" --max-connection-per-server=16 --remote-time=true https://frippery.org/files/busybox/busybox64.exe
aria2c --check-certificate=false --conditional-get=true --dir="%dependencies_dir%\Downloads" --max-connection-per-server=16 --remote-time=true https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-full-shared.7z
aria2c --check-certificate=false --conditional-get=true --dir="%dependencies_dir%\Downloads" --max-connection-per-server=16 --remote-time=true https://justgetflux.com/flux-setup.exe
aria2c --check-certificate=false --conditional-get=true --dir="%dependencies_dir%\Downloads" --max-connection-per-server=16 --remote-time=true https://www.apple.com/itunes/download/win64
:: aria2c --check-certificate=false --conditional-get=true --dir="%dependencies_dir%\Downloads" --max-connection-per-server=16 --remote-time=true https://www.apple.com/itunes/download/win32
aria2c --check-certificate=false --conditional-get=true --dir="%dependencies_dir%\Downloads" --max-connection-per-server=16 --remote-time=true https://sourceforge.net/projects/laragon/files/Portable/laragon.7z
:: aria2c --check-certificate=false --conditional-get=true --dir="%dependencies_dir%\Downloads" --max-connection-per-server=16 --remote-time=true https://www.nirsoft.net/utils/nircmd.zip
aria2c --check-certificate=false --conditional-get=true --dir="%dependencies_dir%\Downloads" --max-connection-per-server=16 --remote-time=true https://www.nirsoft.net/utils/nircmd-x64.zip
aria2c --check-certificate=false --conditional-get=true --dir="%dependencies_dir%\Downloads" --max-connection-per-server=16 --remote-time=true https://www.picpick.org/releases/latest/picpick_portable.zip
aria2c --check-certificate=false --conditional-get=true --dir="%dependencies_dir%\Downloads" --max-connection-per-server=16 --remote-time=true https://pngquant.org/pngquant-windows.zip
aria2c --check-certificate=false --conditional-get=true --dir="%dependencies_dir%\Downloads" --max-connection-per-server=16 --remote-time=true https://s3.amazonaws.com/psiphon/web/mjr4-p23r-puwl/psiphon3.exe
aria2c --check-certificate=false --conditional-get=true --dir="%dependencies_dir%\Downloads" --max-connection-per-server=16 --remote-time=true https://go.skype.com/windows.desktop.download
aria2c --check-certificate=false --conditional-get=true --dir="%dependencies_dir%\Downloads" --max-connection-per-server=16 --remote-time=true https://download.teamviewer.com/download/TeamViewerPortable.zip
:: aria2c --check-certificate=false --conditional-get=true --dir="%dependencies_dir%\Downloads" --max-connection-per-server=16 --remote-time=true https://telegram.org/dl/desktop/win_portable
:: aria2c --check-certificate=false --conditional-get=true --dir="%dependencies_dir%\Downloads" --max-connection-per-server=16 --remote-time=true https://horstmuc.de/win/timesync.zip
aria2c --check-certificate=false --conditional-get=true --dir="%dependencies_dir%\Downloads" --max-connection-per-server=16 --remote-time=true https://horstmuc.de/win64/timesync64.zip
aria2c --check-certificate=false --conditional-get=true --dir="%dependencies_dir%\Downloads" --max-connection-per-server=16 --remote-time=true https://wordweb.info/cgi-bin/geoip/wordweb.exe
:: aria2c --check-certificate=false --conditional-get=true --dir="%dependencies_dir%\Downloads" --max-connection-per-server=16 --remote-time=true https://uk.wordwebsoftware.com/downloads/wordweb9.exe
:: aria2c --check-certificate=false --conditional-get=true --dir="%dependencies_dir%\Downloads\32-bit" --max-connection-per-server=16 --remote-time=true "https://download.mozilla.org/?product=firefox-latest-ssl&os=win&lang=en-US"
:: aria2c --check-certificate=false --conditional-get=true --dir="%dependencies_dir%\Downloads\64-bit" --max-connection-per-server=16 --remote-time=true "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US"
aria2c --check-certificate=false --conditional-get=true --dir="%dependencies_dir%\Downloads" --max-connection-per-server=16 --remote-time=true "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US"
for %%i in (%chrome_extensions%) do (
	for /f "tokens=1* delims=/" %%x in ("%%i") do (
		set chrome_extension_slug=%%x
		aria2c --check-certificate=false --conditional-get=true --dir="%dependencies_dir%\Downloads" --max-connection-per-server=16 --out=!chrome_extension_slug:-=_!.crx --remote-time=true "https://clients2.google.com/service/update2/crx?response=redirect&prodversion=%prodversion%&acceptformat=crx2,crx3&x=id%%3D%%y%%26installsource%%3Dondemand%%26uc"
	)
)
for %%i in (%firefox_addons%) do (
	for /f "tokens=1* delims=/" %%x in ("%%i") do (
		set firefox_addon_slug=%%y
		aria2c --check-certificate=false --conditional-get=true --dir="%dependencies_dir%\Downloads" --max-connection-per-server=16 --out=!firefox_addon_slug:-=_!.xpi --remote-time=true https://addons.mozilla.org/firefox/downloads/latest/%%x/
	)
)
for %%i in (%opera_extensions%) do (
	for /f "tokens=1* delims=/" %%x in ("%%i") do (
		set opera_extension_slug=%%y
		aria2c --check-certificate=false --conditional-get=true --dir="%dependencies_dir%\Downloads" --max-connection-per-server=16 --out=!opera_extension_slug:-=_!.nex --remote-time=true https://addons.opera.com/extensions/download/%%x/
	)
)
popd
goto end

:vlc
call :require "VLC media player"
call :require SoundFonts
call :sanitize input %1
if defined input set input= %input:&=^&%
call :check-process "%vlc_exe_path%" "VLC media player">nul 2>&1
if not %process_status% == 0 (
	if defined input set input=%input:^=%
	start "" "%vlc_exe_path%" --one-instance!input!
	goto end
)
set vlc_options=%vlc_options: --ignore-config=%
if not exist %soundfont% set vlc_options=%vlc_options: --soundfont=%
set vlc_options=!vlc_options:--soundfont=--soundfont=%soundfont%!
set vlc_command=robocopy "%vlc_config_dir%" "%vlc_data_dir%" /mir
if %is_admin% == 0 (
	set vlc_command=echo.
	if not exist "%vlc_data_dir%" set vlc_command=robocopy "%vlc_config_dir%" "%vlc_data_dir%" /mir
	call :rd "%vlc_config_dir%"
)
call :md "%vlc_config_dir%"
if exist "%vlc_data_dir%" robocopy "%vlc_data_dir%" "%vlc_config_dir%" /mir>nul 2>&1
if exist "%local_vlc%" goto vlc_default
if exist "%local_vlc_x86%" goto vlc_default
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%vlc_exe_path%"%vlc_options%%input% & %vlc_command% & rd "%vlc_config_dir%" /q /s & reg delete "%hkcu_software_qtproject%" /f & %this% speak "VLC media player was closed"">nul 2>&1
goto end
:vlc_default
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%vlc_exe_path%"%vlc_options%%input% & %vlc_command% & rd "%vlc_config_dir%" /q /s & %this% speak "VLC media player was closed"">nul 2>&1
goto end

:vnc-viewer
call :require "VNC Viewer"
call :check-process "%vnc_viewer_exe_path%" "VNC Viewer"
if not %process_status% == 0 (
	start "" "%vnc_viewer_exe_path%"
	goto end
)
if exist "%local_vnc_viewer%" goto vnc-viewer_default
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%vnc_viewer_exe_path%" -_SplashVer=1 -EnableAnalytics=0 -EulaAccepted="191331e524ab1bb95b76469148f042a0c81c2057" -FullScreen="True" -WarnUnencrypted=0 & if not exist "%local_vnc_server%" reg delete %hkcu_software_realvnc% /f & if not exist "%local_vnc_server%" rd "%localappdata_realvnc%" /q /s & if not exist "%local_vnc_server%" rd "%appdata_realvnc%" /q /s & %this% speak "VNC Viewer was closed"">nul 2>&1
goto end
:vnc-viewer_default
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%vnc_viewer_exe_path% & %this% speak "VNC Viewer was closed"">nul 2>&1
goto end

:wait
set zero=%0
set exe=%1
call :del "%apps_dir%\%zero::=%.lock"
call :check-process "%exe:"=%">nul 2>&1
if not %process_status% == 0 goto wait
goto end

:windows-defender
call :check-privilege %0 "Windows Defender"
if not %privilege% == 1 goto end
if [%1] == [disable] goto windows-defender_disable
reg delete "%hklm_software%\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /f>nul 2>&1
goto end
:windows-defender_disable
reg add "%hklm_software%\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f>nul 2>&1
goto end

:windows-update
call :check-privilege %0 "Windows Update"
if not %privilege% == 1 goto end
if [%1] == [disable] goto windows-update_disable
sc config wuauserv start=demand
sc start wuauserv
goto end
:windows-update_disable
sc stop wuauserv
sc config wuauserv start=disabled
goto end

:wordweb
call :require Wordweb
call :check-process %wordweb_exe% Wordweb
if not %process_status% == 0 goto end
start "%0" cmd /c "nircmd win center title %0 & nircmd win min title %0 & nircmd win hide title %0 & "%wordweb_exe_path%" & %this% speak "WordWeb was closed"">nul 2>&1
goto end

:wrapper
set first=%1
set second=%2
set third=%3
set fourth=%4
if defined first set first=%first:"=%
set first=%first:_= %
if defined second set second=:%second%
if [%second%] == [%0] goto end
if defined third set third= %third%
if defined fourth set fourth= %fourth%
title %first%
echo %first%
echo.
call %second%%third%%fourth%
echo.
set /p pause=Press Enter to continue... 
goto end

:xampp
call :check-process nginx.exe Nginx>nul 2>&1
if not %process_status% == 0 goto end
if [%1] == [stop] (
	nircmd win close title "XAMPP - Super"
	call :speak "XAMPP was closed"
	goto xampp-stop
)
call :xampp-stop
call :require BusyBox
call :require FileGator
call :require "Microsoft Visual C++ 2015-2019 Redistributable"
call :require XAMPP
pushd "%apps_dir%"
if not exist XAMPP\App\php\php.exe goto xampp_end
cd XAMPP
pushd App
php\php.exe -n -d output_buffering=0 -q install\install.php usb>nul 2>&1
:: if %is_admin% == 0 goto xampp_php
set xampp_title=%0-mariadb
start "%xampp_title%" cmd /c "nircmd win center title %xampp_title% & nircmd win hide title %xampp_title% & nircmd win activate stitle "XAMPP - Super" & mysql\bin\mysqld --defaults-file=mysql\bin\my.ini --standalone>nul 2>&1"
:xampp_php
if not exist "%apps_dir%\%html_apps%\filegator" goto xampp_end
cd /d %home_dir%
set location=%1
if not defined location set /p location=Location: 
if not defined location set location=%USERPROFILE%
call :sanitize location "%location:"=%"
if not exist %location% goto xampp_php
call :server-filegator %location%
popd
cd App
cd apache
cd conf
if not exist httpd.conf_original ren httpd.conf httpd.conf_original
%apps_dir%\BusyBox\App\sed.exe "s/Listen 80/Listen 80\nListen 2021\nListen 8080/;s/#LoadModule proxy_http_module modules\/mod_proxy_http.so/LoadModule proxy_http_module modules\/mod_proxy_http.so/" httpd.conf_original>httpd.conf
for /f "tokens=1* delims=:" %%a in ("%apps_dir%") do set apps_dir_without_drive_letter=%%b
set projects_dir=%home_dir%\%projects%
if "%home_dir:"=%" == "%~d0\" set projects_dir=%home_dir%%projects%
for /f "tokens=1* delims=:" %%a in ("%projects_dir%") do set projects_dir_without_drive_letter=%%b
%apps_dir%\BusyBox\App\sed.exe "s/%%apps_dir%%/%apps_dir_without_drive_letter:\=\/%/;s/%%html%%/%apps_dir_without_drive_letter:\=\/%\/%html%/;s/%%html_apps%%/%apps_dir_without_drive_letter:\=\/%\/%html_apps:\=\/%/;s/%%projects_dir%%/%projects_dir_without_drive_letter:\=\/%/" "%settings_dir%\xampp\apache\conf\extra\httpd-vhosts.conf">extra\httpd-vhosts.conf
cd..
cd..
set old_apps_dir=!apps_dir:%~d0=!
%apps_dir%\BusyBox\App\sed.exe -i "s/= !old_apps_dir:\=\\!/= !apps_dir:\=\\!/;s/\"!old_apps_dir:\=\\!/\"!apps_dir:\=\\!/" php\php.ini
set xampp_title=%0-apache
start "%xampp_title%" cmd /c "nircmd win center title %xampp_title% & nircmd win hide title %xampp_title% & nircmd win activate stitle "XAMPP - Super" & apache\bin\httpd.exe>nul 2>&1"
cd..
if [%1] == [] (
	pushd App
	goto xampp_php
)
:xampp_end
popd
goto end

:xampp-stop
pushd "%apps_dir%"
if not exist XAMPP\App goto xampp-stop_end
pushd XAMPP\App
call :check-process httpd.exe Apache>nul 2>&1
if not %process_status% == 0 (
	call :kill httpd.exe>nul 2>&1
	call :del apache\logs\httpd.pid
)
call :check-process mysqld.exe MariaDB>nul 2>&1
if not %process_status% == 0 (
	call :kill mysqld.exe>nul 2>&1
	call :del "mysql\data\%COMPUTERNAME%.*"
)
popd
:xampp-stop_end
popd
goto end

:youtube-dl
call :require aria2
call :require FFmpeg
call :require youtube-dl
set format=%1
if not defined format set /p format=Format: 
set options= -f %format%
if not defined format set options=
cd /d %home_dir%
:youtube-dl_location
set location=
set /p location=Location: 
if not defined location (
	set location=%USERPROFILE%\%videos%
	if [%format%] == [140] set location=%USERPROFILE%\%music%
	if [%format%] == [251] set location=%USERPROFILE%\%music%
	if /i [%format%] == [bestaudio] set location=%USERPROFILE%\%music%
	if /i [%format%] == [bestvideo+m4a] set location=%USERPROFILE%\%videos%
	if /i [%format%] == [m4a] set location=%USERPROFILE%\%music%
	if /i [%format%] == [tv] set location=%USERPROFILE%\%videos%
)
call :sanitize location "%location:"=%"
if not exist %location% goto youtube-dl_location
echo.
echo The files will be saved in %location%
echo.
:youtube-dl_input_url
set input_url=
set /p input_url=URL: 
if not defined input_url goto youtube-dl_input_url
call :escape input_url "%input_url:"=%"
set input_url=%input_url:"=%
set output_file="%%(title)s -- %%(id)s.%%(ext)s"
if /i not "%input_url:youtube.com=%" == "%input_url%" (
	if /i not "%input_url:playlist=%" == "%input_url%" set output_file="%%(playlist_uploader)s\%%(playlist)s\%%(playlist_index)s %output_file:"=%"
)
call :escape input_url "%input_url:"=%"
pushd %location%
if /i [%format%] == [tv] set options=!options:%format%="(137/136/135/134/133/160)+bestaudio"! -k --exec "%this% transcode {} %format% & del {}"
echo.
youtube-dl%options% -o %output_file% %input_url:escape_ampersand=^&% --external-downloader aria2c --no-cache-dir --no-check-certificate --external-downloader-args "--max-connection-per-server=16 --remote-time=true"
rd TV>nul 2>&1
echo.
popd
goto youtube-dl_input_url

:end
endlocal
