#!/bin/bash
set -euxo

n=0
until [ "$n" -ge 10 ]
do
  taler-bank-manage django provide_accounts && c=0 && break
  c=$?
  n=$((n+1))
  echo "#==> Not ready, retry in 5 seconds..." && sleep 5
done

if [ $c -ne 0 ]; then
  echo "#==> Probably database was not ready, aborting."
  exit 1
fi

# set password for the exchange bank-account
# can not be run at build time because database is not yet available
taler-bank-manage django changepassword_unsafe Exchange Exchange
taler-bank-manage django add_bank_account Shop
taler-bank-manage django changepassword_unsafe Shop Shop

taler-bank-manage serve
