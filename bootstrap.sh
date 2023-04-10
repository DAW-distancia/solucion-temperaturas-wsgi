#!/usr/bin/env bash

# Instalación básica (+wsgi)
apt-get update
apt-get install -y apache2 python3-venv git libapache2-mod-wsgi-py3 

# Preparación de la web
cd /var/www
git clone https://github.com/lmorillas/flask_temperaturas.git
cd flask_temperaturas
python3 -m venv env   # Crea un entorno virtual
source env/bin/activate  # Activa el entorno virtual
pip install -r requirements.txt

# creación wsgi.py
cat <<EOF > wsgi.py
from app import app as application

EOF

# Configuración de apache default. Añadimos las líneas al default.
cat <<EOF >> /etc/apache2/sites-available/000-default.conf
    WSGIDaemonProcess flask_temp python-path=/var/www/flask_temperaturas:/var/www/flask_temperaturas/env/lib/python3.10/site-packages
    WSGIProcessGroup flask_temp
    WSGIScriptAlias / /var/www/flask_temperaturas/wsgi.py process-group=flask_temp
    <Directory /var/www/flask_temperaturas>
            Require all granted
    </Directory>
EOF

# Permisos para apache
chown -R www-data:www-data /var/www/flask_temperaturas

# Reinicio apache 
systemctl restart apache2


