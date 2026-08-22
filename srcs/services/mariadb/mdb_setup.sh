#!/bin/bash

# if the new database hasn't been created yet
if ! [ -d "/var/lib/mysql/wordpress" ]; # ----- hard coded, change later
then
	echo "first start up!!"
	echo "starting mariadb to begin setup..."

	# start mdb as a background process
	mariadbd-safe --port=3306 --bind-address=0.0.0.0 --datadir=/var/lib/mysql --socket=/run/mysqld/mysqld.sock & # ----- hard coded, change later
	background_mdb_pid="$!"

    until mariadb-admin ping --silent;
	do
        echo "waiting ping..."
        sleep 1
    done

    echo "mariadb has started"
	echo "beggining setup..."

	# !! decide if -u root is needed
	echo "creating database..."
	mariadb -e "CREATE DATABASE IF NOT EXISTS \`wordpress\`;" # ----- hard coded, change later

	# create new user, give priveleges to user, apply privilege changes
	echo "taking care of user settings..."
	mariadb -e "
	CREATE USER IF NOT EXISTS \`rduro-pe\`@'%' IDENTIFIED BY '123'; # ----- hard coded, change later
	GRANT ALL PRIVILEGES ON wordpress.* TO \`rduro-pe\`@'%';  # ----- hard coded, change later
	FLUSH PRIVILEGES;"
	
	echo "finished setup!"
	echo "shutting down mariadb to restart..."

	mariadb-admin -u root -p"123456" shutdown
	wait "$background_mdb_pid"
fi

echo "starting mariadb!!"
mariadbd-safe --port=3306 --bind-address=0.0.0.0 --datadir=/var/lib/mysql --socket=/run/mysqld/mysqld.sock # ----- hard coded, change later
