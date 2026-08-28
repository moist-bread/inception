ARG VERSION=oldstable
FROM debian:${VERSION}

ARG TARGETPLATFORM
RUN echo "MariaDB is being built for $TARGETPLATFORM"

RUN apt-get -y update && \
	apt-get install -y --no-install-recommends mariadb-server

COPY --chmod=+x mdb_setup.sh /usr/local/bin/

# garantee that the config and socket folder exist
# and have the correct permissions for mariadb to be able
# to create the needed files on reboot
RUN mkdir -p /run/mysqld && \
	chown -R mysql:mysql /var/lib/mysql && \
	chown -R mysql:mysql /run/mysqld

EXPOSE 3306

#ENTRYPOINT ["/usr/local/bin/mdb_setup.sh"]

# debug version
ENTRYPOINT ["bash", "-x", "/usr/local/bin/mdb_setup.sh"]
