Preparations — Update Packages
``sudo apt update && sudo apt upgrade -y``

Preparations — Install Build Tools
``sudo apt -qy install curl git jq lz4 build-essential screen``

Install Docker & Docker Compose
``sudo apt install docker.io`` (Once the installation is complete, verify the version using the following command. The Docker version should be a minimum of 24.0.5.)
``docker --version`` (sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose)
``sudo chmod +x /usr/local/bin/docker-compose``
``docker-compose --version`` (Verify the Docker Compose version; it should be at least v2.24.5)

Clone The Starter Repository
``git clone https://github.com/ritual-net/infernet-container-starter``
``cd infernet-container-starter``

screen -S ritual
