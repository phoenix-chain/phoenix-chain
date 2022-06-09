#!/bin/bash
################################################################################
# Phoenix tools
# Originated from scripts by by CryptoLions.io
###############################################################################

DATADIR="/opt/phoenix-chain/PhoenixNode"

    if [ -f $DATADIR"/nodeos.pid" ]; then
	pid=`cat $DATADIR"/nodeos.pid"`
	echo $pid
	kill $pid
	
	echo -ne "Stoping Nodeos"

        while true; do
            [ ! -d "/proc/$pid/fd" ] && break
            echo -ne "."
            sleep 1
        done
	rm -r $DIR"/nodeos.pid"
	
	DATE=$(date -d "now" +'%Y_%m_%d-%H_%M')
        if [ ! -d $DATADIR/logs ]; then
            mkdir $DATADIR/logs
        fi
        tar -pcvzf $DATADIR/logs/stderr-$DATE.txt.tar.gz stderr.txt stdout.txt

        echo -ne "\rNodeos Stopped.    \n"
    fi
