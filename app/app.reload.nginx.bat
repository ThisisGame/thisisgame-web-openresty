cd  /d  %~dp0

set OPENRESTY_HOME=%~dp0../openresty-1.19.9.1-win64
set PATH=%PATH%;%OPENRESTY_HOME%

nginx -p %~dp0 -c conf/nginx_win_8000.conf -s reload

pause