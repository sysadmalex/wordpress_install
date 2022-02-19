#!/bin/bash


# Задаём переменные для базы
DBNAME=basename
DBUSER=username
DBPASS=password
ROOTPASS=password # Пароль root mariaDB
DBDIR=/var/lib/mysql/


# Переменные для wp-cli.
DBPREFIX=prefix_
DBHOST=localhost
URL=http://localhost
TITLE=sitetitle

# Данные для входа на сайт
ADMINUSER=username
ADMINPASS=password
ADMINEMAIL=admin@localsite.com

# Переменные каталогов сайта
SITEDIR=/var/www/localsite/public
LOGDIR=/var/www/localsite/logs


# Создание базы
mysql -u root -p"$ROOTPASS" -e "create database "$DBNAME"; grant all on "$DBNAME".* to "$DBUSER"@'localhost'; flush privileges;"

# Создание каталогов
mkdir -p "$SITEDIR"
mkdir "$LOGDIR"

# Установка wordpress с помощью wp-cli
cd "$SITEDIR"
wp core config --dbname="$DBNAME" --dbuser="$DBUSER" --dbpass="$DBPASS" --dbhost="$DBHOST" --dbprefix="$DBPREFIX" --locale=ru_RU --allow-root
wp core install --url="$URL" --title="$TITLE" --admin_user="$ADMINUSER" --admin_password="$ADMINPASS" --admin_email="$ADMINEMAIL" --allow-root
wp rewrite structure "/%postname%/" --allow-root
wp rewrite flush --allow-root

#Назначаем права доступа
chown -R nginx:nginx "$SITEDIR"
chmod 775 "$SITEDIR"

----------
#Перегружаем веб сервер
systemctl restart nginx
