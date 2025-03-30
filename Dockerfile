ARG NGINX_VERSION=1.26.1
FROM nginx:${NGINX_VERSION}-alpine
COPY ./cert /etc/cert
COPY ./conf/ /etc/nginx/
