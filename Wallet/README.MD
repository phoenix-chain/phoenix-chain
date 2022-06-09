# Wallet Setup

This is a guide for using the keosd wallet on Linux. You can also use the [Anchor wallet](https://greymass.com/en/anchor/) on mobile or desktop if you like a good GUI.

To set up your local wallet using keosd will assume that you have already installed EOSIO software by following the instructions in the main [README](../README.md)


Assumes you are in the ./Wallet/ directory of this repo... 

- Start wallet software, run  
```
cd /opt/phoenix-chain
./start_wallet.sh  
```

- Create your wallet file  
```
../cleos.sh wallet create --name phoenix --file ~/pass.pw
```
Your password will be in pass.pw it will be used when unlock wallet  


- Unlock your wallet using the password file you created in the previous step
```
../cleos.sh wallet unlock --name phoenix --password < ~/pass.pw
```


- Import your key  
```
../cleos.sh wallet --name phoenix import
```
Enter your private key  
