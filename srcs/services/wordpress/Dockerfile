ARG VERSION=oldstable
FROM debian:${VERSION}

RUN apt-get -y update && \
	apt-get install -y --no-install-recommends \
	curl \
	php8.2 \
	php8.2-fpm \
	php8.2-mysql \
	ca-certificates \
	mariadb-client

# install wordpress' command-line interface
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

# download wordpress
RUN mkdir -p /var/www/html/wordpress
RUN wp core download --allow-root --path="/var/www/html/wordpress"

RUN mkdir -p /run/php

# edit the conf file to have the new port
RUN sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 9000|g' \
	/etc/php/8.2/fpm/pool.d/www.conf

COPY --chmod=+x wp_setup.sh /usr/local/bin/

EXPOSE 9000

#ENTRYPOINT ["/usr/local/bin/wp_setup.sh"]

# debug version
ENTRYPOINT ["bash", "-x", "/usr/local/bin/wp_setup.sh"]
