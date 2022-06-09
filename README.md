# Guide to Installing PHOENIX Testnet Nodes

You will need to begin on the testnet before being approved for running on Phoenix Mainnet. Once you produce blocks for 1 week on Testnet, you will be eligible for mainnet.

Requirements for running a node include having datacenter-quality redundant internet / power backups, technical knowledge of Linux, and a good attitude!

Nodes all run the software called `nodeos` and there are various roles that your node can provide, based on the configuration you set in your `config,ini`. 

There are a few versions of the config.ini in this repo. You can use these examples to modify and run your local config.ini. You might want to take a minute to familiarize yourself with the differences before continuing.

* Basic config [phoenixNode/config.ini](phoenixNode/config.ini) - minimum you will need to get started synchronizing blocks. This node can be used as a "seed" node on the network to provide block sync to other nodes. 
* Validator config - [phoenixNode/Producer/config.ini](phoenixNode/Producer/config.ini) - minimum you will need to actualy sign and validate blocks.
* State History config [phoenixNode/State-History/config.ini](phoenixNode/State-History/config.ini) - specifically tweaked for providing state history - which can be used by [Hyperion History API](https://github.com/eosrio/hyperion-history-api/tree/v3.3.5)
* Advanced config [phoenixNode/Advanced/config.ini](phoenixNode/Advanced/config.ini) - can be used to tweak various settings.

## Important! 
* We highly recommend not running your node as the root user! Look up `useradd` and `visudo` if you need guidance on adding a new user account to your server.
* [Troubleshooting](#troubleshooting) for troubleshooting your node.
* [Wallet README](Wallet/) about setting up your wallet.
* [Validator README](phoenixNode/Producer/) about hardware requirements for running a validator / producer node.
* [State History README](phoenixNode/State-History/) about running state history (thank you!).

----------------------------------------------------------------------------------

## Chain Info

* Genesis.json - Please see the most recent [genesis.json](phoenixNode/genesis.json) file.
* P2P endpoints - All updated in the [peers.ini](phoenixNode/peers.ini) file.

----------------------------------------------------------------------------------

## Links

**Phoenix Testnet Telegram**

https://t.me/+BWHs_Biz7UdiY2Ix

**Phoenix History API Swagger Docs**  

https://hyperion.mindyourbitcoin.com/v2/docs  

**Phoenix Block Explorer**  
                                                                 
https://hyperion.mindyourbitcoin.com/v2/explore/

**Phoenix Network Monitor**

https://phoenix-testnet.eosio.online

----------------------------------------------------------------------------------

# To run a Phoenix TestNet node you need install EOSIO software. You can compile from sources or install from precompiled binaries.

## 1. Manual Installation  

You can either install from source or precompiled binaries. Precompiled is faster, but source is preferrable to advanced users.
### 1.1 Installing from sources  

A. Create folder, download sources, compile and install:  

```
mkdir /opt/eosio/src  
cd /opt/eosio/src  

git clone https://github.com/eosio/eos --recursive    
cd eos  

git checkout v2.1.0  
git submodule update --init --recursive   

./scripts/eosio_build.sh -P -y
./scripts/eosio_install.sh
```  

B. Copy binaries to keep old versions and make sym link to latest:  

```
mkdir /opt/eosio
mkdir /opt/eosio/v2.1.0
cp /opt/eosio/src/eos/build/programs/nodeos/nodeos /opt/eosio/v2.1.0/
cp /opt/eosio/src/eos/build/programs/cleos/cleos /opt/eosio/v2.1.0/
cp /opt/eosio/src/eos/build/programs/keosd/keosd /opt/eosio/v2.1.0/
ln -sf /opt/eosio/v2.1.0 /opt/eosio/bin
```

Now /opt/eosio/bin will point to latest binaries.  

### 1.2 Semi-Auto Install [Precompiled binaries]

A. Download the latest version of EOSIO for your Operating system from the EOSIO releases:  
https://github.com/EOSIO/eos/releases/tag/v2.1.0   
For example, for ubuntu 18.04 you need to download deb `eosio_2.1.0-1-ubuntu-18.04_amd64.deb`

To install it - use apt:  
```
apt install ./eosio_2.1.0-1-ubuntu-18.04_amd64.deb   
```
It will download all dependencies and install EOSIO to /usr/opt/eosio/v2.1.0  

B. Copy binaries to keep old versions and make sym link to latest:  

```
 mkdir -p /opt/eosio
 mkdir -p /opt/eosio/v2.1.0
 cp /usr/opt/eosio/v2.1.0/bin/nodeos /opt/eosio/v2.1.0/
 cp /usr/opt/eosio/v2.1.0/bin/cleos /opt/eosio/v2.1.0/
 cp /usr/opt/eosio/v2.1.0/bin/keosd /opt/eosio/v2.1.0/
 ln -sf /opt/eosio/v2.1.0/ /opt/eosio/bin
```

Boom. Now, /opt/eosio/bin will be pointed to the latest binaries. Next setup your phoenix scripts and configs.
## 2. Install PHOENIX Testnet Node Configs and Scripts 
    
```
    cd /opt
    git clone https://github.com/phoenix-chain/phoenix-chain.git

```

**In case you use a different data-dir folders -> edit all paths in files cleos.sh, start.sh, stop.sh, config.ini, Wallet/start_wallet.sh, Wallet/stop_wallet.sh**

### 2.1 Create Validator Account
-  to create an account on Phoenix test first you will need to create a key
   -  to create a key use `./generate_key.sh keyname` --> this will create a text file named "keyname" with the keys you generated you can also run  `./cleos.sh create key --to-console` if you do not want to create files. Please note - the public key you created should begin with "EOS" and the private key should begin with "5" - to not share the private key with anyone or they will be able to control your account.
   -  Once you have a key, to create an account on Testnet, go to https://phoenix-testnet.eosio.online/faucet and use your public key to create an acccount 
   -  If you have issues with the faucet or any other questions, please join the [Phoenix Testnet Telegram](https://t.me/+BWHs_Biz7UdiY2Ix)

### 2.2 Edit config.ini:  
Update your config.ini so your nodeos knows what do do! 
  - Add the updated peers list by copying and pasting the list from [peers.ini](phoenixNode/peers.ini) into the bottom of your config.ini file or run `cat peers.ini >> config.ini` 

### 2.3 Run nodeos 
Run the nodeos software and start getting blocks!!
  - To run use `./start.sh --genesis-json ./genesis.json --delete-all-blocks` to start nodeos fresh with all blocks deleted
  
### 2.4 Verify
Final step is to make sure you are actually getting blocks! 
   - To check logs after running nodeos use `tail -f stderr.txt` - if you see ranges synchronizing, then you are good... if you see other things, then check your config.ini and ask around in Telegram for help
  - If there are issues, run `./stop.sh` and even `killall nodeos` then start again using the command above - see [troubleshooting](#troubleshooting) section below! 

----------------------------------------------------------------------------------
## What's next??
So you want to be a validator/producer? Check out the [Producer README](phoenixNode/Producer/README.md)!!! 
- Once you get the chain running with the basic config.ini - you can setup a producer using the config.ini in the [Producer](phoenixNode/Producer/) directory. 

=================================================================================== 
# Troubleshooting

## Common Issues
* Incorrect peers or wrong genesis.json
  * Very important to make sure you have the correct peers in your config.ini and genesis.json specified when you run nodeos (via [start.sh](phoenixNode/start.sh))

* Incorrect nodeos command
  - Please note - The first run of nodeos should be with --delete-all-blocks and --genesis-json `./start.sh --delete-all-blocks --genesis-json genesis.json`
  - If there are issues, run `./stop.sh` and even `killall nodeos` then start again using the command above! 

* start.sh misconfigured
  * Is your start.sh misconfigured? Take a look at the paths and make sure that the bin directory is correctly specified to the location of your nodoes. Try typing `which nodeos`

* If you have issues with the faucet or any other questions, please join the [Phoenix Testnet Telegram](https://t.me/+BWHs_Biz7UdiY2Ix)

## How to check logs:
  - To check logs after running nodeos use `tail -f stderr.txt` - if you see ranges synchronizing, then you are good... if you see other things, then check your config.ini and ask around in Telegram for help
  - Check if node is running ok then you should see ranges of blocks synchronizing, if not, then run `./stop.sh` or `killall nodeos` - change your config.ini settings and try again.


