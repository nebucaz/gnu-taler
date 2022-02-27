#!/bin/bash
set -x

chown -R taler-exchange-offline /var/lib/taler/exchange-offline/

if [[ -z "$TALER_MASTER_PUBLIC_KEY" ]]; then
  export TALER_MASTER_PUBLIC_KEY=$(gosu taler-exchange-offline taler-exchange-offline setup)
  export TALER_NEEDS_SIGNING=1
fi

taler-config -c /etc/taler/taler.conf -s exchange -o MASTER_PUBLIC_KEY -V $TALER_MASTER_PUBLIC_KEY
taler-config -c /etc/taler/taler.conf -s exchange -o BASE_URL -V $TALER_EXCHANGE_BASE_URL
taler-config -c /etc/taler/taler.conf -s exchangedb-postgres -o CONFIG -V $TALER_EXCHANGEDB_POSTGRES_CONFIG

echo "### /etc/taler/taler.conf <<<"
cat /etc/taler/taler.conf
echo ">>> /etc/taler/taler.conf ###"

mkdir -p /run/taler/exchange-httpd
mkdir -p /run/taler/exchange-secmod-eddsa
mkdir -p /run/taler/exchange-secmod-rsa

chown -R taler-exchange-httpd:www-data /run/taler/exchange-httpd
chown -R taler-exchange-secmod-eddsa:taler-exchange-secmod /run/taler/exchange-secmod-eddsa
chown -R taler-exchange-secmod-rsa:taler-exchange-secmod /run/taler/exchange-secmod-rsa

mkdir -p /var/lib/taler/exchange-secmod-eddsa
mkdir -p /var/lib/taler/exchange-secmod-rsa

chown -R taler-exchange-secmod-eddsa:taler-exchange-secmod /var/lib/taler/exchange-secmod-eddsa
chown -R taler-exchange-secmod-rsa:taler-exchange-secmod /var/lib/taler/exchange-secmod-rsa

n=0
until [ "$n" -ge 10 ]
do
  gosu taler-exchange-httpd taler-exchange-dbinit && c=0 && break
  c=$?
  n=$((n+1))
  echo "#==> Not ready, retry in 5 seconds..." && sleep 5
done

if [ $c -ne 0 ]; then
  echo "#==> Probably database was not ready, aborting."
  exit 1
fi

echo 'GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA public TO "taler-exchange-aggregator";' | gosu taler-exchange-httpd psql "$TALER_EXCHANGEDB_POSTGRES_CONFIG"
echo 'GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA public TO "taler-exchange-closer";' | gosu taler-exchange-httpd psql "$TALER_EXCHANGEDB_POSTGRES_CONFIG"
echo 'GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA public TO "taler-exchange-wire";' | gosu taler-exchange-httpd psql "$TALER_EXCHANGEDB_POSTGRES_CONFIG"
echo 'GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO "taler-exchange-aggregator";' | gosu taler-exchange-httpd psql "$TALER_EXCHANGEDB_POSTGRES_CONFIG"
echo 'GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO "taler-exchange-closer";' | gosu taler-exchange-httpd psql "$TALER_EXCHANGEDB_POSTGRES_CONFIG"
echo 'GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO "taler-exchange-wire";' | gosu taler-exchange-httpd psql "$TALER_EXCHANGEDB_POSTGRES_CONFIG"

# beign able to write to /dev/stdout not only by root user
# https://github.com/moby/moby/issues/31243
chmod o+w /dev/stdout
chmod o+w /dev/stderr

ln -sf /dev/stdout /var/log/nginx/access.log
ln -sf /dev/stderr /var/log/nginx/error.log

ln -sf /dev/stdout /var/log/taler-exchange-secmod-rsa.log
ln -sf /dev/stdout /var/log/taler-exchange-secmod-eddsa.log
ln -sf /dev/stdout /var/log/taler-exchange-wirewatch.log
ln -sf /dev/stdout /var/log/taler-exchange-transfer.log
ln -sf /dev/stdout /var/log/taler-exchange-aggregator.log
ln -sf /dev/stdout /var/log/taler-exchange-closer.log

gosu taler-exchange-secmod-rsa taler-exchange-secmod-rsa -c /etc/taler/taler.conf --log=TRACE --logfile=/var/log/taler-exchange-secmod-rsa.log &
gosu taler-exchange-secmod-eddsa taler-exchange-secmod-eddsa -c /etc/taler/taler.conf --log=TRACE --logfile=/var/log/taler-exchange-secmod-eddsa.log &
gosu taler-exchange-wire taler-exchange-wirewatch -c /etc/taler/taler.conf --log=TRACE --logfile=/var/log/taler-exchange-wirewatch.log &
gosu taler-exchange-wire taler-exchange-transfer -c /etc/taler/taler.conf --log=TRACE --logfile=/var/log/taler-exchange-transfer.log &
gosu taler-exchange-aggregator taler-exchange-aggregator -c /etc/taler/taler.conf --log=TRACE --logfile=/var/log/taler-exchange-aggregator.log &
gosu taler-exchange-closer taler-exchange-closer -c /etc/taler/taler.conf --log=TRACE --logfile=/var/log/taler-exchange-closer.log &

nginx -g "daemon off;" &

if [[ -n "$TALER_NEEDS_SIGNING" ]]; then
  {
    while :; do
      echo "#==> $(date) Ensure future_denoms are ready to sign..." && sleep 10
      c=$(taler-exchange-offline download > /tmp/sig-request.json)
      if [ $? -ne 0 ]; then
        echo "#==> $(date) Download failed, retry..."
      else
        echo "#==> $(date) Download success, checking future_denoms size now..."
        (( $(jq '.arguments.future_denoms | length' /tmp/sig-request.json) < 1 )) || break
      fi
    done

    echo "#==> Great, now sign it with taler-exchange-offline!"
    gosu taler-exchange-offline taler-exchange-offline sign < /tmp/sig-request.json > /tmp/sig-response.json
    gosu taler-exchange-offline taler-exchange-offline enable-account payto://x-taler-bank/bank:5882/Exchange > /tmp/acct-response.json
    gosu taler-exchange-offline taler-exchange-offline wire-fee 2022 x-taler-bank CHF:0 CHF:0 > /tmp/fee-response.json

    echo "#==> Great, now finally upload the signed responses!"
    taler-exchange-offline upload < /tmp/sig-response.json
    taler-exchange-offline upload < /tmp/acct-response.json
    taler-exchange-offline upload < /tmp/fee-response.json

    echo "#==> Linting, should now succeed without any errors..."
    taler-wallet-cli deployment lint-exchange
  } &
fi

# enable this line when we are sure that it works
# for f in /signed-responses/*.json; do taler-exchange-offline upload < "$f"; done

# did not manage to get the socket working... however, we can directly connect to localhost:8081 via nginx
# socat UNIX-LISTEN:/run/taler/exchange-httpd/exchange-http.sock,reuseaddr,mode=660,user=taler-exchange-httpd,group=www-data - &

ln -sf /dev/stdout /var/log/taler-exchange-httpd.log
gosu taler-exchange-httpd taler-exchange-httpd -c /etc/taler/taler.conf --log=TRACE --logfile=/var/log/taler-exchange-httpd.log
