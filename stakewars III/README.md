# TUTORIAL STAKEWARS III

<p align="center">
<img src="https://github.com/edibavus/testnet/blob/main/stakewars%20III/image/banner.jpg?raw=true"  width="600px"/>
<p>

Spec Minimum
| Hardware       | Chunk-Only Producer  Specifications                                   |
| -------------- | ---------------------------------------------------------------       |
| CPU            | 4-Core CPU with AVX support                                           |
| RAM            | 8GB DDR4                                                              |
| Storage        | 500GB SSD                                                             |
 
## Deploy VPS
> im using Azure,you can use AWS,Digitalocean,Linode etc.

- Di Azure Portal pilih `create resource`
 ![Screenshot_54](https://cybernauts.web.id/wp-content/uploads/2022/01/11.png)
 
- klik tab `Compute` dan pilih menu `Virtual machine`
 ![Screenshot_54](https://cybernauts.web.id/wp-content/uploads/2022/01/image-4.png)
 
- Isikan nama yang diinginkan 
![Screenshot_54](https://cybernauts.web.id/wp-content/uploads/2022/01/image-7.png)
 - Keterangan :
Subscription : Jenis paket langganan yang akan digunakan.
Resource Group : Sumberdaya yang akan digunakan. Apa itu Resource Manager?
Virtual machine name: Nama VM
Region : Lokasi Data Center
Image: OS(Operating Systems)
Size : Ukuran CPU dan RAM/Memory dan juga biaya sewa perbulan yang harus dibayar.
Untuk konfigurasi lainnya, biarkan default.

- Klik `create`
![Screenshot_54](https://cybernauts.web.id/wp-content/uploads/2022/01/image-8-1024x595.png)
- Done,copy your public IP di putty.Masukkan sesuai data yang dibuat tadi

### Untuk Login root anda harus mensetting dahulu azure anda
Di terminal run command
```bash
sudo su
cd
passwd root
```

Run
```bash
nano /etc/ssh/sshd_config

```
Maka akan menampilkan
![Screenshot_54](https://1.bp.blogspot.com/-pv4fTx0b9rQ/XzdmV9i_VPI/AAAAAAAAE7k/1LAAjZUkLEs8I4QKob3XHm67AbJgOdrlwCLcBGAsYHQ/w640-h551/permit%2Broot%2Blogin.png)
Lalu Ubah menjadi
![Screenshot_54](https://1.bp.blogspot.com/-es-U1WWiY38/XzdmcNKgD3I/AAAAAAAAE7o/5_msRds5uf0Mg9c59zO37pDu7tY5a4BRACLcBGAsYHQ/w640-h551/permit%2Broot%2Blogin%2Byes.png)

**Keterangan :**
Ubah `#PermitRootLogin prohibit-password` menjadi `PermitRootLogin yes`
Ubah `#PubkeyAuthentication yes` menjadi `PubkeyAuthentication no`
Untuk baris `PasswordAuthentication yes` biasanya sudah benar. Tetapi bila ditampilkan lain, misalnya `PasswordAuthentication no`, ubah menjadi `PasswordAuthentication yes`




## Useful links

Wallet: https://wallet.shardnet.near.org/

Explorer: https://explorer.shardnet.near.org/

## Challange

| Challenges | Description                             | Link                                                                              |
| ---------- | ------------------------------------- | --------------------------------------------------------------------------------- |
| 001        | Setup NEAR-CLI                        | [Tutorial](https://github.com/edibavus/testnet/blob/main/stakewars%20III/challange/1.md) |
| 002        | Setup Wallet dan Run Validator        | [Tutorial](https://github.com/edibavus/testnet/blob/main/stakewars%20III/challange/2.md) |
| 003        | Deploy a new staking pool for your validator                 | [Tutorial](https://github.com/edibavus/testnet/blob/main/stakewars%20III/challange/3.md) |
| 004        | Setup Tools for Monitoring Node Status        | [Tutorial](https://github.com/edibavus/testnet/blob/main/stakewars%20III/challange/4.md) |
| 005        | Make Article            | [Tutorial](https://github.com/near/stakewars-iii/blob/main/challenges/005.md "Tutorial") |
| 006        | Cron Task For Ping  | [Tutorial](https://github.com/edibavus/testnet/blob/main/stakewars%20III/challange/6.md) |



Form
Form Chunk-Only Producer Onboarding : https://nearprotocol1001.typeform.com/to/Z39N7cU9

Form for Submission Challenges 5-7	: [link](https://docs.google.com/forms/d/e/1FAIpQLScp9JEtpk1Fe2P9XMaS9Gl6kl9gcGVEp3A5vPdEgxkHx3ABjg/viewform "Form for Submission Challenges 5-7")
