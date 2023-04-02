install bahan
```
sudo apt install screen python3 python3-pip -y
pip install flask
```
download web_server.py
```
wget https://raw.githubusercontent.com/inklbot/celestia-ITN-PayForBlob-Transactions/main/web_server.py https://raw.githubusercontent.com/inklbot/celestia-itn/main/blob.sh
```
```
mkdir dashboard
cd dashboard
wget https://raw.githubusercontent.com/inklbot/celestia-ITN-PayForBlob-Transactions/main/index.html
cd
```
```
screen -S web
python3 web_server.py
```
check on browser https://yourip:5000
