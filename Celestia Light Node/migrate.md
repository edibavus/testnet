## Guide Migrate to New VPS
```
Backup keys `/root/.celestia-light-blockspacerace-0/keys` save to your local machine
```
Run light node on new vps [tutorial](https://github.com/edibavus/testnet/tree/main/Celestia%20Light%20Node) and wait for the new light node on the new machine to finish sync

Stop service on new vps and old vps
```
sudo systemctl stop celestia-lightd
```

## Recover your wallet (your seed phrase from old machine) 
check your wallet address is the same as your old wallet
```
cel-key add my_celes_key --recover --keyring-backend test --node.type light --p2p.network blockspacerace
```
> y
> Enter your bip39 mnemonic
...
## Upload keys from local machine better use ftp
## Setting init
```
celestia light init --p2p.network blockspacerace
```
Restart node again
```
sudo systemctl enable celestia-lightd
sudo systemctl daemon-reload
sudo systemctl start celestia-lightd && journalctl -u celestia-lightd -o cat -f
```
check your ID, if it is correct with the old ID then you have migrated successfully
```
NODE_TYPE=light
AUTH_TOKEN=$(celestia $NODE_TYPE auth admin --p2p.network blockspacerace)

curl -X POST \
     -H "Authorization: Bearer $AUTH_TOKEN" \
     -H 'Content-Type: application/json' \
     -d '{"jsonrpc":"2.0","id":0,"method":"p2p.Info","params":[]}' \
     http://localhost:26658
```
