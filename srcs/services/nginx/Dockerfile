ARG VERSION=oldstable
FROM debian:${VERSION}

RUN apt-get -y update && \
	apt-get install -y --no-install-recommends \
	nginx \
	openssl

RUN mkdir /etc/nginx/ssl
RUN chmod 700 /etc/nginx/ssl

# -x509: requesting a self signed certificate
# -nodes: private key will not be encrypted
# -newkey: new cert and key
# -out, -keyout: output path for cert and key
# -subj: sends cert params instead of being prompted by command 
RUN openssl req -x509 \
	-nodes \
	-newkey rsa:2048 \
	-keyout /etc/nginx/ssl/ssl.key \
	-out /etc/nginx/ssl/ssl.pem \
	-subj "/C=PT/L=LX/O=42/CN=rduro-pe.42.fr"

COPY conf /etc/nginx

EXPOSE 443

ENTRYPOINT ["nginx", "-g", "daemon off;"]