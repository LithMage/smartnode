#!/bin/bash
# upgrade.sh
# Modified version by Rimvydas V.
# Make sure smartcash is up-to-date
# Script should be on root user
# Add the following to the crontab (i.e. sudo crontab -e) from user wallet is on
# */120 * * * * ~root/smartnode/upgrade.sh

if apt list --upgradable | grep -v grep | grep smartcashd > /dev/null
then
    snuser=$(cat ~root/smartnode/snuser)
    # Make sure makerun and checkdaemon on user knows we about to upgrade wallet
    echo $(date) > ~root/smartnode/MAINTENANCE
    cp ~root/smartnode/MAINTENANCE /home/$snuser/smartnode/MAINTENANCE
    chmod 0666 /home/$snuser/smartnode/MAINTENANCE

    su $snuser -c 'smartcash-cli stop'
    sleep 20
    apt update && apt install smartcashd -y
    sleep 20
    su $snuser -c 'smartcashd'

    # Remove MAINTENANCE file so makerun and checkdaemon works as usual
    rm /home/$snuser/smartnode/MAINTENANCE
else
    exit
fi