@echo off

set home_dir=%~dp0
if [%home_dir:~-1%] == [\] set home_dir=%home_dir:~0,-1%
set dependencies_dir=%home_dir%\Dependencies
set executable=%dependencies_dir%\%~n0%~x0
set parameters=%*

if defined parameters (
	set parameters=%parameters:&=escape_ampersand%
	cmd /c ""%executable%" %parameters:escape_ampersand=^&%"
	goto end
)

cmd /c ""%executable%""

:end
