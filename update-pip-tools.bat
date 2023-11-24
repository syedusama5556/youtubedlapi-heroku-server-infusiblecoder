@echo off

echo Installing/Updating virtualenvwrapper...
pip install -U virtualenvwrapper
call %VIRTUAL_ENV%\Scripts\activate.bat

set VENV=
for /F %%i in (.venv) do set VENV=%%i

echo Activating %VENV:-youtubedlapi-heroku-server-infusiblecoder% venv...
if not exist .\%VENV:-youtubedlapi-heroku-server-infusiblecoder% (
    echo Building venv %VENV:-youtubedlapi-heroku-server-infusiblecoder%...
    mkvirtualenv .\%VENV:-youtubedlapi-heroku-server-infusiblecoder% -r requirements-dev.txt -i virtualenvwrapper
)

echo Updating venv dev packages...
pip-compile --generate-hashes requirements.in
pip-compile --generate-hashes requirements-dev.in

pip install -U pip
pip install -U -r requirements.txt
pip install -U -r requirements-dev.txt

echo Updating project packages...
pip-compile --upgrade --generate-hashes
pip-compile --upgrade --generate-hashes requirements.in
pip-compile --upgrade --generate-hashes requirements-dev.in
pipenv lock --clear

echo Syncing venv with the latest project packages...
pip-sync  requirements.txt requirements-dev.txt

rem test
echo Starting webserver...
honcho start web

echo Exiting venv...
deactivate

echo Done.
