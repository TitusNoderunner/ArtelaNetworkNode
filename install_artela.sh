#!/bin/bash

# Display splash banner
echo -e "\e[1;36m█▀▄▀█ ─█▀█─ █▄─█─ █▀█─ █▀█─\e[0m"
echo -e "\e[1;36m█ x.com/TitusNoderunner\e[0m"
echo -e "\e[1;36m█ █▄█─ █▄█── ██─█─ █▄█── █▄█──\e[0m"
echo -e "\e[1;36m▀─────────────────────────\e[0m"
Follow me on X
echo -e "\e[1;36m─────────────────────────\e[0m"

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

# Install lolcat and figlet
sudo apt-get install lolcat figlet -y

# Update packages and install essential tools
sudo apt update && sudo apt upgrade -y
sudo apt-get update && sudo apt-get install software-properties-common -y
apt install curl iptables build-essential git wget jq make gcc nano tmux htop lz4 nvme-cli pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev -y

# Prompt for WALLET and MONIKER input
echo "Enter your WALLET name:"
read WALLET
echo "Enter your MONIKER name:"
read MONIKER

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

# Initialize your node
artelad init "$MONIKER" --chain-id "$ARTELA_CHAIN_ID"

# Download the genesis.json file and add persistent seeds
wget -qO $HOME/.artelad/config/genesis.json https://raw.githubusercontent.com/artela-network/testnet/main/genesis.json
SEEDS="8d0c626443a970034dc12df960ae1b1012ccd96a@artela-testnet-seed.itrocket.net:30656"
PEERS="5c9b1bc492aad27a0197a6d3ea3ec9296504e6fd@artela-testnet-peer.itrocket.net:30656,e60ccf5954cf2f324bbe0da7eada0a98437eab29@[2a03:4000:4c:e90:781d:c8ff:fe8e:252c]:30656"
sed -i -e "s/^moniker *=.*/moniker = \"$MONIKER\"/g" /home/user1/.artelad/config/config.toml
sed -i -e "s/^chain-id *=.*/chain-id = \"$CHAIN_ID\"/g" /home/user1/.artelad/config/config.toml
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/g" /home/user1/.artelad/config/config.toml
sed -i -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/g" /home/user1/.artelad/config/config.toml

# Start the node
artelad start --pruning=nothing --log_level debug --minimum-gas-prices=0.0001art --api.enable --json-rpc.api eth,txpool,personal,net,debug,web3,miner --api.enable

# Print the splash banner
echo -e "\033[1;32m
+-+-+-+-+-+-+-+-+-+-+-+
|N|o|d|e|r|u|n|n|e|r|s|
+-+-+-+-+-+-+-+-+-+-+-+
\033[0m"
