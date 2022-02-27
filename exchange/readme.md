# Exchange without Docker
Why? We are currently stuck with the `taler-exchange` dockerization, as we encounter errors with the `taler-exchange-secmod-rsa` process.
We are not able to upload the `sig-response.json`, see below. 

```text
> taler-exchange-offline upload < acct-response.json
# succcess...
> taler-exchange-offline upload < fee-response.json
# succcess...
> taler-exchange-offline upload < sig-response.json
 
INFO Restarting connection to RSA helper, did not come up properly
INFO Restarting connection to RSA helper, did not come up properly
INFO Restarting connection to RSA helper, did not come up properly
INFO Restarting connection to RSA helper, did not come up properly
 
# ... after 110 seconds:
 
WARNING `sendto' failed at taler-exchange-secmod-rsa.c:548 with error: No such file or directory
WARNING `sendto' failed at taler-exchange-secmod-rsa.c:548 with error: No such file or directory
WARNING `sendto' failed at taler-exchange-secmod-rsa.c:548 with error: No such file or directory
```

This is why we currently run the exchange directly inside an Ubuntu VM.

## Manual installation on guest VM
```sh
sudo apt install \
  nginx \
  postgresql \
  taler-exchange \
  taler-exchange-offline
```

Contents of `/etc/taler/taler.conf`
```text
[taler]
currency = CHF
currency_round_unit = CHF:0.01

[paths]
TALER_HOME = /var/lib/taler
TALER_RUNTIME_DIR = /run/taler
TALER_CACHE_HOME = /var/cache/taler
TALER_CONFIG_HOME = /etc/taler
TALER_DATA_HOME = /var/lib/taler

