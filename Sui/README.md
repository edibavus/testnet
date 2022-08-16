# TUTORIAL INSTAL SUI

##  Start Up -initialize device
**Update system**
```bash
sudo apt update && sudo apt upgrade -y
```

**Firewall Settings**
>We will enable ports 8080 & 9000, don’t forget to enable your SSH port if you also require remote access.

```bash
sudo ufw allow 8080/tcp
sudo ufw allow 9000/tcp
sudo ufw allow 9184/tcp
sudo ufw allow 22/tcp        # sudo ufw allow ssh
sudo ufw enable
```
**Check status**
```bash
sudo ufw status  
```
## Install prerequisite software for Sui
```bash
sudo apt-get update \
&& DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC sudo apt-get install -y --no-install-recommends \
tzdata \
git \
ca-certificates \
curl \
build-essential \
libssl-dev \
pkg-config \
libclang-dev \
cmake
```
**Install Rust**
Check version
```bash
cargo --version
rustc --version
```
**Install Rust & Cargo**
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
```
```bash
rustup update stable
````
**Should you need to uninstall**
```bash
rustup self uninstall
```
## Install form Sui from Git
**Login github and fork** https://github.com/MystenLabs/sui
```bash
git clone https://github.com/<YOUR-GITHUB-USERNAME>/sui.git
```
**Change to our working directory**
```bash
cd sui
```
**Set up the Sui repository as a git remote**
```bash
git remote add upstream https://github.com/MystenLabs/sui
```
**Sync your fork**
```bash
git fetch upstream
```
**Switch `DEVNET` version
```bash
git checkout 8a29394515eaf520cc6fa54bca8ce0c22db0dbc8
```
**Build Binary**
```bash
cargo run --release --bin sui-node -- --config-path fullnode.yaml
```

**If an error occurs**
error: failed to get `config` as a dependency of package `sui-config v0.0.0 (/root/suirates/sui-config)`


Download Binary
```bash
version=`wget -qO- https://api.github.com/repos/SecorD0/Sui/releases/latest | jq -r ".tag_name"`; \
wget -qO- "https://github.com/SecorD0/Sui/releases/download/${version}/sui-linux-amd64-${version}.tar.gz" | tar -C /usr/bin/ -xzf -
```

Move binary files to the folder with binary files
```bash
mv $HOME/sui/target/release/{sui,sui-node,sui-faucet} /usr/bin/
```

Return to the home directory
```bash
cd
```

Download genesis
```bash
curl -fLJO https://github.com/MystenLabs/sui-genesis/raw/main/devnet/genesis.blob
```

Make copy
```bash
cp $HOME/sui/crates/sui-config/data/fullnode-template.yaml fullnode.yaml

```
`edit fullnode.yaml`

```bash
sudo nano fullnode.yaml
```
Edit metrics-address and json-rpc-address in the fullnode.yaml `127.0.0.1` to `0.0.0.0` 

## Create a System service to Run Sui
**Create Service**
```bash
sudo tee <<EOF >/dev/null /etc/systemd/system/sui-node.service
[Unit]
Description=Sui node
After=network-online.target
[Service]
User=$USER
WorkingDirectory=/$HOME/sui
ExecStart=/$HOME/.cargo/bin/cargo run --release --bin sui-node -- --config-path /$HOME/sui/fullnode.yaml
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
```


**Enable and Start our Service, this will start our node**
```bash
sudo systemctl enable sui-node
sudo systemctl daemon-reload
sudo systemctl start sui-node
```

**Check Status active**
```bash
sudo systemctl status sui-node
```
**Check Logs**
```bash
journalctl -u sui-node.service -f
```


**Check Your Node** 

https://node.sui.zvalid.com/

https://sui-node.info/



