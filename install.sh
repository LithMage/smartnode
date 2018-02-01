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

dir="~/smartnode"
if ! [ -d "$dir" ]
then
	echo "Creating $dir"
	mkdir $dir
fi

# Change the directory to ~/smartnode/
cd $dir

echo "Downloading scripts makerun, checkdaemon, upgrade, clearlog..."

# Download the appropriate scripts
wget https://raw.githubusercontent.com/SmartCash/smartnode/master/makerun.sh
wget https://raw.githubusercontent.com/SmartCash/smartnode/master/checkdaemon.sh
wget https://raw.githubusercontent.com/SmartCash/smartnode/master/upgrade.sh
wget https://raw.githubusercontent.com/SmartCash/smartnode/master/clearlog.sh

echo "Adding scripts to scheduler..."
# Create a cronjob for making sure smartcashd is always running
(crontab -l 2>/dev/null | grep -v -F "smartnode/makerun.sh" ; echo "*/1 * * * * ~/smartnode/makerun.sh" ) | crontab -
echo "makerun added"

# Create a cronjob for making sure the daemon is never stuck
(crontab -l 2>/dev/null | grep -v -F "smartnode/checkdaemon.sh" ; echo "*/30 * * * * ~/smartnode/checkdaemon.sh" ) | crontab -
echo "checkdaemon added"

# Create a cronjob for making sure smartcashd is always up-to-date
(crontab -l 2>/dev/null | grep -v -F "smartnode/upgrade.sh" ; echo "*/120 * * * * ~/smartnode/upgrade.sh" ) | crontab -
echo "upgrade added"

# Create a cronjob for clearing the log file
(crontab -l 2>/dev/null | grep -v -F "smartnode/clearlog.sh" ; echo "0 0 */2 * * ~/smartnode/clearlog.sh" ) | crontab -
echo "clearlog added"

echo "Making scripts executable..."
# Give execute permission to the cron scripts
chmod 0700 ./makerun.sh
chmod 0700 ./checkdaemon.sh
chmod 0700 ./upgrade.sh
chmod 0700 ./clearlog.sh

echo "ATENTION: Server will now be rebooted, you will be disconected and will need to login to server again."
echo "After reboot your wallet should be automatically started within 1min."
printf "Press Enter to continue: "
read IGNORE

# Reboot the server
echo "Rebooting."
sudo reboot
