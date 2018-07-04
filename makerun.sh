#!/bin/bash
# makerun.sh
# Version: 2018.07.04
# Modified version by Rimvydas V.
# Make sure smartcashd is always running.
# Add the following to the crontab (i.e. crontab -e)
# */5 * * * * ~/smartnode/makerun.sh

process=smartcashd
makerun="smartcashd"

if ps ax | grep -v grep | grep $process > /dev/null || [ -f ~/smartnode/MAINTENANCE ]
then
    exit
else
    echo "makerun.sh     : $(date)" >> ~/smartnode/log
    $makerun &
fi