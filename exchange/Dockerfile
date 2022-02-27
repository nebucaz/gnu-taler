FROM taler-base:latest

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    nginx \
    taler-exchange \
    taler-exchange-offline \
    taler-wallet-cli \
    gosu \
    jq \
    wget

VOLUME ["/etc/taler"]

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
