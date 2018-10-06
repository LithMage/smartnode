# SmartNode Upkeep Scripts
# Version: 2018.07.04
### Streamlined version of original scripts from https://github.com/SmartCash/smartnode
### ATTENTION: This installer does not include anti-ddos script.

## This is not full bash node installer!

#### This shell script will install 4 cronjobs (including upgrade): 
1. Make sure the daemon is always running: `makerun.sh` script
2. Make sure the daemon is never stuck: `checkdaemon.sh` script
3. Optional: Upgrade script and its cronjob onto root user: `upgrade.sh` script (will be placed on root)
4. Adds truncation for debug.log every 15 min. (Thanks to @thoriumbr#3917 on discord)

#### Login to your vps with user used to install wallet (thats the one you made `.smartcash` folder and smartcash.conf file. DO NOT MIX IT UP!

#### Make sure you have enough space to be able to download scripts (this will empty log file):
```
truncate --size 0 ~/.smartcash/debug.log
```

#### Download the install_simple_upkeep.sh file and then run it:
```
wget --output-document ~/install_simple_upkeep.sh https://goo.gl/oQ2zbt
bash ~/install_simple_upkeep.sh
```
or longer version but known where it comes from ;)
```
wget --output-document ~/install_simple_upkeep.sh https://raw.githubusercontent.com/LithMage/smartnode/simplified/install_simple_upkeep.sh
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
 
#### If you want to use upgrade.sh without waiting on cronjob
This command will start the upgrade proccess immediately
```
sudo ~root/smartnode/upgrade.sh
```
After upgrade is done daemon is restarted with forced reindexing of database (may take 15+ min).

To disable upgrade script checking daily please run this command to disable its cronjob
```
sudo crontab -l | sed '/smartnode\/upgrade.sh/d' | sudo crontab -
```
To add it back to daily auto check for updates
```
(sudo crontab -l; echo "0 * */1 * * ~root/smartnode/upgrade.sh") | sudo crontab -
```
 
# Advanced usage for diagnostics / manual wallet update

#### At any time user can check if any of scripts has been triggered by running:
```
cat ~/smartnode/log
```

#### If there is a need to manualy disable makerun and checkdaemon just make a MAINTENANCE file inside smartnode folder:
```
touch ~/smartnode/MAINTENANCE
```
#### To enable them again, just remove the file:
```
rm ~/smartnode/MAINTENANCE
```


#### Your node now should be always running. BEE $SMART! https://smartcash.cc

### Got questions about this script? Contact me on Smartcash Discord (user: LithStud#4168 )
#### Thanks to Zaphoid#5003 for letting me bounce questions about linux!
#### Thanks to dustinface#6318 for helping to find a bug with upgrade.sh!
#### Thanks to keydos#3928 for that one node as guinea pig ;)
