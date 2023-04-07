#!/bin/bash
# This pulls the newest version from github and
# adds updates the site on the server

cd /home/tomek/finance/
source env/bin/activate
./manage.py --version
git pull
pip install -r requirements.txt
./manage.py migrate
./manage.py collectstatic --noinput
sudo systemctl restart gunicorn
python3 manage.py check --deploy
deactivate

