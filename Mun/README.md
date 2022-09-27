# Munchain network

## Tutorial
System Requirement :
- Number of CPUs: 4
- Memory: 16GB
- OS: Ubuntu 22.04 LTS
- Allow all incoming connections from TCP port 26656 and 26657
Static IP address
- The recommended configuration from AWS is the equivalent of a t2.large machine
with 300GB EBS attached storage.

Installing prerequisites :
```bash
sudo apt update
sudo apt upgrade -y
sudo apt install build-essential jq -y
```
Install Golang :
```bash
ver="1.18.1"
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
go version
```

Clone repository :
```bash
git clone https://github.com/munblockchain/mun
cd mun
```
Install the executables :
```bash
sudo rm -rf ~/.mun
go mod tidy
make install

clear

mkdir -p ~/.mun/upgrade_manager/upgrades
mkdir -p ~/.mun/upgrade_manager/genesis/bin
```
Symlink genesis binary to upgrade :
```bash
cp $(which mund) ~/.mun/upgrade_manager/genesis/bin
sudo cp $(which mund-manager) /usr/bin
```
Initialize the validator with a moniker name (Example moniker_name: solid-moon-rock) :
```bash
mund init [moniker_name] --chain-id testmun
```
Add a new wallet address, store seeds and buy TMUN to it. (Example wallet_name: solid-moon-rock) :
```bash
mund keys add [wallet_name] --keyring-backend test
```

Fetch genesis.json from genesis node :
```bash
curl --tlsv1 https://node1.mun.money/genesis? | jq ".result.genesis" > ~/.mun/config/genesis.json
```
Update seed in config.toml to make p2p connection :
```bash
nano ~/.mun/config/config.toml
seeds = "b4eeaf7ca17e5186b181885714cedc6a78d20c9b@167.99.6.48:26656"
```
Replace stake to TMUN :
```bash
sed -i 's/stake/utmun/g' ~/.mun/config/genesis.json
```

Create the service file "/etc/systemd/system/mund.service" with the following content :
```bash
sudo nano /etc/systemd/system/mund.service
```
and then paste
```bash
[Unit]
Description=mund
Requires=network-online.target
After=network-online.target

[Service]
Restart=on-failure
RestartSec=3
User=root
Group=root
Environment=DAEMON_NAME=mund
Environment=DAEMON_HOME=/root/.mun
Environment=DAEMON_ALLOW_DOWNLOAD_BINARIES=on
Environment=DAEMON_RESTART_AFTER_UPGRADE=on
PermissionsStartOnly=true
ExecStart=/usr/bin/mund-manager start --pruning="nothing" --rpc.laddr "tcp://0.0.0.0:26657"
StandardOutput=file:/var/log/mund/mund.log
StandardError=file:/var/log/mund/mund_error.log
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGTERM
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
```
**Tips**
- How to get user and group name
```bash
whoami
```
- How to get DAEMON_HOME path
```bash
cd ~/.mun
pwd
```
Create log files and starts running the node :
```bash
make log-files
sudo systemctl enable mund
sudo systemctl start mund
```
Verify node is running properly :
```bash
mund status
```
### After buying TMUN, stake it to become a validator.After buying TMUN, stake it to become a validator.
Anda harus menunggu sampai node tersinkronisasi sepenuhnya dengan node lain. Anda dapat melakukan cross check dengan node genesis dengan mengunjungi https://node1.mun.money/status dan memeriksa ketinggian blok terbaru. Anda juga dapat memeriksa status simpul Anda melalui tautan ini http://[Your_Node_IP]:26657/status.

Atau kunjungi https://blockexplorer.mun.money

Transaksi untuk menjadi validator dengan staking 50K TMUN

```bash
mund tx staking create-validator --from [wallet_name] --moniker [moniker_name] --pubkey $(mund tendermint show-validator) --chain-id testmun --keyring-backend test --amount 50000000000utmun --commission-max-change-rate 0.01 --commission-max-rate 0.2 --commission-rate 0.1 --min-self-delegation 1 --fees 200000utmun --gas auto --gas=auto --gas-adjustment=1.5 -y
```
