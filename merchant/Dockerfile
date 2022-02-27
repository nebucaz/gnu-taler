#Download base image ubuntu 20.04
FROM taler-base:latest

# LABEL about the custom image
LABEL maintainer="olive.hofer@postfinance.ch"
LABEL version="0.1"
LABEL description="This is custom Docker Image for Taler Merchant"

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    TZ=Europe/Zurich \
    apt-get install -y --no-install-recommends \
    taler-merchant \
    supervisor \
    gosu

# taler-merchant installation already adds the user (?)
#RUN useradd -U -ms /bin/bash -u 1001 taler-merchant-httpd

RUN touch /var/log/taler-merchant.log \
    && chmod a+rw /var/log/taler-merchant.log

COPY docker-entrypoint.sh /usr/local/bin/

EXPOSE 8888
ENTRYPOINT ["docker-entrypoint.sh"]
