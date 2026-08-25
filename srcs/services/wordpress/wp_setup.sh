#!/bin/bash

# ----- hard coded, change later
until mariadb -u"rduro-pe" -p"123" -P "3306" "$MYSQL_DATABASE" -e "SELECT wordpress;" >/dev/null 2>&1; do
    echo "Waiting for MariaDB..."
    sleep 1
done

if ! [ -f /var/www/html/wordpress/wp-config.php ];
then
	echo "first start up!!"
	echo "installing and configuring worpress..."
	
	# ----- hard coded, change later
	wp config create \
		--allow-root \
		--dbname=wordpress \
		--dbuser=rduro-pe \
		--dbpass=123456 \
		--dbhost=mariadb:3306
	
	# ----- hard coded, change later
	wp core install \
		--allow-root \
		--url=rduro-pe.42.fr \
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
