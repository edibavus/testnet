## 1. METHOD CLI
```
wget https://raw.githubusercontent.com/inklbot/celestia-itn/main/blob.sh && sed -i 's/\r//' blob.sh && chmod +x blob.sh && sudo /bin/bash blob.sh
```
## RESULT

<img src="https://raw.githubusercontent.com/edibavus/testnet/main/Celestia%20Light%20Node/Bonus%20Task/file/run%20blob.sh.png">
<img src="https://raw.githubusercontent.com/edibavus/testnet/main/Celestia%20Light%20Node/Bonus%20Task/file/run%20blob1.sh.png">
<img src="https://raw.githubusercontent.com/edibavus/testnet/main/Celestia%20Light%20Node/Bonus%20Task/file/output.png">
<img src="https://raw.githubusercontent.com/edibavus/testnet/main/Celestia%20Light%20Node/Bonus%20Task/file/done.png">

## 2. METHOD UI
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

## RESULT
<img src="https://raw.githubusercontent.com/edibavus/testnet/main/Celestia%20Light%20Node/Bonus%20Task/file/Screenshot%202023-04-02%20165500.png">
<img src="https://raw.githubusercontent.com/edibavus/testnet/main/Celestia%20Light%20Node/Bonus%20Task/file/Screenshot%202023-04-02%20165544.png">
<img src="https://raw.githubusercontent.com/edibavus/testnet/main/Celestia%20Light%20Node/Bonus%20Task/file/Screenshot%202023-04-02%20165603.png">
<img src="https://raw.githubusercontent.com/edibavus/testnet/main/Celestia%20Light%20Node/Bonus%20Task/file/Screenshot%202023-04-02%20165651.png">
