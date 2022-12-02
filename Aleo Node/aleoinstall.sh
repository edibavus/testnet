#!/bin/bash
echo -e ''
curl -s https://github.com/edibavus/testnet/blob/main/logo.sh | bash && sleep 3
echo -e ''
GREEN="\e[32m"
NC="\e[0m"
RED='\033[0;31m'
YELLOW='\033[1;33m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'

dependencies () {
sudo apt-get update
echo -e ''
echo -e ${GREEN}'Wait for update & deps...\e[0m'${NC} && sleep 3
echo -e ''
sudo apt-get install build-essential curl git clang gcc libssl-dev llvm make pkg-config tmux xz-utils -y
echo -e ''
echo -e ${GREEN}'İnstalling Rust...\e[0m'${NC} && sleep 3
echo -e ''
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
echo -e ''
}

binaries () {
    cd $HOME
    echo -e ${GREEN}'Downloading Binaries...\e[0m'${NC} && sleep 3
    echo -e ''
    git clone https://github.com/AleoHQ/snarkOS.git --depth 1 && cd snarkOS
    cargo install --path .
    sudo mv $HOME/snarkOS/target/release/snarkos /usr/bin
}

run_client () {
    echo -e ''
    echo -e ${YELLOW}'Running Client Node...\e[0m'${NC} && sleep 4
    sudo tee <<EOF >/dev/null /etc/systemd/system/clientd.service
[Unit]
Description=Aleo Client Daemon
After=network-online.target

[Service]
User=root
WorkingDirectory=$HOME/snarkOS
ExecStart=$HOME/.cargo/bin/cargo run --release -- start --nodisplay
Restart=always
RestartSec=3
LimitNOFILE=infinity

[Install]
WantedBy=multi-user.target
EOF

cat /etc/systemd/system/clientd.service
sudo systemctl enable clientd
systemctl start clientd
}

run_prover () {
    echo -e ''
    echo -e ${YELLOW}'Running Prover Node...'${NC} && sleep 3
    snarkos account new >> $HOME/wallet.json
    WALLET=$(cat $HOME/wallet.json) 
    PRIV_KEY=$(cat $HOME/wallet.json | cut -d ' ' -f6 | awk 'NR==2{print $1}')
    source $HOME/.cargo/env
    sudo tee <<EOF >/dev/null /etc/systemd/system/proverd.service
[Unit]
Description=Aleo Prover Daemon
After=network-online.target

[Service]
User=root
WorkingDirectory=$HOME/snarkOS
ExecStart=$HOME/.cargo/bin/cargo run --release -- start --nodisplay --prover $PRIV_KEY
Restart=always
RestartSec=3
LimitNOFILE=infinity

[Install]
WantedBy=multi-user.target
EOF

cat /etc/systemd/system/proverd.service
sudo systemctl daemon-reload
sudo systemctl enable proverd
sudo systemctl restart proverd

    echo -e ''
    echo -e "#################################################################"
    LOG_SEE="journalctl -fo cat -u proverd"
    echo -e "Check logs: ${YELLOW}$LOG_SEE${NC}"
    echo -e "#################################################################"
    echo -e ''
    echo -e ''
    echo -e "#################################################################"
    echo -e "Your wallet keys * SAVE!!: ${GREEN}$WALLET${NC}"
    echo -e "#################################################################"
    echo -e ''
}


info () {
    echo -e ''
    echo -e "#################################################################"
    LOG_SEE="journalctl -fo cat -u clientd"
    echo -e "Check logs: ${YELLOW}$LOG_SEE${NC}"
    echo -e "#################################################################"
    echo -e ''
}

PS3="What do you want?: "
select opt in Install-Client Install-Prover Update Additional quit; 
do

  case $opt in
    Install-Client)
    echo -e '\e[1;32mThe installation process begins...\e[0m'
    sleep 1
    dependencies
    binaries
    run_client
    info
    sleep 3
      break
      ;;
    Install-Prover)
    echo -e '\e[1;32mThe installation process begins...\e[0m'
    sleep 1
    dependencies
    binaries
    run_prover
    sleep 3
      break
      ;;
    Update)
    echo -e '\e[1;32mThe updating process begins...\e[0m'
    echo -e ''
    echo -e '\e[1;32mSoon...'
    info
    sleep 1
      break
      ;;
    Additional)
    info
      ;;
    quit)
    echo -e '\e[1;32mexit...\e[0m' && sleep 1
      break
      ;;
    *) 
      echo "Invalid $REPLY"
      ;;
  esac
done