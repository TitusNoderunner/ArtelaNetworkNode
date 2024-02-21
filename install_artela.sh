#!/bin/bash

# Set up variables
MONIKER="my-wallet"
WALLET="my-wallet"
SEEDS=("my-seed")
PEERS=("my-peer")

# Install dependencies
sudo apt-get update
sudo apt-get install -y curl jq docker-ce docker-compose

# Set up Docker
sudo systemctl enable docker
sudo systemctl start docker

# Clone the repository
git clone https://github.com/artela-network/artela-cometbft.git
cd artela-cometbft

# Build the binary
make build

# Create the necessary directories
mkdir -p ~/.artelad/config

# Generate the genesis.json file
./build/artelad init $MONIKER --chain-id testnet

# Generate the config.toml file
./build/artelad config chain-id testnet
./build/artelad config p2p.seeds "$(IFS=, ; echo "${SEEDS[*]}")"
./build/artelad config p2p.persistent-peers "http://127.0.0.1:26657"
./build/artelad config moniker "$MONIKER"
./build/artelad config fastsync.version "v0"
./build/artelad config fastsync.enable true
./build/artelad config fastsync.rpc-servers "http://127.0.0.1:26658"

# Calculate the trust hash
GENESIS_FILE=~/.artelad/config/genesis.json
GENESIS_HASH=$(jq -r '.app_hash' $GENESIS_FILE)

# Set the trust hash
./build/artelad config fastsync.trust-height 1
./build/artelad config fastsync.trust-hash "$GENESIS_HASH"

# Start the node
artelad start --pruning=nothing --log_level debug --minimum-gas-prices=0.0001art --api.enable --json-rpc.api eth,txpool,personal,net,debug,web3,miner --api.enable
