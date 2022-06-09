#!/bin/bash

################################################################################
# 
# Created by http://CryptoLions.io
#
###############################################################################

NODEOSBINDIR="/opt/eosio/bin"
DATADIR="/opt/phoenix-chain/Wallet"
WALLET_HOST="127.0.0.1"
WALLET_POSRT="3001"

$DATADIR/stop_wallet.sh
$NODEOSBINDIR/keosd --config-dir $DATADIR --wallet-dir $DATADIR --unix-socket-path $DATADIR/keosd.sock --http-server-address $WALLET_HOST:$WALLET_POSRT "$@" > $DATADIR/stdout.txt 2> $DATADIR/stderr.txt & echo $! > $DATADIR/wallet.pid

