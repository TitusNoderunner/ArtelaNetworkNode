#!/bin/bash

# Install lolcat and figlet
sudo apt-get install lolcat figlet -y

# Display splash banner
figlet -f slant "Titus" | lolcat

# Prompt for MONIKER and WALLET input
echo "Enter your MONIKER name:"
read MONIKER
echo "Enter your WALLET name:"
read WALLET

# Update and install necessary packages
sudo apt-get update
sudo apt-get install -y make gcc wget

# Download and install Go
wget https://go.dev/dl/go1.20.3.linux-amd64.tar.gz
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
cd artela/testnet
./create-testnet

# Initialize your node
artelad init "$MONIKER" --chain-id artela_11822-1

# Download the genesis.json file and add persistent seeds
wget -qO $HOME/.artelad/config/genesis.json https://docs.artela.network/assets/files/genesis-314f4b0294712c1bc6c3f4213fa76465.json
SEEDS="8d0c626443a970034dc12df960ae1b1012ccd96a@artela-testnet-seed.itrocket.net:30656"
PEERS="5c9b1bc492aad27a0197a6d3ea3ec9296504e6fd@artela-testnet-peer.itrocket.net:30656,e60ccf5954cf2f324bbe0da7eada0a98437eab29@[2a03:4000:4c:e90:781d:c8ff:fe57:726a]:9656,cc926b13a1be8b3c82cbca5bc137c04055c29d66@54.197.218.54:26656,9142bc72d918a36754d64e90f66b382f6d98f67b@161.35.157.41:45656,615a32fbf484e711562fe93b64cc069e1e5f49ab@185.230.138.142:45656,4ff338"

# Set up necessary variables
echo "export WALLET=$WALLET" >> $HOME/.bash_profile
echo "export MONIKER=$MONIKER" >> $HOME/.bash_profile
echo "export ARTELA_CHAIN_ID=artela_11822-1" >> $HOME/.bash_profile
echo "export ARTELA_PORT=45" >> $HOME/.bash_profile
source $HOME/.bash_profile

# Clone and compile the Artela source code
git clone https://github.com/artela-network/artela
cd artela
git checkout main
make install

# Start the node
artelad start --pruning=nothing --log_level debug --minimum-gas-prices=0.0001art --api.enable --json-rpc.api eth,txpool,personal,net,debug,web3,miner --api.enable
