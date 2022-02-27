# gnu-taler-docker

## VirtualBox Port Forarding
- 5890 --> 5890 (exchange)
- 5882 --> 5886 (bank)
- 8888 --> 8888 (merchant)
- 8008 --> 8008 (wordpress shop)

## start
`./start.sh`

## Follow logs of all running containers 
`docker-compose logs --tail=0 --follow`

## sync to virtualbox
```shell
alias run_rsync='rsync -azP -e "ssh -p 3333" --exclude ".*/" --exclude ".*" --exclude "tmp/" . taler@localhost:~/gnu-taler-docker'
run_rsync; fswatch -o . | while read f; do run_rsync; done
```

## clean restart (resets volumes and containers)
```shell
docker rm -f $(docker ps -aq)
docker volume prune -f
./start.sh
```

## useful commands regarding Merchant / wiring
```shell
sudo -u taler-exchange-aggregator taler-exchange-aggregator -L DEBUG
sudo -u taler-exchange-closer taler-exchange-closer -L DEBUG
```
