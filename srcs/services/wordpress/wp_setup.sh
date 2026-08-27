#!/bin/bash

# ----- hard coded, change later
# !! ISSUES HERE: "ERROR 2002 (HY000): Can't connect to server on 'localhost' (111)"
#mariadb -u"rduro-pe" -p"123" -P "3306" "wordpress" -e "SELECT 1;"
#until mariadb -u"rduro-pe" -p"123" -P "3306" "wordpress" -e "SELECT 1;" >/dev/null 2>&1; do
echo "Waiting for MariaDB..."
sleep 10
#done

if ! [ -f /var/www/html/wordpress/wp-config.php ];
then
	echo "first start up!!"
	echo "installing and configuring worpress..."
	
	cd /var/www/html/wordpress

	MDB_PASS=$(cat /run/secrets/mdb_pass)
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
