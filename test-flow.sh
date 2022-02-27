#!/bin/bash

set -euxo

acc_name="gen_$(openssl rand -hex 12 | head -c 8)"
amount="CHF:10.50"

bank_cmd="
  echo \"Creating account with name $acc_name\"
  taler-bank-manage django add_bank_account $acc_name --public
  taler-bank-manage django changepassword_unsafe $acc_name $acc_name
  taler-bank-manage django top_up $acc_name CHF:100
"
docker exec bank /bin/sh -c "$bank_cmd"


create_reserve_cmd="
  rm -f ~/.talerwalletdb.json && taler-wallet-cli advanced withdraw-manually --exchange http://exchange:5890/ --amount $amount | sed -n \"s/^Created reserve \(\S*\)$/\1/p\"
"
reserve=$(docker exec cli /bin/sh -c "$create_reserve_cmd")


wire_cmd="
  echo \"Wire to reserve $acc_name\"
  taler-bank-manage django wire_transfer $acc_name $acc_name Exchange $reserve $amount
"
docker exec bank /bin/sh -c "$wire_cmd"

echo "Withdraw coins to wallet"
docker exec cli taler-wallet-cli --no-throttle run-pending --no-throttle 

echo "Check Wallet balance"
docker exec cli taler-wallet-cli --no-throttle balance

order=$(curl 'http://merchant:8888/instances/default/private/orders' \
    -s -d '{"order":{"amount":"CHF:1","summary":"Kafi"}}' \
)

order_id=$(echo "$order" | jq -e -r .order_id)

order_status_json=$(curl "http://merchant:8888/instances/default/private/orders/${order_id}" -s)
pay_url=$(echo "$order_status_json" | jq -e -r .taler_pay_uri)

# FIXME: why does it say insufficient balance here?
pay_cmd="taler-wallet-cli --no-throttle handle-uri "${pay_url}" -y"
docker exec cli /bin/sh -c "$pay_cmd"
