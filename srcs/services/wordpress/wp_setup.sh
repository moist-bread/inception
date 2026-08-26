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
		--dbname=wordpress \
		--dbuser=rduro-pe \
		--dbpass=123 \
		--dbhost=mariadb:3306
	
	# ----- hard coded, change later
	# !! ISSUE: correct server_name not working yet 
	wp core install \
		--allow-root \
		--url=localhost \
		--title=raquel-inception \
		--admin_user=manager \
		--admin_password=manager123 \
		--admin_email=manager@gmail.com \
		--skip-email
	
	# ----- hard coded, change later
	wp user create "visitor" "visitor@gmail.com" \
		--allow-root \
		--user_pass="visitor456" \
		--role=author 
	
	wp theme install twentyten --allow-root --activate
fi

echo "starting wordpress!!"
exec php-fpm8.2 -F
