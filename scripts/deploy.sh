#!/bin/bash

source .env
set -e

export STARKNET_ACCOUNT=$ACCOUNT_SRC
export STARKNET_KEYSTORE=$KEYSTORE_SRC
export STARKNET_RPC=$RPC_URL

# ANSI format
GREEN='\e[32m'
RESET='\e[0m'

# Declare all contracts
echo -e "$GREEN\n==> Declaring Swaplace$RESET"
SWAPLACE_CLASS_HASH=$(starkli declare --watch ./target/dev/swaplace_Swaplace.contract_class.json)
echo -e $GREEN$SWAPLACE_CLASS_HASH

echo -e "$GREEN\n==> Deploying Swaplace$RESET"
SWAPLACE_ADDRESS=$(starkli deploy --watch $SWAPLACE_CLASS_HASH)
echo -e $GREEN$SWAPLACE_ADDRESS$RESET
