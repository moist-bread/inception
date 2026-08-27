#!/bin/bash

function pass_gen () { tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 3; }

cd ./srcs

if ! [ -d "./secrets" ];
then
	mkdir -p secrets

	echo -n $(pass_gen) > ./secrets/mdb_pass
	echo -n $(pass_gen) > ./secrets/mdb_root_pass
	echo -n $(pass_gen) > ./secrets/wp_pass
	echo -n $(pass_gen) > ./secrets/wp_admin_pass
fi

if ! [ -f "./.env" ];
then
	intra_user=rduro-pe

	echo DATABASE_NAME=wordpress >> ./.env
	echo DATABASE_PORT=3306 >> ./.env
	echo DATABASE_USER=db_$intra_user >> ./.env
	echo "" >> ./.env
	echo URL=$intra_user.42.fr >> ./.env
	echo TITLE=inception_$intra_user >> ./.env
	echo WP_ADMIN=manager >> ./.env
	echo WP_ADMIN_EMAIL=manager@mail.com >> ./.env
	echo WP_USER=visitor_$intra_user >> ./.env
	echo WP_USER_EMAIL=visitor@mail.com >> ./.env
	echo THEME=twentyten >> ./.env
fi
