#!/usr/bin/env bash

# Instalación básica (+wsgi)
apt-get update
apt-get install -y apache2 python3-venv git libapache2-mod-wsgi-py3
# para mysqlclient
apt-get install -y python3-dev default-libmysqlclient-dev build-essential

#Inicio mysql

cp /vagrant/docker-compose.yml /home/vagrant/
cd /home/vagrant
docker-compose  up -d

# Preparación de la web
cd /var/www
git clone https://github.com/DAW-distancia/Weather-App.git
cd Weather-App
python3 -m venv env   # Crea un entorno virtual
source env/bin/activate  # Activa el entorno virtual
pip install -r requirements.txt

# creación wsgi.py
cat <<EOF > wsgi.py
from weather_app import app as application

EOF

# Configuración de apache default. Añadimos las líneas al default.
cat <<EOF >> /etc/apache2/sites-available/000-default.conf
    WSGIDaemonProcess flask_temp python-path=/var/www/Weather-App:/var/www/Weather-App/env/lib/python3.10/site-packages
    WSGIProcessGroup flask_temp
    WSGIScriptAlias / /var/www/Weather-App/wsgi.py process-group=flask_temp
    <Directory /var/www/Weather-App>
            Require all granted
    </Directory>
EOF

# Permisos para apache

chown -R www-data:www-data /var/www/Weather-App


# Reinicio apache 
systemctl restart apache2


