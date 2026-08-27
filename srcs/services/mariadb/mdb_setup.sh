#!/bin/bash

# if the new database hasn't been created yet
if ! [ -d "/var/lib/mysql/$DATABASE_NAME" ];
then
	echo "first start up!!"
	echo "starting mariadb to begin setup..."

	# start mdb as a background process
	mariadbd-safe --port=$DATABASE_PORT --bind-address=0.0.0.0 --datadir=/var/lib/mysql --socket=/run/mysqld/mysqld.sock &
	background_mdb_pid="$!"

    until mariadb-admin ping --silent;
	do
        echo "waiting ping..."
        sleep 1
    done

    echo "mariadb has started"
	echo "beggining setup..."

	echo "creating database..."
	mariadb -e "CREATE DATABASE IF NOT EXISTS $DATABASE_NAME;"

	MDB_PASS=$(cat /run/secrets/mdb_pass)
	MDB_ROOT_PASS=$(cat /run/secrets/mdb_root_pass)

	# create new user, give priveleges to user, apply privilege changes
	echo "taking care of user settings..."
	mariadb -e "
	CREATE USER IF NOT EXISTS '${DATABASE_USER}'@'%' IDENTIFIED BY '${MDB_PASS}';
	GRANT ALL PRIVILEGES ON $DATABASE_NAME.* TO '${DATABASE_USER}'@'%';
	FLUSH PRIVILEGES;"
	
	echo "finished setup!"
	echo "shutting down mariadb to restart..."

	mariadb-admin -u root -p"${MDB_ROOT_PASS}" shutdown
	wait "$background_mdb_pid"
fi

# !! ISSUE HERE: NOT EXITING GRACEFULLY
echo "starting mariadb!!"
exec mariadbd-safe --port=$DATABASE_PORT --bind-address=0.0.0.0 --datadir=/var/lib/mysql --socket=/run/mysqld/mysqld.sock
