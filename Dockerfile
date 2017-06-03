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

FROM nginx:stable
MAINTAINER Tommie

# install
RUN apt-get -y update && apt-get -y install wget unzip && rm -fr /var/lib/apt/lists/*

# clone keeweb
RUN wget https://github.com/keeweb/keeweb/archive/gh-pages.zip && \
    unzip gh-pages.zip && \
    mv keeweb-gh-pages/* /usr/share/nginx/html && \
    rm -fr /usr/share/nginx/html/CNAME keeweb-gh-pages gh-pages.zip

# clone keeweb plugins
RUN wget https://github.com/keeweb/keeweb-plugins/archive/master.zip && \
    unzip master.zip && \
    mv keeweb-plugins-master/docs /usr/share/nginx/html/plugins && \
    rm -fr /usr/share/nginx/html/plugins/CNAME keeweb-plugins-master master.zip

EXPOSE 80
