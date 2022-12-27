#!/usr/bin/env bash

echo "Installing/Updating virtualenvwrapper..."
pip install -U virtualenvwrapper
source `which virtualenvwrapper.sh`

VENV=`cat .venv`
echo "Activating ${VENV:-youtubedlapi-heroku-server-infusiblecoder} venv..."
if ! workon ${VENV:-youtubedlapi-heroku-server-infusiblecoder}; then
    echo "Building venv ${VENV:-youtubedlapi-heroku-server-infusiblecoder}..."
    mkvirtualenv ${VENV:-youtubedlapi-heroku-server-infusiblecoder} -r requirements-dev.txt -i virtualenvwrapper
fi

echo "Updating venv dev packages..."
pip-compile --generate-hashes requirements.in
pip-compile --generate-hashes requirements-dev.in

pip install -U pip
pip install -U -r requirements.txt
pip install -U -r requirements-dev.txt

echo "Updating project packages..."
pip-compile --upgrade --generate-hashes
pip-compile --upgrade --generate-hashes requirements.in
pip-compile --upgrade --generate-hashes requirements-dev.in
pipenv lock --clear

echo "Syncing venv with latest project packages..."
pip-sync  requirements.txt requirements-dev.txt

## test
echo "Starting webserver..."
honcho start web

echo "Exiting venv..."
deactivate

echo "Done."
