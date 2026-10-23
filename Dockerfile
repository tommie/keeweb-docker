# KeeWeb Docker container
# https://keeweb.info
#
# Based on https://github.com/keeweb/keeweb/blob/v1.5.3/package/docker/Dockerfile
# Simplified to be hosted behind an external reverse proxy.
#
# (C) Antelle 2017, MIT license https://github.com/keeweb/keeweb

# Building locally:
# docker build -t keeweb .
# docker run --name keeweb -d -p 127.0.0.1:5680:80 keeweb

ARG nginx_ver=stable
FROM nginx:${nginx_ver}
MAINTAINER Tommie

# install
RUN apt-get -y update && apt-get -y install wget unzip && rm -fr /var/lib/apt/lists/*

# clone keeweb
# The refs can be branches or commit hashes, to pin what gets downloaded.
ARG keeweb_ref=gh-pages
RUN wget -O keeweb.zip "https://github.com/keeweb/keeweb/archive/${keeweb_ref}.zip" && \
    unzip keeweb.zip && \
    mv keeweb-*/* /usr/share/nginx/html && \
    rm -fr /usr/share/nginx/html/CNAME keeweb-* keeweb.zip

# clone keeweb plugins
ARG keeweb_plugins_ref=master
RUN wget -O keeweb-plugins.zip "https://github.com/keeweb/keeweb-plugins/archive/${keeweb_plugins_ref}.zip" && \
    unzip keeweb-plugins.zip && \
    mv keeweb-plugins-*/docs /usr/share/nginx/html/plugins && \
    rm -fr /usr/share/nginx/html/plugins/CNAME keeweb-plugins-* keeweb-plugins.zip

# Inject GDrive and OneDrive OAuth client IDs.
ARG gdriveclientid
ARG onedriveclientid

ADD config.json /usr/share/nginx/html/
RUN sed -i \
	-e 's;\("gdriveClientId":\s*\)null\(,\?\)$;\1"'"${gdriveclientid:-}"'"\2;' \
	-e 's;\("onedriveClientId":\s*\)null\(,\?\)$;\1"'"${onedriveclientid:-}"'"\2;' \
	/usr/share/nginx/html/config.json
RUN sed -i -e "s;(no-config);config.json;" /usr/share/nginx/html/index.html
