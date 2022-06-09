# Block Producer / Validator Hardware and Install Notes 

Below you will find installation tips and notes for running a Phoenix Validator. Highly recommend reading all of this before continuing.

You will need to run a node and produce blocks on the testnet before gaining approval to run a producer on the mainnet.

## Operating System and Hardware Requirements
- Bare metal or a physical server with no virtulization in use (Dedicated hardware)
- Ubuntu 18.04 LTS or Ubuntu 20.04 LTS - not recommended to use Ubuntu 22 or older than Ubuntu 18.
- Fast single-threaded CPU 3.5 Ghz+ (the faster, the better)
- 16GB RAM
- 250GB NVME 
- Ubuntu 18.04 (Recommended) or Ubuntu 20.04 (For the brave)
- Please note that mainnet validators will require dedicated servers with 32GB RAM and fast CPUs. Dedicated hardware is recommended and usually cheaper than running on AWS. Companies such as PhoenixNap and Psychz offer dedicated servers for as little as $75/month. Compared to AWS, the t2.xlarge instance type for the testnet ($130 USD /month unless you have credits). It's also possible to run more than one validator on a single hardware node by using different directories and ports.
- Open TCP Ports (8888, 9876) on your firewall/router  

### You will need 16GB on Testnet and 32GB on Mainnet
* Testnet requires 16384
* Mainnet requires 32096

## Tuning your CPU for performance on Linux

We highly recommend tuning your hardware to maximize your computer's ability to process blocks during your round of validation. Collectively, these settings will make Phoenix chain much faster if correctly implemented on good quality hardware.

* Install cpu tuning software
`apt-get install cpufrequtils linux-tools-common`

* Get current CPU tuning settings - look for "current CPU frequency" and "The governor `name` may decide" 
`cpufreq-info` 

* Change your CPU governer to performance mode:
`cpupower frequency-set --governor performance`

* Check if it worked 
`cpufreq-info` 

* Then set to do this on each reboot
`echo GOVERNOR="performance" > /etc/default/cpufrequtils`

## Config.ini Settings
This is VERY IMPORTANT to get done correctly. You should be using the [Producer/config.ini](config.ini) as a basis for running a validator / producer node. You will need to add the following tweaks to include the correct RAM capacity for your chain-state, updated and correct peers for the chain, your p2p-listen-address, and your agent / producer names.
  - signature-provider = <producer_signing_pub_key>=KEY:<producer_signing_priv_key> # set signing keys (needs to match key  
  - agent-name = <devicename>  # set an arbitrary short name here
  - producer-name = <youraccountname>
  - Update peers in config.ini by doing `cat peers.ini >> config.ini`
  - Check chain-state-db-size-mb value in config.ini - it should be not bigger than the RAM you have available - see below for info on how to measure and configure your RAM appropriately
    `chain-state-db-size-mb = 16384  `
### Measure Physical RAM 

* To check the available RAM on your system, type:
`awk '/MemTotal/ {printf( "%.2f\n", $2 / 1024 )}' /proc/meminfo |  awk '{print int($0)}'`

* Put a lesser number into your config.ini for testnet:
```
chain-state-db-size-mb = 16384
```
* Or if on mainnet:
```
chain-state-db-size-mb = 32096
```

## Registering as a validator 

### Step 1 - prep your node and info
You will need the following before you register. 
* A fully synchronized nodeos node with a validator / producer config.ini file
* YOUR_ACCOUNT_NAME - this is your account name
* SIGNING_KEY - the key you configured in your config.ini
* LOCATION_CODE - Your [ISO 3166 Country Code](https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes)
* WEBSITE - Your website where your bp.json can be found (see below)

#### bp.json 
  First, build and host your "bp.json" on your domain at <yourdomain>/bp.json - if you are validating on multiple chains, then you may also need to include a phoenix.json referenced by chain_id in your chains.json. 
  * You can generate one using the [BP.JSON generator tool](https://phoenix-testnet.eosio.online/bpjson)
  * Example bp.json from EOS Nation: [bp.json](https://eosnation.io/bp.json)
  * Example chains.json from EOS Nation: [chains.json](https://eosnation.io/chains.json)

### Step 2 - setup your wallet on your node
  Check out the [wallet setup readme](../../Wallet/README.MD) and scripts there to get keosd (keys daemon) and wallet files set up on your server so you can sign transactions.
### Step 3 - Register, Stake, Vote
There are 3 steps in step 3, but you can update your account name, key, website, LIBRE amount and location in the script[reg-stake-vote.sh](reg-stake-vote.sh) and it will run these for you.

To register as Validator:
  ```
  ./cleos.sh system regproducer YOUR_ACCOUNT_NAME SIGNING_PUBKEY "YOUR_WEBSITE" LOCATION_CODE -p YOUR_ACCOUNT_NAME
  ```

You may need to visit the [faucet](https://phoenix-testnet.eosio.online/faucet) before staking and adjust the amounts below to match whatever tokens you have received. You can't stake more tokens than you got from the faucet!! To check your balance, you can run `./cleos.sh get currency balance eosio.token YOUR_ACCOUNT_NAME`
```
./cleos.sh transfer <YOUR_ACCOUNT_NAME> stake.libre "10000 LIBRE" "stakefor:365"
```

You can only vote for one validator from each account, so for now - be selfish and vote yourself in.
```
./cleos.sh push action eosio voteproducer '{"voter": "YOUR_ACCOUNT_NAME", "producer": "YOUR_ACCOUNT_NAME"}' -p YOUR_ACCOUNT_NAME@active
```