@inline-matching@ conf.d/*.conf
@inline@ overrides.conf
```

Contents of `/etc/taler/conf.d/exchange-coins.conf`, created with command `taler-wallet-cli deployment gen-coin-config --min-amount CHF:0.01 --max-amount CHF:100`
```text
[COIN-CHF-n1-t1644325802]
VALUE = CHF:0.01
DURATION_WITHDRAW = 7 days
DURATION_SPEND = 2 years
DURATION_LEGAL = 6 years
FEE_WITHDRAW = CHF:0
FEE_DEPOSIT = CHF:0.01
FEE_REFRESH = CHF:0
FEE_REFUND = CHF:0
RSA_KEYSIZE = 2048

[COIN-CHF-n2-t1644325802]
VALUE = CHF:0.02
DURATION_WITHDRAW = 7 days
DURATION_SPEND = 2 years
DURATION_LEGAL = 6 years
FEE_WITHDRAW = CHF:0
FEE_DEPOSIT = CHF:0.01
FEE_REFRESH = CHF:0
FEE_REFUND = CHF:0
RSA_KEYSIZE = 2048

[COIN-CHF-n3-t1644325802]
VALUE = CHF:0.04
DURATION_WITHDRAW = 7 days
DURATION_SPEND = 2 years
DURATION_LEGAL = 6 years
FEE_WITHDRAW = CHF:0
FEE_DEPOSIT = CHF:0.01
FEE_REFRESH = CHF:0
FEE_REFUND = CHF:0
RSA_KEYSIZE = 2048

[COIN-CHF-n4-t1644325802]
VALUE = CHF:0.08
DURATION_WITHDRAW = 7 days
DURATION_SPEND = 2 years
DURATION_LEGAL = 6 years
FEE_WITHDRAW = CHF:0
FEE_DEPOSIT = CHF:0.01
FEE_REFRESH = CHF:0
FEE_REFUND = CHF:0
RSA_KEYSIZE = 2048

[COIN-CHF-n5-t1644325802]
VALUE = CHF:0.16
DURATION_WITHDRAW = 7 days
DURATION_SPEND = 2 years
DURATION_LEGAL = 6 years
FEE_WITHDRAW = CHF:0
FEE_DEPOSIT = CHF:0.01
FEE_REFRESH = CHF:0
FEE_REFUND = CHF:0
RSA_KEYSIZE = 2048

[COIN-CHF-n6-t1644325802]
VALUE = CHF:0.32
DURATION_WITHDRAW = 7 days
DURATION_SPEND = 2 years
DURATION_LEGAL = 6 years
FEE_WITHDRAW = CHF:0
FEE_DEPOSIT = CHF:0.01
FEE_REFRESH = CHF:0
FEE_REFUND = CHF:0
RSA_KEYSIZE = 2048

[COIN-CHF-n7-t1644325802]
VALUE = CHF:0.64
DURATION_WITHDRAW = 7 days
DURATION_SPEND = 2 years
DURATION_LEGAL = 6 years
FEE_WITHDRAW = CHF:0
FEE_DEPOSIT = CHF:0.01
FEE_REFRESH = CHF:0
FEE_REFUND = CHF:0
RSA_KEYSIZE = 2048

[COIN-CHF-n8-t1644325802]
VALUE = CHF:1.28
DURATION_WITHDRAW = 7 days
DURATION_SPEND = 2 years
DURATION_LEGAL = 6 years
FEE_WITHDRAW = CHF:0
FEE_DEPOSIT = CHF:0.01
FEE_REFRESH = CHF:0
FEE_REFUND = CHF:0
RSA_KEYSIZE = 2048

[COIN-CHF-n9-t1644325802]
VALUE = CHF:2.56
DURATION_WITHDRAW = 7 days
DURATION_SPEND = 2 years
DURATION_LEGAL = 6 years
FEE_WITHDRAW = CHF:0
FEE_DEPOSIT = CHF:0.01
FEE_REFRESH = CHF:0
FEE_REFUND = CHF:0
RSA_KEYSIZE = 2048

[COIN-CHF-n10-t1644325802]
VALUE = CHF:5.12
DURATION_WITHDRAW = 7 days
DURATION_SPEND = 2 years
DURATION_LEGAL = 6 years
FEE_WITHDRAW = CHF:0
FEE_DEPOSIT = CHF:0.01
FEE_REFRESH = CHF:0
FEE_REFUND = CHF:0
RSA_KEYSIZE = 2048

[COIN-CHF-n11-t1644325802]
VALUE = CHF:10.24
DURATION_WITHDRAW = 7 days
DURATION_SPEND = 2 years
DURATION_LEGAL = 6 years
FEE_WITHDRAW = CHF:0
FEE_DEPOSIT = CHF:0.01
FEE_REFRESH = CHF:0
FEE_REFUND = CHF:0
RSA_KEYSIZE = 2048

[COIN-CHF-n12-t1644325802]
VALUE = CHF:20.48
DURATION_WITHDRAW = 7 days
DURATION_SPEND = 2 years
DURATION_LEGAL = 6 years
FEE_WITHDRAW = CHF:0
FEE_DEPOSIT = CHF:0.01
FEE_REFRESH = CHF:0
FEE_REFUND = CHF:0
RSA_KEYSIZE = 2048

[COIN-CHF-n13-t1644325802]
VALUE = CHF:40.96
DURATION_WITHDRAW = 7 days
DURATION_SPEND = 2 years
DURATION_LEGAL = 6 years
FEE_WITHDRAW = CHF:0
FEE_DEPOSIT = CHF:0.01
FEE_REFRESH = CHF:0
FEE_REFUND = CHF:0
RSA_KEYSIZE = 2048

[COIN-CHF-n14-t1644325802]
VALUE = CHF:81.92
DURATION_WITHDRAW = 7 days
DURATION_SPEND = 2 years
DURATION_LEGAL = 6 years
FEE_WITHDRAW = CHF:0
FEE_DEPOSIT = CHF:0.01
FEE_REFRESH = CHF:0
FEE_REFUND = CHF:0
RSA_KEYSIZE = 2048
```

Get (or generate) MASTER_PUBLIC_KEY to insert below
```sh
docker exec -it exchange-offline taler-exchange-offline setup
```

Contents of `/etc/taler/conf.d/exchange-business.conf`
```text
[exchange]
MASTER_PUBLIC_KEY = 0FRJDY9QQMHD5BJ3E09GBM7V2QWWSNGAE63ZFX1EEXZJY658FHTG
BASE_URL = http://exchange:5890/exchange/

[exchange-account-1]
enable_credit = yes
enable_debit = yes
payto_uri = payto://x-taler-bank/bank:5882/Exchange

@inline-secret@ exchange-accountcredentials-1 ../secrets/exchange-accountcredentials.secret.conf
```

Contents of `/etc/taler/secrets/exchange-accountcredentials.secret.conf`
```text
[exchange-accountcredentials-1]
wire_gateway_auth_method = basic
password = Exchange
username = Exchange
wire_gateway_url = http://bank:5882/taler-wire-gateway/Exchange/
```

Contents of `/etc/nginx/sites-available/taler-exchange.conf`
```text
server {
  listen 5890;
  listen [::]:5890;

  server_name localhost 127.0.0.1 exchange;

  location /exchange/ {
     proxy_pass http://unix:/run/taler/exchange-httpd/exchange-http.sock:/;
     proxy_redirect off;
     proxy_set_header Host $host;
  }
}
```
Ensure it is also linked under `sites-enabled`
```sh
sudo ln -s /etc/nginx/sites-available/taler-exchange /etc/nginx/sites-enabled/taler-exchange
sudo systemctl reload nginx
```

Contents of `/etc/hosts`
```text
127.0.0.1 localhost exchange db-exchange bank merchant

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```

Contents of `/etc/taler/secrets/exchange-db.secret.conf`
```text
[exchangedb-postgres]
CONFIG=postgres://user:pass@db-exchange/taler-exchange
```

Now, [init the database](https://docs.taler.net/taler-exchange-setup-guide.html#exchange-database-setup)
```sh
sudo -u taler-exchange-httpd taler-exchange-dbinit

sudo -u taler-exchange-httpd bash
echo 'GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA public TO "taler-exchange-aggregator";' | psql postgres://user:pass@db-exchange:15432/taler-exchange
echo 'GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA public TO "taler-exchange-closer";' | psql postgres://user:pass@db-exchange:15432/taler-exchange
echo 'GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA public TO "taler-exchange-wire";' | psql postgres://user:pass@db-exchange:15432/taler-exchange
echo 'GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO "taler-exchange-aggregator";' | psql postgres://user:pass@db-exchange:15432/taler-exchange
echo 'GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO "taler-exchange-closer";' | psql postgres://user:pass@db-exchange:15432/taler-exchange
echo 'GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO "taler-exchange-wire";' | psql postgres://user:pass@db-exchange:15432/taler-exchange
exit

sudo systemctl restart taler-exchange.target
```

Now, generate 
```sh
sudo taler-exchange-offline download > sig-request.json
docker cp sig-request.json exchange-offline:/root/

docker exec -it exchange-offline bash
cd /root
taler-exchange-offline setup
taler-exchange-offline sign < sig-request.json > sig-response.json
taler-exchange-offline enable-account payto://x-taler-bank/bank:5882/Exchange > acct-response.json
taler-exchange-offline wire-fee 2022 x-taler-bank CHF:0 CHF:0 > fee-response.json
exit

docker cp exchange-offline:/root/acct-response.json .
docker cp exchange-offline:/root/fee-response.json .
docker cp exchange-offline:/root/sig-response.json .

sudo taler-exchange-offline upload < acct-response.json
sudo taler-exchange-offline upload < fee-response.json
sudo taler-exchange-offline upload < sig-response.json
```

Taler wallet
```sh
# set password for User Exchange in Bank
docker exec -it bank taler-bank-manage django changepassword_unsafe Exchange Exchange

# now this command should return `End of transactions list.`
sudo taler-exchange-wire-gateway-client --section exchange-accountcredentials-1 --credit-history

# lint exchange
sudo taler-wallet-cli deployment lint-exchange | less

docker exec -it cli taler-wallet-cli advanced withdraw-manually --exchange http://exchange:5890/exchange/ --amount CHF:50.00
```

## Some encountered errors
```text
Feb 08 10:17:08 taler sudo[458310]:    taler : TTY=pts/2 ; PWD=/home/taler/gnu-taler-docker ; USER=root ; COMMAND=/usr/bin/taler-exchange-offline upload
Feb 08 10:17:08 taler sudo[458310]: pam_unix(sudo:session): session opened for user root by taler(uid=0)
Feb 08 10:17:08 taler kernel: taler-exchange-[457787]: segfault at 0 ip 000055b953f9da32 sp 00007ffcd53075d0 error 4 in taler-exchange-httpd[55b953f92000+1b000]
Feb 08 10:17:08 taler kernel: Code: ff ff 48 85 c0 74 71 48 8b 40 28 f3 0f 6f 45 00 48 89 e6 f3 0f 6f 4d 10 48 8b 78 18 0f 29 04 24 0f 29 4c 24 10 e8 1e 56 ff ff <48> 8b 38 48 8b 70 08 48 89 3b e8 6f 61 ff ff 48 8b 35 78 70 01 00
Feb 08 10:17:09 taler sudo[458310]: pam_unix(sudo:session): session closed for user root
Feb 08 10:17:09 taler systemd[1]: taler-exchange-httpd.service: Main process exited, code=dumped, status=11/SEGV
Feb 08 10:17:09 taler systemd[1]: taler-exchange-httpd.service: Failed with result 'core-dump'.
Feb 08 10:17:09 taler systemd[1]: taler-exchange-httpd.service: Scheduled restart job, restart counter is at 4.
Feb 08 10:17:09 taler systemd[1]: Stopped GNU Taler payment system exchange REST API.
Feb 08 10:17:09 taler systemd[1]: taler-exchange-httpd.socket: Succeeded.
Feb 08 10:17:09 taler systemd[1]: Closed Taler Exchange Socket.
Feb 08 10:17:09 taler systemd[1]: Stopping Taler Exchange Socket.
```

```text
root@d132060a9014:~# taler-exchange-offline sign < sig-request.json > sig-response.json
2022-02-08T13:07:32.893806+0000 taler-exchange-offline-54 WARNING External protocol violation detected at json_helper.c:89.
2022-02-08T13:07:32.894572+0000 taler-exchange-offline-54 ERROR Invalid input for denomination key to 'sign': value #2 at 0 (skipping)
{
  "value": "CHF:0.01",
  "stamp_start": {
    "t_ms": 1644309458000
  },
  "stamp_expire_withdraw": {
    "t_ms": 1644914258000
  },
  "stamp_expire_deposit": {
    "t_ms": 1707986258000
  },
  "stamp_expire_legal": {
    "t_ms": 1897202258000
  },
  "denom_pub": "040000XMHEXK40N1P6XV89V77DCKZ7P8ED1YEB1ZYY3CY9DER7WWTXWXS9EMGV89SRFPN3ZB177VRDMP41YJZG07CNM6PPANK29XPSEFQD6NYV0ZH3VARBRYNQKCRD7JCJVQ178N4Q1Z8TKS3SP2QDGK26282MESDSRNZXAYW4V7V3H50HW2N8W9ENVJW9FYHV167KZ0YVGXXX2S5DVD1BHGA6AH18KBXZGS678YNW165RDB1RNTF2XFA8EEE4YB9GW1HJN3FXBPR8QKY8F7ZKRRQZX4500TGG63PGRD1W7VRWBKEJMPVJ1ZDYTJ7WYCN348MHPKT8WXRQJH7SHNE5CVG0620GPBPJAKNDQVTJ12PFD5YMAA9AEYPBCGYD8294Y6HV5S583J4ZGYPSK5MFS975P25G6K04002",
  "fee_withdraw": "CHF:0",
  "fee_deposit": "CHF:0.01",
  "fee_refresh": "CHF:0",
  "fee_refund": "CHF:0",
  "denom_secmod_sig": "6HHHNDXGZVX8H8G68WF16EVXYBJCWG9KQQCFFE3GWHE89YFXR9FP83X0RYC9YMNFQFHTKR6ZF4A561X53PESEF5SGA98QQQ0XRD1E0G",
  "section_name": "COIN-CHF-n1-t1642628228"
}root@d132060a9014:~#
```

Why was linting first failing, a few minutes later succeeding?
```text
taler@taler:~/gnu-taler-docker/tmp$ sudo taler-wallet-cli deployment lint-exchange
2022-02-09T14:35:39.815Z taler-wallet-cli.ts TRACE running wallet-cli with [
  [
    "/usr/bin/node",
    "/usr/bin/taler-wallet-cli",
    "deployment",
    "lint-exchange"
  ]
]
warning: section EXCHANGE option BASE_URL: it is recommended to serve the exchange via HTTPS
2022-02-09T14:35:43.009Z NodeHttpLib.ts TRACE Requesting GET http://exchange/exchange/management/keys
2022-02-09T14:35:43.046Z NodeHttpLib.ts TRACE Requesting GET http://exchange/exchange/keys
error: request to /keys timed out. Make sure to sign and upload denomination and signing keys with taler-exchange-offline.
Aborting further checks.
taler@taler:~/gnu-taler-docker/tmp$ less /etc/taler/conf.d/exchange-
exchange-business.conf  exchange-coins.conf     exchange-system.conf
taler@taler:~/gnu-taler-docker/tmp$ less /etc/taler/conf.d/exchange-coins.conf
taler@taler:~/gnu-taler-docker/tmp$ sudo taler-wallet-cli deployment lint-exchange
2022-02-09T14:39:01.742Z taler-wallet-cli.ts TRACE running wallet-cli with [
  [
    "/usr/bin/node",
    "/usr/bin/taler-wallet-cli",
    "deployment",
    "lint-exchange"
  ]
]
warning: section EXCHANGE option BASE_URL: it is recommended to serve the exchange via HTTPS
2022-02-09T14:39:05.269Z NodeHttpLib.ts TRACE Requesting GET http://exchange/exchange/management/keys
2022-02-09T14:39:05.313Z NodeHttpLib.ts TRACE Requesting GET http://exchange/exchange/keys
2022-02-09T14:39:05.395Z NodeHttpLib.ts TRACE Requesting GET http://exchange/exchange/wire
Linting completed without errors.
```

First successful run of `taler-wallet-cli advanced withdraw-manually`
```text
taler@taler:~/gnu-taler-docker/tmp$ taler-wallet-cli advanced withdraw-manually --exchange http://exchange:5890/exchange/ --amount CHF:50.00
2022-02-09T14:44:42.172Z taler-wallet-cli.ts TRACE running wallet-cli with [
  [
    "/usr/bin/node",
    "/usr/bin/taler-wallet-cli",
    "advanced",
    "withdraw-manually",
    "--exchange",
    "http://exchange/exchange/",
    "--amount",
    "CHF:50.00"
  ]
]
2022-02-09T14:44:42.237Z headless/helpers.ts TRACE committing database
2022-02-09T14:44:42.249Z headless/helpers.ts WARN worker threads not available, falling back to synchronous workers
2022-02-09T14:44:42.263Z headless/helpers.ts TRACE committing database
2022-02-09T14:44:42.278Z exchanges.ts TRACE updating exchange info for http://exchange/exchange/
2022-02-09T14:44:42.301Z headless/helpers.ts TRACE committing database
2022-02-09T14:44:42.311Z exchanges.ts INFO updating exchange /keys info
2022-02-09T14:44:42.320Z NodeHttpLib.ts TRACE Requesting GET http://exchange/exchange/keys?cacheBreaker=3
2022-02-09T14:44:44.908Z exchanges.ts INFO received /keys response
2022-02-09T14:44:45.156Z exchanges.ts INFO updating exchange /wire info
2022-02-09T14:44:45.157Z NodeHttpLib.ts TRACE Requesting GET http://exchange/exchange/wire?cacheBreaker=3
2022-02-09T14:44:45.166Z exchanges.ts INFO validating exchange /wire info
2022-02-09T14:44:45.171Z exchanges.ts TRACE validating exchange acct
2022-02-09T14:44:45.346Z exchanges.ts INFO finished validating exchange /wire info
2022-02-09T14:44:45.347Z NodeHttpLib.ts TRACE Requesting GET http://exchange/exchange/terms?cacheBreaker=3
2022-02-09T14:44:45.353Z exchanges.ts TRACE updating exchange info in database
2022-02-09T14:44:45.362Z exchanges.ts TRACE updating denominations in database
2022-02-09T14:44:53.866Z exchanges.ts TRACE done updating denominations in database
2022-02-09T14:44:53.866Z exchanges.ts TRACE recoup list from exchange [
  []
]
2022-02-09T14:44:53.870Z headless/helpers.ts TRACE committing database
2022-02-09T14:44:54.086Z exchanges.ts TRACE done updating exchange info in database
2022-02-09T14:44:54.095Z withdraw.ts TRACE updating denominations used for withdrawal for http://exchange/exchange/
2022-02-09T14:44:54.129Z withdraw.ts TRACE getting candidate denominations
2022-02-09T14:44:54.159Z withdraw.ts TRACE got 14 candidate denominations
2022-02-09T14:44:54.159Z withdraw.ts TRACE Validating denomination (1/14) signature of 0284F8NHQ5MGANW51CJHDKJR5PRKCDPBZTTEV16PWT5JRYWTJ1FXCP7VPN9AE7SBZV4TAP932EAE0MAFVRZFD3PNG5DDD6BQ221VGHG
2022-02-09T14:44:54.214Z withdraw.ts TRACE Done validating 0284F8NHQ5MGANW51CJHDKJR5PRKCDPBZTTEV16PWT5JRYWTJ1FXCP7VPN9AE7SBZV4TAP932EAE0MAFVRZFD3PNG5DDD6BQ221VGHG
2022-02-09T14:44:54.214Z withdraw.ts TRACE Validating denomination (2/14) signature of 14QR32TWFH9TWJ413C6KVJ2C09M1KM3Y7ZK7E88EWGSBM18WSMWQ5REHMTB4D86TFPWRX60QBPD3FA330MMB704EMVQ4RNVFY2JEKR0
2022-02-09T14:44:54.235Z withdraw.ts TRACE Done validating 14QR32TWFH9TWJ413C6KVJ2C09M1KM3Y7ZK7E88EWGSBM18WSMWQ5REHMTB4D86TFPWRX60QBPD3FA330MMB704EMVQ4RNVFY2JEKR0
2022-02-09T14:44:54.236Z withdraw.ts TRACE Validating denomination (3/14) signature of 6HS1694YHF6MWWVZK20SKPVRSKR2QP9E8ZNM1V43YD58YY76412KM8SRCY5DTJ06E4QPVFA9BFH6BWMX4A8ETF1J2K5KY4NBYXVW34G
2022-02-09T14:44:54.262Z withdraw.ts TRACE Done validating 6HS1694YHF6MWWVZK20SKPVRSKR2QP9E8ZNM1V43YD58YY76412KM8SRCY5DTJ06E4QPVFA9BFH6BWMX4A8ETF1J2K5KY4NBYXVW34G
2022-02-09T14:44:54.262Z withdraw.ts TRACE Validating denomination (4/14) signature of 7F6PHA0G144FWFDJBFYJS4WKZXQK4XZ4HQFG4HK4YG2WNGK95GZCN235EPBWT66YQ7DND8ZT2GKK1YRS1W5D4MG7P2KN8Y912A633GR
2022-02-09T14:44:54.290Z withdraw.ts TRACE Done validating 7F6PHA0G144FWFDJBFYJS4WKZXQK4XZ4HQFG4HK4YG2WNGK95GZCN235EPBWT66YQ7DND8ZT2GKK1YRS1W5D4MG7P2KN8Y912A633GR
2022-02-09T14:44:54.290Z withdraw.ts TRACE Validating denomination (5/14) signature of 8P590T4F1CMV7PMJA6NJNC507H8VK5XBC7CGZBC00WPA6T3RQMH88TS6BJ54VDZH0347FJK46DQWV0P3EVEGSFJAYCHCSDYAZSE08JR
2022-02-09T14:44:54.310Z withdraw.ts TRACE Done validating 8P590T4F1CMV7PMJA6NJNC507H8VK5XBC7CGZBC00WPA6T3RQMH88TS6BJ54VDZH0347FJK46DQWV0P3EVEGSFJAYCHCSDYAZSE08JR
2022-02-09T14:44:54.311Z withdraw.ts TRACE Validating denomination (6/14) signature of 8Z136TMPQBENV593BGGSJ2G5WA7NZDJSN5CFET2TGYZC36EKEZKRN2501YWB5VQ409K9RRCJBKGDCNEZEYKA4T6A3M3Q2DTDJYK77BR
2022-02-09T14:44:54.336Z withdraw.ts TRACE Done validating 8Z136TMPQBENV593BGGSJ2G5WA7NZDJSN5CFET2TGYZC36EKEZKRN2501YWB5VQ409K9RRCJBKGDCNEZEYKA4T6A3M3Q2DTDJYK77BR
2022-02-09T14:44:54.336Z withdraw.ts TRACE Validating denomination (7/14) signature of 9SFZA9Z7E8939NPZCW0GJF84DG1KPA2S0AHKD13147J1X5G9V40E50SEKCRF7GYKSH4NR4Z9Z68S4RVQK3ZF7BFACC47BQ8WD8THB8R
2022-02-09T14:44:54.401Z withdraw.ts TRACE Done validating 9SFZA9Z7E8939NPZCW0GJF84DG1KPA2S0AHKD13147J1X5G9V40E50SEKCRF7GYKSH4NR4Z9Z68S4RVQK3ZF7BFACC47BQ8WD8THB8R
2022-02-09T14:44:54.404Z withdraw.ts TRACE Validating denomination (8/14) signature of CWXHQA3RT8PCAYCF3X0XJTNKVF9WQXEW8MBC94YKJFEZ05X807KES5PWCYT84HQ7P7PCY1PZAXX5H9DDMVE1AQQAEKYD2GZBTR0VAV8
2022-02-09T14:44:54.424Z withdraw.ts TRACE Done validating CWXHQA3RT8PCAYCF3X0XJTNKVF9WQXEW8MBC94YKJFEZ05X807KES5PWCYT84HQ7P7PCY1PZAXX5H9DDMVE1AQQAEKYD2GZBTR0VAV8
2022-02-09T14:44:54.426Z withdraw.ts TRACE Validating denomination (9/14) signature of D1S4RJNM23ZF3T5V9DPAY9CFNTM845XEAJ3C2AFEJSP4TVVJVJWARF1KVKXN6PQ88PDM3BRRVGE0GP958AQ8GTT5R3K7GEYCPKVYX6G
2022-02-09T14:44:54.454Z withdraw.ts TRACE Done validating D1S4RJNM23ZF3T5V9DPAY9CFNTM845XEAJ3C2AFEJSP4TVVJVJWARF1KVKXN6PQ88PDM3BRRVGE0GP958AQ8GTT5R3K7GEYCPKVYX6G
2022-02-09T14:44:54.454Z withdraw.ts TRACE Validating denomination (10/14) signature of KEBX9KQKSZMYVXB226K13XMXCC9WNHJ85CYGJ9WKHVTFJ7GQYY71KZ6C0PPTXP4BW7ZP43VBE0FBQ7HYX0ZEQXNDNE2F5ZNA7HG04HG
2022-02-09T14:44:54.479Z withdraw.ts TRACE Done validating KEBX9KQKSZMYVXB226K13XMXCC9WNHJ85CYGJ9WKHVTFJ7GQYY71KZ6C0PPTXP4BW7ZP43VBE0FBQ7HYX0ZEQXNDNE2F5ZNA7HG04HG
2022-02-09T14:44:54.479Z withdraw.ts TRACE Validating denomination (11/14) signature of MZPA4M14VQA97E4K170130Q5R3ZG94JXAWF5A2FXCN5KVJGNNX9YNAXD3VEC066D9ZP35CP9FPMQNWDR4VKP3A97ZW49JFFKB73GTN8
2022-02-09T14:44:54.504Z withdraw.ts TRACE Done validating MZPA4M14VQA97E4K170130Q5R3ZG94JXAWF5A2FXCN5KVJGNNX9YNAXD3VEC066D9ZP35CP9FPMQNWDR4VKP3A97ZW49JFFKB73GTN8
2022-02-09T14:44:54.504Z withdraw.ts TRACE Validating denomination (12/14) signature of RFVT1G4V99HAFXRXVN2N5N1KNZP2G1NRBCWNMVMDK35G713A89J43X5QBPJ6S1GRKKPA5CP8VVQE7DSVS3ZZVR0ENK6WQSEFGKDWWX8
2022-02-09T14:44:54.531Z withdraw.ts TRACE Done validating RFVT1G4V99HAFXRXVN2N5N1KNZP2G1NRBCWNMVMDK35G713A89J43X5QBPJ6S1GRKKPA5CP8VVQE7DSVS3ZZVR0ENK6WQSEFGKDWWX8
2022-02-09T14:44:54.532Z withdraw.ts TRACE Validating denomination (13/14) signature of V4MHG3Y5GR9MKMG65ZRTS9ZZMB68CZ1DY7VA8ZQC3VHZ8TMVW8GG8EJQGHW6MFK2BBHMSXGJG0YYQ0WDPD7JRFRHS5J4THWXE0MSKX8
2022-02-09T14:44:54.552Z withdraw.ts TRACE Done validating V4MHG3Y5GR9MKMG65ZRTS9ZZMB68CZ1DY7VA8ZQC3VHZ8TMVW8GG8EJQGHW6MFK2BBHMSXGJG0YYQ0WDPD7JRFRHS5J4THWXE0MSKX8
2022-02-09T14:44:54.559Z withdraw.ts TRACE Validating denomination (14/14) signature of X6ZC4SD3R0TBG277DNCTSAHCKG4TJQHK09X8PPB5D8R5E1BN5Q81GNPR9PB9DD9FYAYXSS8MKMFFSXCAG2TJN3X55N258REJCHW4FRR
2022-02-09T14:44:54.592Z withdraw.ts TRACE Done validating X6ZC4SD3R0TBG277DNCTSAHCKG4TJQHK09X8PPB5D8R5E1BN5Q81GNPR9PB9DD9FYAYXSS8MKMFFSXCAG2TJN3X55N258REJCHW4FRR
2022-02-09T14:44:54.594Z withdraw.ts TRACE writing denomination batch to db
2022-02-09T14:44:54.631Z headless/helpers.ts TRACE committing database
2022-02-09T14:44:54.854Z withdraw.ts TRACE done with DB write
2022-02-09T14:44:54.890Z withdraw.ts TRACE selected withdrawal denoms for CHF:50
2022-02-09T14:44:54.891Z withdraw.ts TRACE denom_pub_hash=RFVT1G4V99HAFXRXVN2N5N1KNZP2G1NRBCWNMVMDK35G713A89J43X5QBPJ6S1GRKKPA5CP8VVQE7DSVS3ZZVR0ENK6WQSEFGKDWWX8, count=1
2022-02-09T14:44:54.891Z withdraw.ts TRACE denom_pub_hash=CWXHQA3RT8PCAYCF3X0XJTNKVF9WQXEW8MBC94YKJFEZ05X807KES5PWCYT84HQ7P7PCY1PZAXX5H9DDMVE1AQQAEKYD2GZBTR0VAV8, count=1
2022-02-09T14:44:54.894Z withdraw.ts TRACE denom_pub_hash=8P590T4F1CMV7PMJA6NJNC507H8VK5XBC7CGZBC00WPA6T3RQMH88TS6BJ54VDZH0347FJK46DQWV0P3EVEGSFJAYCHCSDYAZSE08JR, count=1
2022-02-09T14:44:54.894Z withdraw.ts TRACE denom_pub_hash=X6ZC4SD3R0TBG277DNCTSAHCKG4TJQHK09X8PPB5D8R5E1BN5Q81GNPR9PB9DD9FYAYXSS8MKMFFSXCAG2TJN3X55N258REJCHW4FRR, count=1
2022-02-09T14:44:54.895Z withdraw.ts TRACE denom_pub_hash=7F6PHA0G144FWFDJBFYJS4WKZXQK4XZ4HQFG4HK4YG2WNGK95GZCN235EPBWT66YQ7DND8ZT2GKK1YRS1W5D4MG7P2KN8Y912A633GR, count=1
2022-02-09T14:44:54.896Z withdraw.ts TRACE (end of withdrawal denom list)
2022-02-09T14:44:56.299Z withdraw.ts TRACE updating denominations used for withdrawal for http://exchange/exchange/
2022-02-09T14:44:56.307Z withdraw.ts TRACE getting candidate denominations
2022-02-09T14:44:56.318Z withdraw.ts TRACE got 14 candidate denominations
2022-02-09T14:44:56.336Z withdraw.ts TRACE selected withdrawal denoms for CHF:50
2022-02-09T14:44:56.336Z withdraw.ts TRACE denom_pub_hash=RFVT1G4V99HAFXRXVN2N5N1KNZP2G1NRBCWNMVMDK35G713A89J43X5QBPJ6S1GRKKPA5CP8VVQE7DSVS3ZZVR0ENK6WQSEFGKDWWX8, count=1
2022-02-09T14:44:56.337Z withdraw.ts TRACE denom_pub_hash=CWXHQA3RT8PCAYCF3X0XJTNKVF9WQXEW8MBC94YKJFEZ05X807KES5PWCYT84HQ7P7PCY1PZAXX5H9DDMVE1AQQAEKYD2GZBTR0VAV8, count=1
2022-02-09T14:44:56.341Z withdraw.ts TRACE denom_pub_hash=8P590T4F1CMV7PMJA6NJNC507H8VK5XBC7CGZBC00WPA6T3RQMH88TS6BJ54VDZH0347FJK46DQWV0P3EVEGSFJAYCHCSDYAZSE08JR, count=1
2022-02-09T14:44:56.341Z withdraw.ts TRACE denom_pub_hash=X6ZC4SD3R0TBG277DNCTSAHCKG4TJQHK09X8PPB5D8R5E1BN5Q81GNPR9PB9DD9FYAYXSS8MKMFFSXCAG2TJN3X55N258REJCHW4FRR, count=1
2022-02-09T14:44:56.342Z withdraw.ts TRACE denom_pub_hash=7F6PHA0G144FWFDJBFYJS4WKZXQK4XZ4HQFG4HK4YG2WNGK95GZCN235EPBWT66YQ7DND8ZT2GKK1YRS1W5D4MG7P2KN8Y912A633GR, count=1
2022-02-09T14:44:56.342Z withdraw.ts TRACE (end of withdrawal denom list)
2022-02-09T14:44:56.345Z exchanges.ts TRACE updating exchange info for http://exchange/exchange/
2022-02-09T14:44:56.347Z headless/helpers.ts TRACE committing database
2022-02-09T14:44:56.589Z exchanges.ts INFO using existing exchange info
2022-02-09T14:44:56.627Z headless/helpers.ts TRACE committing database
2022-02-09T14:44:56.784Z wallet.ts TRACE Notification [
  {
    "type": "reserve-created",
    "reservePub": "CD6P3JH67W7T3Q8P3B00BF7AS5PXGGAGN62AP7CX6Q3E062YD030"
  }
]
2022-02-09T14:44:56.798Z headless/helpers.ts TRACE committing database
Created reserve CD6P3JH67W7T3Q8P3B00BF7AS5PXGGAGN62AP7CX6Q3E062YD030
Payto URI payto://x-taler-bank/bank:5882/Exchange?amount=CHF%3A50.00&message=Taler+top-up+CD6P3JH67W7T3Q8P3B00BF7AS5PXGGAGN62AP7CX6Q3E062YD030
2022-02-09T14:44:56.956Z taler-wallet-cli.ts INFO operation with wallet finished, stopping
2022-02-09T14:44:56.960Z cryptoApi.ts TRACE terminating worker
2022-02-09T14:44:56.963Z headless/helpers.ts TRACE committing database
2022-02-09T14:44:57.137Z reserves.ts TRACE Processing reserve CD6P3JH67W7T3Q8P3B00BF7AS5PXGGAGN62AP7CX6Q3E062YD030 with status querying-status
2022-02-09T14:44:57.172Z NodeHttpLib.ts TRACE Requesting GET http://exchange/exchange/reserves/CD6P3JH67W7T3Q8P3B00BF7AS5PXGGAGN62AP7CX6Q3E062YD030
2022-02-09T14:44:57.204Z wallet.ts TRACE Notification [
  {
    "type": "reserve-not-yet-found",
    "reservePub": "CD6P3JH67W7T3Q8P3B00BF7AS5PXGGAGN62AP7CX6Q3E062YD030"
  }
]
```

Neuen Account in Exchange registriert, `Abhebevorgang auslösen` klicken, Link kopieren und `taler-wallet-cli handle-uri` aufgerufen, welches eine Reserve erstellt. 
```text
taler-wallet-cli handle-uri taler+http://withdraw/127.0.0.1:5882/api/df7ffbe9-43e7-496e-b908-1c7cf35e8971
taler@taler:~/gnu-taler-docker/tmp$ taler-wallet-cli handle-uri taler+http://withdraw/127.0.0.1:5882/api/df7ffbe9-43e7-496e-b908-1c7cf35e8971
2022-02-09T15:49:23.134Z taler-wallet-cli.ts TRACE running wallet-cli with [
  [
    "/usr/bin/node",
    "/usr/bin/taler-wallet-cli",
    "handle-uri",
    "taler+http://withdraw/127.0.0.1:5882/api/df7ffbe9-43e7-496e-b908-1c7cf35e8971"
  ]
]
2022-02-09T15:49:23.341Z headless/helpers.ts TRACE committing database
2022-02-09T15:49:23.578Z headless/helpers.ts WARN worker threads not available, falling back to synchronous workers
2022-02-09T15:49:23.599Z headless/helpers.ts TRACE committing database
2022-02-09T15:49:23.780Z withdraw.ts TRACE getting withdrawal details for URI taler+http://withdraw/127.0.0.1:5882/api/df7ffbe9-43e7-496e-b908-1c7cf35e8971
2022-02-09T15:49:23.791Z NodeHttpLib.ts TRACE Requesting GET http://127.0.0.1:5882/api/config
2022-02-09T15:49:23.874Z NodeHttpLib.ts TRACE Requesting GET http://127.0.0.1:5882/api/withdrawal-operation/df7ffbe9-43e7-496e-b908-1c7cf35e8971
2022-02-09T15:49:23.904Z withdraw.ts TRACE got bank info
2022-02-09T15:49:23.905Z exchanges.ts TRACE updating exchange info for http://exchange/exchange/
2022-02-09T15:49:23.909Z headless/helpers.ts TRACE committing database
2022-02-09T15:49:24.009Z exchanges.ts INFO using existing exchange info
withdrawInfo { amount: 'CHF:5',
  defaultExchangeBaseUrl: 'http://exchange/exchange/',
  possibleExchanges:
   [ { exchangeBaseUrl: 'http://exchange/exchange/',
       currency: 'CHF',
       paytoUris: [Array] } ] }
2022-02-09T15:49:24.024Z exchanges.ts TRACE updating exchange info for http://exchange/exchange/
2022-02-09T15:49:24.028Z headless/helpers.ts TRACE committing database
2022-02-09T15:49:24.149Z exchanges.ts INFO using existing exchange info
2022-02-09T15:49:24.150Z NodeHttpLib.ts TRACE Requesting GET http://127.0.0.1:5882/api/config
2022-02-09T15:49:24.158Z NodeHttpLib.ts TRACE Requesting GET http://127.0.0.1:5882/api/withdrawal-operation/df7ffbe9-43e7-496e-b908-1c7cf35e8971
2022-02-09T15:49:24.222Z withdraw.ts TRACE updating denominations used for withdrawal for http://exchange/exchange/
2022-02-09T15:49:24.227Z withdraw.ts TRACE getting candidate denominations
2022-02-09T15:49:24.254Z withdraw.ts TRACE got 14 candidate denominations
2022-02-09T15:49:24.266Z withdraw.ts TRACE selected withdrawal denoms for CHF:5
2022-02-09T15:49:24.267Z withdraw.ts TRACE denom_pub_hash=8P590T4F1CMV7PMJA6NJNC507H8VK5XBC7CGZBC00WPA6T3RQMH88TS6BJ54VDZH0347FJK46DQWV0P3EVEGSFJAYCHCSDYAZSE08JR, count=1
2022-02-09T15:49:24.268Z withdraw.ts TRACE denom_pub_hash=X6ZC4SD3R0TBG277DNCTSAHCKG4TJQHK09X8PPB5D8R5E1BN5Q81GNPR9PB9DD9FYAYXSS8MKMFFSXCAG2TJN3X55N258REJCHW4FRR, count=1
2022-02-09T15:49:24.268Z withdraw.ts TRACE denom_pub_hash=V4MHG3Y5GR9MKMG65ZRTS9ZZMB68CZ1DY7VA8ZQC3VHZ8TMVW8GG8EJQGHW6MFK2BBHMSXGJG0YYQ0WDPD7JRFRHS5J4THWXE0MSKX8, count=1
2022-02-09T15:49:24.269Z withdraw.ts TRACE denom_pub_hash=6HS1694YHF6MWWVZK20SKPVRSKR2QP9E8ZNM1V43YD58YY76412KM8SRCY5DTJ06E4QPVFA9BFH6BWMX4A8ETF1J2K5KY4NBYXVW34G, count=1
2022-02-09T15:49:24.269Z withdraw.ts TRACE denom_pub_hash=14QR32TWFH9TWJ413C6KVJ2C09M1KM3Y7ZK7E88EWGSBM18WSMWQ5REHMTB4D86TFPWRX60QBPD3FA330MMB704EMVQ4RNVFY2JEKR0, count=1
2022-02-09T15:49:24.269Z withdraw.ts TRACE denom_pub_hash=MZPA4M14VQA97E4K170130Q5R3ZG94JXAWF5A2FXCN5KVJGNNX9YNAXD3VEC066D9ZP35CP9FPMQNWDR4VKP3A97ZW49JFFKB73GTN8, count=1
2022-02-09T15:49:24.270Z withdraw.ts TRACE (end of withdrawal denom list)
2022-02-09T15:49:24.271Z exchanges.ts TRACE updating exchange info for http://exchange/exchange/
2022-02-09T15:49:24.276Z headless/helpers.ts TRACE committing database
2022-02-09T15:49:24.401Z exchanges.ts INFO using existing exchange info
2022-02-09T15:49:24.418Z headless/helpers.ts TRACE committing database
2022-02-09T15:49:24.519Z wallet.ts TRACE Notification [
  {
    "type": "reserve-created",
    "reservePub": "S5NVD15SE3DPRPAZMKZ0YETV6D62MAVK0DRZYSNFAJQEV72D3CSG"
  }
]
2022-02-09T15:49:24.544Z NodeHttpLib.ts TRACE Requesting GET http://127.0.0.1:5882/api/withdrawal-operation/df7ffbe9-43e7-496e-b908-1c7cf35e8971
2022-02-09T15:49:24.556Z headless/helpers.ts TRACE committing database
2022-02-09T15:49:24.655Z reserves.ts TRACE Processing reserve S5NVD15SE3DPRPAZMKZ0YETV6D62MAVK0DRZYSNFAJQEV72D3CSG with status registering-bank
2022-02-09T15:49:24.659Z NodeHttpLib.ts TRACE Requesting GET http://127.0.0.1:5882/api/withdrawal-operation/df7ffbe9-43e7-496e-b908-1c7cf35e8971
2022-02-09T15:49:24.668Z NodeHttpLib.ts TRACE Requesting POST http://127.0.0.1:5882/api/withdrawal-operation/df7ffbe9-43e7-496e-b908-1c7cf35e8971
2022-02-09T15:49:24.688Z NodeHttpLib.ts TRACE Requesting POST http://127.0.0.1:5882/api/withdrawal-operation/df7ffbe9-43e7-496e-b908-1c7cf35e8971
2022-02-09T15:49:24.721Z headless/helpers.ts TRACE committing database
2022-02-09T15:49:24.836Z wallet.ts TRACE Notification [
  {
    "type": "reserve-registered-with-bank"
  }
]
2022-02-09T15:49:24.852Z NodeHttpLib.ts TRACE Requesting GET http://127.0.0.1:5882/api/withdrawal-operation/df7ffbe9-43e7-496e-b908-1c7cf35e8971
2022-02-09T15:49:24.874Z headless/helpers.ts TRACE committing database
2022-02-09T15:49:25.058Z wallet.ts TRACE Notification [
  {
    "type": "reserve-registered-with-bank"
  }
]
2022-02-09T15:49:25.067Z NodeHttpLib.ts TRACE Requesting GET http://127.0.0.1:5882/api/withdrawal-operation/df7ffbe9-43e7-496e-b908-1c7cf35e8971
2022-02-09T15:49:25.071Z headless/helpers.ts TRACE committing database
2022-02-09T15:49:25.271Z NodeHttpLib.ts TRACE Requesting GET http://127.0.0.1:5882/api/withdrawal-operation/df7ffbe9-43e7-496e-b908-1c7cf35e8971
2022-02-09T15:49:25.346Z headless/helpers.ts TRACE committing database
2022-02-09T15:49:25.524Z NodeHttpLib.ts TRACE Requesting GET http://127.0.0.1:5882/api/withdrawal-operation/df7ffbe9-43e7-496e-b908-1c7cf35e8971
2022-02-09T15:49:25.532Z headless/helpers.ts TRACE committing database
2022-02-09T15:49:25.682Z taler-wallet-cli.ts INFO operation with wallet finished, stopping
2022-02-09T15:49:25.683Z cryptoApi.ts TRACE terminating worker
2022-02-09T15:49:25.692Z headless/helpers.ts TRACE committing database
2022-02-09T15:49:25.784Z headless/helpers.ts TRACE committing database
2022-02-09T15:49:25.867Z reserves.ts TRACE Processing reserve S5NVD15SE3DPRPAZMKZ0YETV6D62MAVK0DRZYSNFAJQEV72D3CSG with status wait-confirm-bank
2022-02-09T15:49:25.883Z NodeHttpLib.ts TRACE Requesting GET http://127.0.0.1:5882/api/withdrawal-operation/df7ffbe9-43e7-496e-b908-1c7cf35e8971
2022-02-09T15:49:25.914Z headless/helpers.ts TRACE committing database
```

Dann im Browser Captcha lösen, danach sollte Geld auf Exchange gelandet sein.


Via Bank UI von einem Account der Geld drauf hat Überweisung auf ein Wallet machen:
`payto://x-taler-bank/bank:5882/Exchange?message=Taler Withdrawal 892RK5HE92WYVYSCY60K8FARFJ4CXHM9F7V9139YE6CQMPV3RXH0&amount=CHF:2.5`

# Chrome Extension
Add Taler Wallet

# Merchant
## Create Account at Bank
Create a new account with name `Shop`.
Note that this name is also used in the `TALER_PAY_TO_URI` env var.

## Reserves
Bug: cannot add exchange b/c regex expects URL without relative path.

# Questions
## Wieso dauert "updating denominations" 15+ Sekunden?
```text
2022-02-09T22:12:59.893Z exchanges.ts TRACE updating denominations in database
2022-02-09T22:13:16.443Z exchanges.ts TRACE done updating denominations in database
```
