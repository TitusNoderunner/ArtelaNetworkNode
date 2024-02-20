#!/bin/bash

# Install lolcat and figlet
sudo apt-get install lolcat figlet -y

# Display splash banner
echo -e "\e[1;36m█▀▄▀█ ─█▀█─ █▄─█─ █▀█─ █▀█─\e[0m"
echo -e "\e[1;36m█ x.com/TitusNoderunner\e[0m"
echo -e "\e[1;36m█ █▄█─ █▄█── ██─█─ █▄█── █▄█──\e[0m"
echo -e "\e[1;36m▀─────────────────────────\e[0m"
figlet -f fraktur Titus | lolcat
echo -e "\e[1;36m─────────────────────────\e[0m"

# Update packages and install essential tools
sudo apt update && sudo apt upgrade -y
sudo apt-get update && sudo apt-get install software-properties-common -y
apt install curl iptables build-essential git wget jq make gcc nano tmux htop lz4 nvme-cli pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev -y

# Install the latest version of GO
ver="1.22.0"
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile

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
artelad init "$MONIKER"

# Download the genesis.json file and add persistent seeds
wget -qO $HOME/.artelad/config/genesis.json https://docs.artela.network/assets/files/genesis-314f4b0294712c1bc6c3f4213fa76465.json
SEEDS="8d0c626443a970034dc12df960ae1b1012ccd96a@artela-testnet-seed.itrocket.net:30656"
PEERS="5c9b1bc492aad27a0197a6d3ea3ec9296504e6fd@artela-testnet-peer.itrocket.net:30656,e60ccf5954cf2f324bbe0da7eada0a98437eab29@[2a03:4000:4c:e90:781d:c8ff:fe"
