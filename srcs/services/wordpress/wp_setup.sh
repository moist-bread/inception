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
	# ----- hard coded, change later
	wp config create \
		--allow-root \
		--dbname=$DATABASE_NAME \
		--dbuser=$DATABASE_USER \
		--dbpass=123 \
		--dbhost=mariadb:3306
	
	# ----- hard coded, change later
	# !! ISSUE: correct server_name not working yet 
	wp core install \
		--allow-root \
		--url=localhost \
		--title=$TITLE \
		--admin_user=$WP_ADMIN \
		--admin_password=manager123 \
		--admin_email=$WP_ADMIN_EMAIL \
		--skip-email
	
	# ----- hard coded, change later
	wp user create $WP_USER $WP_USER_EMAIL \
		--allow-root \
		--user_pass="visitor456" \
		--role=author 
	
	wp theme install twentyten --allow-root --activate # ----- hard coded, change later
fi

echo "starting wordpress!!"
exec php-fpm8.2 -F
