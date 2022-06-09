#!/bin/bash
ACCT="node1" #change to your node name
SIGNKEY="EOS7nUYK3tvvQXJQgGVsQ41TNSwoQXGP5HMTr5wgjiZzypcCzPhv3" #change to your signing key from config.ini
URL="https://mindyourbitcoin.com" #change to your website URL
LIBRE_AMOUNT="1000 LIBRE"
LOCATION="840"

# Regprod
/opt/phoenix-chain/phoenixNodex/cleos.sh system regproducer "$ACCT" "$SIGNKEY" "$URL" $LOCATION -p $ACCT

# Stake
DAYS=`echo $(( $RANDOM % 365 + 1 ))`
/opt/phoenix-chain/phoenixNodex/cleos.sh transfer $ACCT stake.libre $LIBRE_AMOUNT "stakefor:$DAYS"

# Vote
VOTE='{"voter": "ACCT", "producer": "ACCT"}'
echo $VOTE > VOTE.json
sed -e 's/\"ACCT\"/\"'${ACCT}'"/g' VOTE.json > $ACCT-vote.json 
/opt/phoenix-chain/phoenixNodex/cleos.sh push action eosio voteproducer `echo $ACCT-vote.json` -p $ACCT@active
rm VOTE.json
rm $ACCT-vote.json