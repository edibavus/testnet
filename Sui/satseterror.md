INSTAL SUI 

```bash
sudo apt update
sudo apt install -y jq curl build-essential libssl-dev
```

```bash
version=$(wget -qO- https://api.github.com/repos/nodejumper-org/sui/releases/latest | jq -r ".tag_name")
curl -L https://github.com/nodejumper-org/sui/releases/download/${version}/sui-linux-amd64-${version}.tar.gz > sui-linux-amd64-latest.tar.gz
sudo tar -xvzf sui-linux-amd64-latest.tar.gz -C /usr/local/bin/
rm -rf sui-linux-amd64-latest.tar.gz
sui-node -V # sui-node 0.16.0
sui -V # sui 0.16.0
```

```bash
mkdir $HOME/.sui
curl -L https://github.com/MystenLabs/sui/raw/main/crates/sui-config/data/fullnode-template.yaml > $HOME/.sui/fullnode.yaml
curl -L https://github.com/MystenLabs/sui-genesis/raw/main/devnet/genesis.blob > $HOME/.sui/genesis.blob
```

```bash
sed -i "s|db-path:.*|db-path: $HOME/.sui/db|g" $HOME/.sui/fullnode.yaml
sed -i "s|genesis-file-location:.*|genesis-file-location: $HOME/.sui/genesis.blob|g" $HOME/.sui/fullnode.yaml
```

```bash
sudo tee /etc/systemd/system/suid.service > /dev/null << EOF
[Unit]
Description=Sui Node
After=network-online.target
[Service]
User=$USER
ExecStart=$(which sui-node) --config-path $HOME/.sui/fullnode.yaml
Restart=on-failure
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable suid
sudo systemctl restart suid
```

```bash
sudo journalctl -u suid -f --no-hostname -o cat
```
