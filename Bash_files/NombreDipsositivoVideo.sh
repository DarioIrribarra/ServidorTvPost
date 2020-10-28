#!/bin/sh

#Pattern to match 
#regex='\*(.+)\s([0-9]+)\/([0-9]+)x([0-9]+)\/([0-9]+)'
regex='0:\s\+?\*?([A-Za-z0-9-]+)'
#regexsinmaspantallas='\*([a-zA-Z-0-9]+)'
#regexconmaspantallas='\:\s([a-zA-Z-0-9]+)'
#Getting the value of width and length in pixels and milimeters
value=$(xrandr --listmonitors)
if [[ $value =~ $regex ]]; then
	echo ${BASH_REMATCH[1]}
fi
