#!/bin/bash

MDB_PASS=$(cat /run/secrets/mdb_pass)

echo "waiting for needed database to be created..."

until mariadb -u"$DATABASE_USER" -p"$MDB_PASS" -P"$DATABASE_PORT" \
	-h"mariadb" -e \
	"SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA \
	WHERE SCHEMA_NAME = '$DATABASE_NAME';" > /dev/null;
do
	echo "waiting..."
	sleep 2
done

echo "database is present!!"

if ! [ -f /var/www/html/wordpress/wp-config.php ];
then
	echo "first wordpress start up!!"
	echo "installing and configuring worpress..."
	
	cd /var/www/html/wordpress

	WP_PASS=$(cat /run/secrets/wp_pass)
	WP_ADMIN_PASS=$(cat /run/secrets/wp_admin_pass)
	
	wp config create \
		--allow-root \
		--dbname=$DATABASE_NAME \
		--dbuser=$DATABASE_USER \
		--dbpass=$MDB_PASS \
		--dbhost=mariadb:$DATABASE_PORT
	
	wp core install \
		--allow-root \
		--url=$URL \
		--title=$TITLE \
		--admin_user=$WP_ADMIN \
		--admin_password=$WP_ADMIN_PASS \
		--admin_email=$WP_ADMIN_EMAIL \
		--skip-email
	
	wp user create $WP_USER $WP_USER_EMAIL \
		--allow-root \
		--user_pass=$WP_PASS \
		--role=author 
	
	wp theme install $THEME --allow-root --activate
fi

echo "starting wordpress!!"
exec php-fpm8.2 -F
