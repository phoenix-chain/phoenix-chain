#!/bin/bash
################################################################################
# Phoenix tools
# To generate keys 
# Usage: ./generate_key.sh name-of-key 
################################################################################## 
cleos create key --file $1
cat $1