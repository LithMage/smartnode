#!/bin/bash
# makerun.sh
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
    $makerun &
fi