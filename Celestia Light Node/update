## **Update** v0.8.1 (31/03)

## Stop the node:
```
sudo systemctl stop celestia-lightd
```
## Update to v0.8.1:
```
cd celestia-node
git fetch
git checkout v0.8.1
make build
sudo make install
```
```
cd $HOME
cd .celestia-light-blockspacerace-0
sudo rm -rf blocks index data transients
```
```
Initialize light node (change “f5nodes” when configuring):
celestia light init --p2p.network blockspacerace
```
```
sudo systemctl enable celestia-lightd
sudo systemctl start celestia-lightd 
sudo journalctl -u celestia-lightd.service -f
```
