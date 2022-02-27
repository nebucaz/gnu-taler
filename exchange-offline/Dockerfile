FROM taler-base:latest

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y taler-exchange-offline gosu

VOLUME ["/etc/taler", "/var/lib/taler/exchange-offline"]

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/bin/bash"]
