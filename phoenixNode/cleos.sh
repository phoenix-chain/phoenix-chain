#!/bin/bash
################################################################################
# Phoenix tools  
###############################################################################

NODEOSBINDIR="/opt/eosio/bin"
WALLETHOST="127.0.0.1"
NODEHOST="127.0.0.1"
NODEPORT="8888"
WALLETPORT="3001"

$NODEOSBINDIR/cleos -u http://$NODEHOST:$NODEPORT --wallet-url http://$WALLETHOST:$WALLETPORT "$@"

