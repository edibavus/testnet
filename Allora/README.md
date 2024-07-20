# ALLORA NODE

[zealy](https://zealy.io/cw/alloranetwork/invite/IU2cqqMstYG1pEtHTenpn)
[galxe](https://app.galxe.com/quest/AlloraNetwork)

this readme translate from [ruesandora](https://github.com/ruesandora/Allora/blob/main/README.md)

![image](https://github.com/ruesandora/Allora/assets/101149671/2e54ddbb-d33a-4165-9497-78417dc1c523)


<h1 align="center">SETUP</h1>

```console
# update 
sudo apt update & sudo apt upgrade -y

sudo apt install ca-certificates zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev curl git wget make jq build-essential pkg-config lsb-release libssl-dev libreadline-dev libffi-dev gcc screen unzip lz4 -y

sudo apt install python3
sudo apt install python3-pip

# Install Dockeri
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

VER=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)

curl -L "https://github.com/docker/compose/releases/download/"$VER"/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

sudo groupadd docker
sudo usermod -aG docker $USER
```

#

```console
# install go
sudo rm -rf /usr/local/go
curl -L https://go.dev/dl/go1.22.4.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bash_profile
echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> $HOME/.bash_profile
source .bash_profile
```

#

<h1 align="center">Allora and Wallet installation</h1>

```console
# allora instalasi
git clone https://github.com/allora-network/allora-chain.git
cd allora-chain && make all

# buat wallet (jangan lupa save mnemonic/import ke keplr)
allorad keys add nama_wallet
# import wallet
allorad keys add nama_wallet --recover
masukkan 24 kata
````

> Allora add chain [link](https://explorer.testnet-1.testnet.allora.network/wallet/keplr) 

> Allora dashboard [link](https://app.allora.network?ref=eyJyZWZlcnJlcl9pZCI6ImZmODdlMTU0LTMyOWEtNDg4Ny04ZjRlLTliMzc1ZmU0NjhhNCJ9) 

> Allora faucet [link](https://faucet.testnet-1.testnet.allora.network/)

#

<h1 align="center">Workers Installation </h1>

```console
cd $HOME
git clone https://github.com/allora-network/basic-coin-prediction-node

cd basic-coin-prediction-node

# buat folder
mkdir worker-data
mkdir head-data

# run file permission
sudo chmod -R 777 worker-data
sudo chmod -R 777 head-data

# create head key
sudo docker run -it --entrypoint=bash -v ./head-data:/data alloranetwork/allora-inference-base:latest -c "mkdir -p /data/keys && (cd /data/keys && allora-keys)"

# create worker key
sudo docker run -it --entrypoint=bash -v ./worker-data:/data alloranetwork/allora-inference-base:latest -c "mkdir -p /data/keys && (cd /data/keys && allora-keys)"
```

#

> Check head key/head-id

```console
cat head-data/keys/identity
```

> simpan id nya



```console
# remove docker-compose.yml
rm -rf docker-compose.yml
```

#

<h1 align="center">Connect to Allora</h1>

```console
# buat new docker-compose.yml dengan perintah ini
nano docker-compose.yml
```

> copy code dibawa. ganti `head-id` dengan yang tadi dan masukkan mnemonic di `24 kata mnemonic` CTRL X Enter

```console
version: '3'

services:
  inference:
    container_name: inference-basic-eth-pred
    build:
      context: .
    command: python -u /app/app.py
    ports:
      - "8000:8000"
    networks:
      eth-model-local:
        aliases:
          - inference
        ipv4_address: 172.22.0.4
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8000/inference/ETH"]
      interval: 10s
      timeout: 10s
      retries: 12
    volumes:
      - ./inference-data:/app/data

  updater:
    container_name: updater-basic-eth-pred
    build: .
    environment:
      - INFERENCE_API_ADDRESS=http://inference:8000
    command: >
      sh -c "
      while true; do
        python -u /app/update_app.py;
        sleep 24h;
      done
      "
    depends_on:
      inference:
        condition: service_healthy
    networks:
      eth-model-local:
        aliases:
          - updater
        ipv4_address: 172.22.0.5

  worker:
    container_name: worker-basic-eth-pred
    environment:
      - INFERENCE_API_ADDRESS=http://inference:8000
      - HOME=/data
    build:
      context: .
      dockerfile: Dockerfile_b7s
    entrypoint:
      - "/bin/bash"
      - "-c"
      - |
        if [ ! -f /data/keys/priv.bin ]; then
          echo "Generating new private keys..."
          mkdir -p /data/keys
          cd /data/keys
          allora-keys
        fi
        # Change boot-nodes below to the key advertised by your head
        allora-node --role=worker --peer-db=/data/peerdb --function-db=/data/function-db \
          --runtime-path=/app/runtime --runtime-cli=bls-runtime --workspace=/data/workspace \
          --private-key=/data/keys/priv.bin --log-level=debug --port=9011 \
          --boot-nodes=/ip4/172.22.0.100/tcp/9010/p2p/head-id \
          --topic=allora-topic-1-worker \
          --allora-chain-key-name=testkey \
          --allora-chain-restore-mnemonic='24 kata mnemonic' \
          --allora-node-rpc-address=https://allora-rpc.testnet-1.testnet.allora.network/ \
          --allora-chain-topic-id=1
    volumes:
      - ./worker-data:/data
    working_dir: /data
    depends_on:
      - inference
      - head
    networks:
      eth-model-local:
        aliases:
          - worker
        ipv4_address: 172.22.0.10

  head:
    container_name: head-basic-eth-pred
    image: alloranetwork/allora-inference-base-head:latest
    environment:
      - HOME=/data
    entrypoint:
      - "/bin/bash"
      - "-c"
      - |
        if [ ! -f /data/keys/priv.bin ]; then
          echo "Generating new private keys..."
          mkdir -p /data/keys
          cd /data/keys
          allora-keys
        fi
        allora-node --role=head --peer-db=/data/peerdb --function-db=/data/function-db  \
          --runtime-path=/app/runtime --runtime-cli=bls-runtime --workspace=/data/workspace \
          --private-key=/data/keys/priv.bin --log-level=debug --port=9010 --rest-api=:6000
    ports:
      - "6000:6000"
    volumes:
      - ./head-data:/data
    working_dir: /data
    networks:
      eth-model-local:
        aliases:
          - head
        ipv4_address: 172.22.0.100


networks:
  eth-model-local:
    driver: bridge
    ipam:
      config:
        - subnet: 172.22.0.0/24

volumes:
  inference-data:
  worker-data:
  head-data:
````

#

<h1 align="center">Start worker</h1>

```console
docker compose build
docker compose up -d
```

#

> cek node worker `docker ps` / `docker ps -a` 


<img width="444" alt="Ekran Resmi 2024-06-28 12 59 20" src="https://github.com/ruesandora/Allora/assets/101149671/e69e844d-a3da-4b76-9ead-930ce087afb9">

#

> `docker logs -f container_id` cek log

<img width="674" alt="Ekran Resmi 2024-06-28 13 00 23" src="https://github.com/ruesandora/Allora/assets/101149671/389e73a4-9e5f-4701-9b79-d22b7e5654bb">

> Sukses

# Done


