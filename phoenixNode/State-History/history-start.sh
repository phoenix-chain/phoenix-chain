#!/bin/bash
################################################################################
MAINDIR=/opt/phoenix-chain/
DATADIR=$MAINDIR/data

$MAINDIR/nodeos --data-dir $DATADIR --config-dir $MAINDIR --genesis-json $MAINDIR/genesis.json  --disable-replay-opts "$@"  2> $DATADIR/stderr.txt &  echo $! > $DATADIR/nodeos.pid
