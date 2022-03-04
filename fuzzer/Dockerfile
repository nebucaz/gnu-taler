FROM ubuntu:focal

RUN apt update && \
    apt install -y --no-install-recommends \
    ca-certificates \
    curl

# PF-Certs

# Install rust toolchain https://rustup.rs/
RUN curl -o rustup https://sh.rustup.rs && \
    chmod +x rustup && \
    ./rustup -y --default-toolchain stable 

ENV PATH="$HOME/.cargo/bin:$PATH"
# --no-modify-path
# --default-toolchain nightly
# --profile minimal

# https://github.com/matusf/openapi-fuzzer
RUN cargo install openapi-fuzzer

COPY *.yaml .

# start with     
