ARG VERSION=oldstable
FROM debian:${VERSION}

ARG TARGETPLATFORM
RUN echo "MariaDB is being built for $TARGETPLATFORM"

RUN apt-get -y update && \
	apt-get install -y --no-install-recommends mariadb-server

COPY --chmod=+x mdb_setup.sh /usr/local/bin/

EXPOSE 3306

# debug version
ENTRYPOINT ["bash", "-x", "/usr/local/bin/mdb_setup.sh"]

#ENTRYPOINT ["/usr/local/bin/mdb_setup.sh"]
