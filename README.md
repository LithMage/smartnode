# SmartNode Upkeep Scripts
### Simplified version of original script from https://github.com/SmartCash/smartnode
### ATTENTION: This installer does not include anti-ddos script and upgrade script.

#### This shell script comes with 4 cronjobs: 
1. Make sure the daemon is always running: `makerun.sh`
2. Make sure the daemon is never stuck: `checkdaemon.sh`
3. Upgrade script and its cronjob onto root user: `upgrade.sh`
4. Adds truncation for debug.log every 15 min.
- These scripts are downloaded from original Git: https://github.com/SmartCash/smartnode

#### Login to your vps with user used to install wallet, donwload the install.sh file and then run it:
```
wget -O ~/install_simple_upkeep.sh https://raw.githubusercontent.com/LithMage/smartnode/simplified/install_simple_upkeep.sh
bash ~/install_simple_upkeep.sh
```

#### Script will reboot your server.
 This is to make sure cron jobs are activated and working properly. Wallet should be started within 1min.
 To check login back into vps and repeat command:
 ```
 smartcash-cli getinfo
 ```
 once wallet starts this will return information on current block, etc.
 
 To check on node status please use command:
 ```
 smartcash-cli smartnode status
 ```


#### Your node now should be always running. BEE $SMART! https://smartcash.cc
