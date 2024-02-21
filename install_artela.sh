#!/bin/bash

# Install Go
wget https://golang.org/dl/go1.20.3.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.20.3.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin

# Create workspace and clone repositories
mkdir -p /home/user1/go/src
export GOPATH=/home/user1/go
cd $GOPATH/src
git clone https://github.com/artela-network/artela-cometbft.git
git clone https://github.com/artela-network/artela-cosmos-sdk.git
git clone https://github.com/artela-network/artela.git

# Build the Artela binary
cd artelamake clean && make

# Install Docker and Docker Compose
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt-get update
sudo apt-get install docker-ce
sudo apt-get install docker-compose

# Create a testnet and start the nodes
cd artela/testnetmake create-testnet

# Start the node
MONIKER="my-node"
WALLET_NAME="my-wallet"

# Replace the MONIKER and WALLET_NAME in the config files
sed -i "s/moniker = \"\"/moniker = \"$MONIKER\"/g" $GOPATH/src/artela/testnet/config/config.toml
sed -i "s/name = \"\"/name = \"$WALLET_NAME\"/g" $GOPATH/src/artela/testnet/config/config.toml

# Start the node
artelad start --pruning=nothing --log_level debug --minimum-gas-prices=0.0001art --api.enable --json-rpc.api eth,txpool,personal,net,debug,web3,miner --api.enable
