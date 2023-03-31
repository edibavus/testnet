## Document
Official https://docs.celestia.org/nodes/light-node

Explorer https://tiascan.com/light-nodes

Phase 2 all task https://docs.celestia.org/nodes/blockspace-race/#phase-2-staging

## Minimum System Requirements 
- Memory: 2 GB RAM
- CPU: Single Core
- Disk: 5 GB SSD

## Auto Install
```
wget -qO- https://gist.githubusercontent.com/Fible1/abc4317c4f381f9168210fac7f5350cf/raw/b1b44e7e1ddc4e846699f18558e44a4ee4461f0d/install-celestia.sh | bash
```
Credit **fible1#2782**

## MANUAL INSTALL
## System Update
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git ncdu -y
sudo apt install make -y
```
## Installing Go
```
ver="1.19.1"
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
go version
```
## Install the celestia-node binary
```
cd $HOME 
rm -rf celestia-node 
git clone https://github.com/celestiaorg/celestia-node.git 
cd celestia-node/ 
git checkout tags/v0.8.0 
make build 
make install 
make cel-key 
```
Cek instalasi menggunakan perintah `celestia version` pastikan output
```
Semantic version: v0.8.0 
Commit: ef582655342c73384a66314972428b152227e428 
Build Date: Thu Dec 15 10:19:22 PM UTC 2022 
System version: amd64/linux 
Golang version: go1.19.1
```
## Run & Save Mnemonic
```
./cel-key list --node.type light --p2p.network blockspacerace
```
## Create Service
```
sudo tee <<EOF >/dev/null /etc/systemd/system/celestia-lightd.service
[Unit]
Description=celestia-lightd Light Node
After=network-online.target

[Service]
User=$USER
ExecStart=/usr/local/bin/celestia light start --core.ip https://celestia-testnet.rpc.kjnodes.com --core.rpc.port 26657 --core.grpc.port 9090 --keyring.accname my_celes_key --metrics.tls=false --metrics --metrics.endpoint otel.celestia.tools:4318 --gateway --gateway.addr localhost --gateway.port 26659 --p2p.network blockspacerace
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF
```
saya menggunakan rpc dari kj nodes, anda bisa menggantinya dengan rpc yang ada di list ini https://docs.celestia.org/nodes/blockspace-race/#rpc-endpoints

## Run Service & Cek Log
```
systemctl enable celestia-lightd
systemctl start celestia-lightd
journalctl -u celestia-lightd.service -f
```
## Cek Node ID
```AUTH_TOKEN=$(celestia light auth admin --p2p.network blockspacerace)```
```
curl -X POST \
     -H "Authorization: Bearer $AUTH_TOKEN" \
     -H 'Content-Type: application/json' \
     -d '{"jsonrpc":"2.0","id":0,"method":"p2p.Info","params":[]}' \
     http://localhost:26658
```

Akan menghasilkan node ID diawali dengan="12D....." Cek uptim Node di https://tiascan.com/light-nodes. 
NOTE: /root/.celestia-light-blockspacerace-0 jangan lupa backup keys folder

## Other Command
Cek Service 
```
systemctl status celestia-lightd
```
Restart Node
```
systemctl restart celestia-lightd
```
Stop Node
```
systemctl stop celestia-lightd
```

