# TUTORIAL STAKEWARS III

##Useful links
Wallet: https://wallet.shardnet.near.org/
Explorer: https://explorer.shardnet.near.org/

##Challenge 001
**Setup NEAR-CLI**
```bash
sudo apt update && sudo apt upgrade -y
```
Install developer tools, Node.js, and npm
```bash
curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -  
sudo apt install build-essential nodejs
PATH="$PATH"
```
Install NEAR-CLI
```bash
sudo npm install -g near-cli
```
Set up the environment. Be aware that you should input these commands anytime you open a new session! Otherwise testnet environment will be used!
```bash
export NEAR_ENV=shardnet
echo 'export NEAR_ENV=shardnet' >> ~/.bashrc
```