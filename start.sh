#!/bin/bash
set -ex

cd base && docker build -t taler-base:latest .
docker-compose build
docker-compose up -d
