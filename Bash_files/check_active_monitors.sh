#!/bin/sh

#Check the amount of active monitors
regex=':\s([0-9]+)'
command=$(xrandr --listactivemonitors)
[[ $command =~ $regex ]]
monitors=${BASH_REMATCH[1]}

echo "${monitors}"

