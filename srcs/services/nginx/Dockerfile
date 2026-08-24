ARG VERSION=oldstable
FROM debian:${VERSION}

RUN apt-get -y update && \
	apt-get install -y --no-install-recommends \
	nginx \
	openssl

# RUN rm /etc/nginx/conf.d/default.conf

COPY content /usr/share/nginx/html
COPY conf /etc/nginx

EXPOSE 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]