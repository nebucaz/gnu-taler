#!/bin/bash
set -eux

# "http://10.0.2.2:3128/"
export LOCAL_PROXY="http://host.docker.internal:3128"

echo "#==> adding proxy..." && sleep 1
tee /tmp/proxy.sh << EOF
export http_proxy="${LOCAL_PROXY}"
export https_proxy="${LOCAL_PROXY}"
export ftp_proxy="${LOCAL_PROXY}"
export no_proxy="localhost,127.0.0.*,10.*,192.168.*,*.pnet.ch,*.post.ch,*.postfinance.ch,exchange,db-exchange,bank,db-bank,merchant,db-merchant"

export HTTP_PROXY="${LOCAL_PROXY}"
export HTTPS_PROXY="${LOCAL_PROXY}"
export FTP_PROXY="${LOCAL_PROXY}"
export NO_PROXY="localhost,127.0.0.*,10.*,192.168.*,*.pnet.ch,*.post.ch,*.postfinance.ch,exchange,db-exchange,bank,db-bank,merchant,db-merchant"
EOF
source /tmp/proxy.sh

curl -v https://www.wordpress.org
