FROM ubuntu:focal

RUN apt update && \
    apt install -y --no-install-recommends \
    ca-certificates \
    build-essential \
    curl

# PF-Certs

ARG user=fuzzy
ENV HOME="/home/$user"
WORKDIR $HOME

# Install rust toolchain https://rustup.rs/
RUN curl -o rustup https://sh.rustup.rs && \
    chmod +x rustup && \
    ./rustup -y --default-toolchain stable --profile minimal  
ENV PATH="$HOME/.cargo/bin:$PATH"

# https://github.com/matusf/openapi-fuzzer
RUN mkdir -p api && \ 
    cargo install openapi-fuzzer 

#COPY *.yaml api/.

# debugging
#RUN apt install -y --no-install-recommends \
#    vim \
#    net-tools \
#    iputils-ping	

#CMD []
