#!/bin/sh

#Pattern to match 
#regex='\*(.+)\s([0-9]+)\/([0-9]+)x([0-9]+)\/([0-9]+)'
regex='.+\+\*?(.+)\s([0-9]+)\/([0-9]+)x([0-9]+)\/([0-9]+)'
#Getting the value of width and length in pixels and milimeters
value=$(xrandr --listmonitors)
[[ $value =~ $regex ]]

echo "--RESOLUTION VALUES--" > ~/TvPost/Resolutions/base_resolution.txt
echo "Total="${BASH_REMATCH[0]} >> ~/TvPost/Resolutions/base_resolution.txt
echo "Width in pixels:-"${BASH_REMATCH[2]} >> ~/TvPost/Resolutions/base_resolution.txt
echo "Width in milimeters:-"${BASH_REMATCH[3]} >> ~/TvPost/Resolutions/base_resolution.txt
echo "Height in pixels:-"${BASH_REMATCH[4]} >> ~/TvPost/Resolutions/base_resolution.txt
echo "Height in milimeters:-"${BASH_REMATCH[5]} >> ~/TvPost/Resolutions/base_resolution.txt
echo "Adapter value:-"${BASH_REMATCH[1]} >> ~/TvPost/Resolutions/base_resolution.txt
exit 0

#echo total_width_height=${BASH_REMATCH[0]}
#echo width_pixel=${BASH_REMATCH[2]}
#echo width_mm=${BASH_REMATCH[3]}
#echo height_pixel=${BASH_REMATCH[4]}
#echo height_mm=${BASH_REMATCH[5]}
#echo Adapter=${BASH_REMATCH[1]}

#totals=(${width_pixel} ${width_mm} ${height_pixel} ${height_mm})
	
#prints all the array

#echo ${totals[*]}
