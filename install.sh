#!/usr/bin/bash
set -euxo

if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run as root." >&2
   exit 1
fi

if [ -z ${INSTALL_USER+x} ]; then
  echo "Please specify INSTALL_USER" >&2
  exit 1
fi

echo "installing for user ${INSTALL_USER}"

# "http://10.0.2.2:3128/"
export LOCAL_PROXY=""

#echo "#==> adding PF certificates..." && sleep 1
#mkdir /tmp/pfcerts
#curl --silent --insecure https://repo.pnet.ch/artifactory/linux-generic-local/certificates/pki-all.tar | tar -C /tmp/pfcerts -x
#cd /tmp/pfcerts
#for f in *.pem; do mv -- "$f" "${f%.pem}.crt"; done
#mv *.crt /usr/local/share/ca-certificates
#cd ~
#rm -rf /tmp/pfcerts
update-ca-certificates

echo "#==> adding proxy..." && sleep 1
tee /etc/profile.d/proxy.sh << EOF
export http_proxy="${LOCAL_PROXY}"
export https_proxy="${LOCAL_PROXY}"
export ftp_proxy="${LOCAL_PROXY}"
export no_proxy="localhost,127.0.0.*,10.*,192.168.*,*.pnet.ch,*.post.ch,*.postfinance.ch,exchange,db-exchange,bank,db-bank,merchant,db-merchant"

export HTTP_PROXY="${LOCAL_PROXY}"
export HTTPS_PROXY="${LOCAL_PROXY}"
export FTP_PROXY="${LOCAL_PROXY}"
export NO_PROXY="localhost,127.0.0.*,10.*,192.168.*,*.pnet.ch,*.post.ch,*.postfinance.ch,exchange,db-exchange,bank,db-bank,merchant,db-merchant"
EOF
source /etc/profile.d/proxy.sh

echo "#==> adding taler repo..." && sleep 1
curl https://taler.net/taler-systems.gpg.key | gpg --dearmor > /usr/share/keyrings/taler-systems-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/taler-systems-keyring.gpg] https://deb.taler.net/apt/ubuntu focal-fossa main" >> /etc/apt/sources.list.d/taler.list

echo "#==> apt update && install..." && sleep 1
apt-get update
apt-get install -y \
  virtualbox-guest-utils \
  virtualbox-guest-dkms \
  docker-compose \
  jq \
  taler-wallet-cli

echo "#==> update docker-compose to v1.29.2..." && sleep 1
curl -sSL https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "#==> docker configs..." && sleep 1
systemctl start docker
systemctl enable docker
usermod -aG docker ${INSTALL_USER}

#   "registry-mirrors": [
#     "https://docker-remote.repo.pnet.ch"
#  ],

tee /etc/docker/daemon.json << EOF
{
  "bip": "10.127.1.1/24",
  "insecure-registries": [],
  "debug": true,
  "experimental": true
}
EOF

sudo -u ${INSTALL_USER} mkdir -p "/home/${INSTALL_USER}/.docker"
sudo -u ${INSTALL_USER} tee /home/${INSTALL_USER}/.docker/config.json << EOF
{
 "proxies":
 {
   "default":
   {
     "httpProxy": "${LOCAL_PROXY}",
     "httpsProxy": "${LOCAL_PROXY}",
     "noProxy": "localhost,127.0.0.*,10.*,192.168.*,172.*,*.pnet.ch,*.post.ch,*.postfinance.ch,exchange,db-exchange,bank,db-bank,merchant,db-merchant"
   }
 }
}
EOF

systemctl restart docker

echo "127.0.0.1 localhost exchange db-exchange bank db-bank merchant db-merchant" >> /etc/hosts

echo "#==> Building Docker images and starting db-exchange..." && sleep 1
cd "/home/${INSTALL_USER}/gnu-taler-docker/base" && sudo -u ${INSTALL_USER} docker build -t taler-base:latest .
cd "/home/${INSTALL_USER}/gnu-taler-docker" && sudo -u ${INSTALL_USER} docker-compose build
cd "/home/${INSTALL_USER}/gnu-taler-docker" && sudo -u ${INSTALL_USER} docker-compose up -d

echo "#==> Docker up & running..."
echo "#==> Success! Don't forget to setup VirtualBox port mappings to access Services directly from your native host."
