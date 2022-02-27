FROM ubuntu:focal 

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    apt-utils \
    gnupg2 \
    curl \
    git \
    gradle \
    openjdk-11-jdk

# PF certificates
RUN mkdir /tmp/pfcerts && \
    curl --silent --insecure https://repo.pnet.ch/artifactory/linux-generic-local/certificates/pki-all.tar | tar -C /tmp/pfcerts -x && \
    cd /tmp/pfcerts && \
    for f in *.pem; do mv -- "$f" "${f%.pem}.crt"; done && \
    mv *.crt /usr/local/share/ca-certificates && \
    cd ~ && \
    rm -rf /tmp/pfcerts && \
    update-ca-certificates

#RUN curl https://taler.net/taler-systems.gpg.key | gpg --dearmor > /usr/share/keyrings/taler-systems-keyring.gpg && \
#    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/taler-systems-keyring.gpg] https://deb.taler.net/apt/ubuntu focal-fossa main" >> /etc/apt/sources.list.d/taler.list  && \
#   apt-get update

RUN git clone https://git.taler.net/wallet-kotlin.git 
#    cd wallet-kotlin && \
#    ./gradlew
