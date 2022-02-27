#!/bin/sh
set -e

chown -R taler-exchange-offline /var/lib/taler/exchange-offline/
gosu taler-exchange-offline taler-exchange-offline setup

/bin/bash
