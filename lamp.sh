#!/bin/bash
#actualizamos 
apt-get update
#instalamos apache
apt-get install apache2 -y
#instalar librerias de apache
apt-get install php libapache2-mod-php php-mysql -y
#instalar adminer
cd /var/www/html
mkdir adminer
cd adminer
wget https://github.com/vrana/adminer/releases/download/v4.7.3/adminer-4.7.3-mysql.php
mv adminer-4.7.3-mysql.php index.php
#instalar las debconf-utils
apt-get install debconf-utils -y
#configuramos la contraseña de root para mysql
DB_ROOT_PASSWD=root
debconf-set-selections <<< "mysql-server mysql-server/root_password password $DB_ROOT_PASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DB_ROOT_PASSWD"
#instalar mysql server
apt-get install mysql-server -y
#instalar git
apt-get install git -y
cd /var/www/html
rm -rf iaw-practica-lamp
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git
sudo chown www-data:www-data iaw-practica-lamp * -R
#configurar aplicaciones web
DB_NAME=lamp_db
DB_USER=lamp_user
DB_PASSWD=lamp_user
mysql -u root -p$DB_ROOT_PASSWD <<<"DROP DATABASE IF EXISTS $DB_NAME;"
mysql -u root -p$DB_ROOT_PASSWD <<<"CREATE DATABASE $DB_NAME;"
mysql -u root -p$DB_ROOT_PASSWD <<<"GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@'%' IDENTIFIED BY '$DB_PASSWD';"
mysql -u root -p$DB_ROOT_PASSWD <<<"FLUSH PRIVILEGES;"

mysql -u root -p$DB_ROOT_PASSWD < /var/www/html/iaw-practica-lamp/db/database.sql