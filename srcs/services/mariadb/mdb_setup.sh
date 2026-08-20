#!/bin/bash
echo "mariadb setup script..."

# decide if its necessary to check for the mysql/mysql directory???
# if not, just install right away

# see if any more flags are necessary
# mariadb-install-db

# decide if service start is enough or if its better to mariadbd-safe
# service mariadb start
# mariadbd-safe --port=3306 --bind-address=0.0.0.0 --datadir=/var/lib/mysql

# see if waiting for mariadb being up is needed



# decide if its necessary to check for the DATABASE directory
# if not, just create and setup everything right away
# also decide if -u root is needed

echo "creating database."
# mariadb -u root -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
# mariadb -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"

echo "taking care of user settings."
# mariadb -u root -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
# mariadb -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"

# mariadb -u root -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';"
# mariadb -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO \`${MYSQL_USER}\`@'%';"

# decide if its necessary to alter user root???
# mariadb -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"

# decide if flush is needed
# mariadb -e "FLUSH PRIVILEGES;"

# mariadb-admin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

# see if waiting for shutdown is needed


echo "starting mariadb!!"

# see if the mariadb-safe version works
# mariadbd-safe --port=3306 --bind-address=0.0.0.0 --datadir=/var/lib/mysql
# mysqld_safe --port=3306 --bind-address=0.0.0.0 --datadir=/var/lib/mysql
