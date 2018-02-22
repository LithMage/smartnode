#!/bin/bash
# install.sh
# Installs smartnode upkeep scripts
# Simplified version of original script from https://github.com/SmartCash/smartnode

# Warning that the script will reboot the server
echo "WARNING: This script will reboot the server when it's finished to activate scheduler."
printf "Press Ctrl+C to cancel or Enter to continue: "
read IGNORE

if ! (dpkg -s smartcashd | grep -F "ok installed") &>/dev/null; then
	echo "WARNING: These scripts uses PPA installed wallet commands."
	echo "FAILED TO DETECT such wallet commands"
	printf "Press Ctrl+C to cancel or Enter install scripts anyway: "
	read IGNORE
fi

if ! [ -d ~/.smartcash/ ] || ! [ -f ~/.smartcash/smartcash.conf ]
then
	echo "~/.smartcash folder not found. Make sure you are logged into user that has .smartcash folder."
	echo "Installation of Upkeep Scripts will be now terminated (no changes to system done)."
	exit
fi

if ! [ -d ~/smartnode/ ]
then
	echo "Creating ~/smartnode/"
	mkdir ~/smartnode/
fi

# Change the directory to ~/smartnode/
cd ~/smartnode/

# Record username to be used from root
echo $(whoami) > ./snuser

echo "Downloading scripts makerun, checkdaemon, clearlog..."

# Download the appropriate scripts
wget -O ./makerun.sh https://raw.githubusercontent.com/LithMage/smartnode/simplified/makerun.sh
wget -O ./checkdaemon.sh https://raw.githubusercontent.com/LithMage/smartnode/simplified/checkdaemon.sh
wget -O ./upgrade.sh https://raw.githubusercontent.com/LithMage/smartnode/simplified/upgrade.sh

# Create masternode folder for root and move upgrade specific files to it
# Remove upgrade.sh and snuser files from non root user
if ! [ $(id -u) -eq 0 ]
then
	sudo mkdir ~root/smartnode/
	sudo cp ./upgrade.sh ~root/smartnode/upgrade.sh
	sudo cp ./snuser ~root/smartnode/snuser
	rm ./upgrade.sh
	rm ./snuser
fi

echo "Adding scripts to scheduler..."
# Create a cronjob for making sure smartcashd is always running
(crontab -l 2>/dev/null | grep -v -F "smartnode/makerun.sh" ; echo "*/1 * * * * ~/smartnode/makerun.sh" ) | crontab -
echo "makerun added"

# Create a cronjob for making sure the daemon is never stuck
(crontab -l 2>/dev/null | grep -v -F "smartnode/checkdaemon.sh" ; echo "*/30 * * * * ~/smartnode/checkdaemon.sh" ) | crontab -
echo "checkdaemon added"

# Remove old script job if exist
crontab -l | sed '/smartcash\/debug.log/d'
# Create a cronjob for clearing the log file
(crontab -l 2>/dev/null | grep -v -F "truncate --size 0 ~/.smartcash/debug.log" ; echo "*/15 * * * * truncate --size 0 ~/.smartcash/debug.log" ) | crontab -
echo "clearlog added"

echo "Adding Upgrade cronjob to root user."
# Add upgrade script to root crontab
(sudo crontab -l 2>/dev/null | grep -v -F "smartnode/upgrade.sh" ; echo "*/120 * * * * ~root/smartnode/upgrade.sh" ) | sudo crontab -
echo "upgrade added to root"

echo "Making scripts executable..."
# Give execute permission to the cron scripts
chmod 0700 ./makerun.sh
chmod 0700 ./checkdaemon.sh
sudo chmod 0700 ~root/smartnode/upgrade.sh


echo "ATENTION: Server will now be rebooted, you will be disconected and will need to login to server again."
echo "After reboot your wallet should be automatically started within 1min."
printf "Press Enter to continue: "
read IGNORE

# Reboot the server
echo "Rebooting."
sudo reboot
