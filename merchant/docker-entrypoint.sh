#!/bin/bash
set -x

taler-config -c /etc/taler/taler.conf -s merchant-exchange-1 -o MASTER_KEY -V $TALER_MASTER_PUBLIC_KEY

# FIXME wait for DB to start
sleep 15

# intialize database
gosu taler-merchant-httpd taler-merchant-dbinit -L DEBUG

# FIXME: Use supervisor to start service
gosu taler-merchant-httpd taler-merchant-httpd -L DEBUG -l /var/log/taler-merchant.log &

sleep 5

# initialize default instance
gosu taler-merchant-httpd curl -i -X POST http://localhost:8888/management/instances \
-H 'Content-Type: application/json'  \
-H "Authorization: Bearer secret-token:${TALER_MERCHANT_TOKEN}" \
-d '{
  "payto_uris": [
    "'"${TALER_PAY_TO_URI}"'"
  ],
  "id": "default",
  "name": "example.com",
  "address": {
    "country": "Switzerland"
  },
  "auth": {
    "method": "external"
  },
  "jurisdiction": {
    "country": "Switzerland"
  },
  "default_max_wire_fee": "CHF:1",
  "default_wire_fee_amortization": 100,
  "default_max_deposit_fee": "CHF:1",
  "default_wire_transfer_delay": {
    "d_ms": 600000
  },
  "default_pay_delay": {
    "d_ms": 600000
  }
}'

gosu taler-merchant-httpd tail -f /var/log/taler-merchant.log

#wait -n
#exit $?
