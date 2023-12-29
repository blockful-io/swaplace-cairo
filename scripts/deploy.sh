#!/bin/bash

source .env
set -e

export STARKNET_ACCOUNT=$ACCOUNT_SRC
export STARKNET_RPC=$RPC_URL

# ANSI format
GREEN='\e[32m'
RESET='\e[0m'

# Declare all contracts
echo -e "$GREEN\n==> Declaring HelloStarknet$RESET"
HELLO_STARKNET_CLASS_HASH=$(starkli declare --watch --private-key $ACCOUNT_PRIVATE_KEY ./target/dev/swaplace_HelloStarknet.sierra.json)
echo -e $GREEN$HELLO_STARKNET_CLASS_HASH

echo -e "$GREEN\n==> Deploying HelloStarknet$RESET"
HELLO_STARKNET_ADDRESS=$(starkli deploy --watch $HELLO_STARKNET_CLASS_HASH --private-key $ACCOUNT_PRIVATE_KEY)
echo -e $GREEN$HELLO_STARKNET_ADDRESS$RESET
