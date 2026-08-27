#!/bin/bash

# if the new database hasn't been created yet
if ! [ -d "/var/lib/mysql/$DATABASE_NAME" ]; # ----- hard coded, change later
then
	echo "first start up!!"
	echo "starting mariadb to begin setup..."

	# start mdb as a background process
	mariadbd-safe --port=$DATABASE_PORT --bind-address=0.0.0.0 --datadir=/var/lib/mysql --socket=/run/mysqld/mysqld.sock & # ----- hard coded, change later
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
	mariadb -e "CREATE DATABASE IF NOT EXISTS $DATABASE_NAME;" # ----- hard coded, change later

	# create new user, give priveleges to user, apply privilege changes
	echo "taking care of user settings..."
	mariadb -e "
	CREATE USER IF NOT EXISTS $DATABASE_USER@'%' IDENTIFIED BY '123'; # ----- hard coded, change later
	GRANT ALL PRIVILEGES ON $DATABASE_NAME.* TO $DATABASE_USER@'%';  # ----- hard coded, change later
	FLUSH PRIVILEGES;"
	
	echo "finished setup!"
	echo "shutting down mariadb to restart..."

	mariadb-admin -u root -p"123456" shutdown
	wait "$background_mdb_pid"
fi

# !! ISSUE HERE: NOT EXITING GRACEFULLY
echo "starting mariadb!!"
exec mariadbd-safe --port=$DATABASE_PORT --bind-address=0.0.0.0 --datadir=/var/lib/mysql --socket=/run/mysqld/mysqld.sock # ----- hard coded, change later
