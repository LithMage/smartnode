#!/bin/bash
# upgrade.sh
# Version: 2018.06.22
# Modified version by Rimvydas V.
# Make sure smartcash is up-to-date
# Script should be on root user
# Add the following to the crontab (i.e. sudo crontab -e) from user wallet is on
# 0 * */1 * * ~root/smartnode/upgrade.sh

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

apt update

if apt list --upgradable | grep -v grep | grep smartcashd > /dev/null
then
    echo "Upgrade in progress $(date)"
    snuser=$(cat ~root/smartnode/snuser)
    # Make sure makerun and checkdaemon on user knows we about to upgrade wallet
    echo $(date) > ~root/smartnode/MAINTENANCE
    # Move maintenance file only if wallet user is not root
    if [ "$snuser" != "root" ]
    then
        cp ~root/smartnode/MAINTENANCE /home/$snuser/smartnode/MAINTENANCE
        chmod 0666 /home/$snuser/smartnode/MAINTENANCE
    fi

    su $snuser -c 'smartcash-cli stop'
    sleep 10
    apt install smartcashd -y
    
    # Remove peers file
    if [ "$snuser" != "root" ]
    then
        rm /home/$snuser/.smartcash/peers.*
    else
        rm ~root/.smartcash/peers.*
    fi
    
    su $snuser -c 'smartcashd -reindex'

    # Remove MAINTENANCE file so makerun and checkdaemon works as usual
    if [ "$snuser" != "root" ]
    then
        rm /home/$snuser/smartnode/MAINTENANCE
    else
        rm ~root/smartnode/MAINTENANCE
    fi
    echo "Upgrade done."
else
    exit
fi
