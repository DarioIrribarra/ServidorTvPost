#!/bin/sh
#Data
width_pixel="$1"
width_mm="$2"
height_pixel="$3"
height_mm="$4"
adapter="$5"
active_monitors="$6"

#Monitors 50% width and 100% height
width_pixel_50=$(( width_pixel * 50/100 ))
width_mm_50=$(( width_mm * 50/100 ))

#Get the values of the new percentajes:
new_screens_values() {
	echo "Screen 1:${width_pixel_50}x${height_pixel}" > ~/TvPost/Resolutions/new_resolutions.txt
	echo "Screen 2:${width_pixel_50}x${height_pixel}" >> ~/TvPost/Resolutions/new_resolutions.txt
}
	
function split_screen_50_50() {
	xrandr --setmonitor ${adapter}~1 ${width_pixel_50}/${width_mm_50}x${height_pixel}/${height_mm}+0+0 ${adapter}
	xrandr --setmonitor ${adapter}~2 ${width_pixel_50}/${width_mm_50}x${height_pixel}/${height_mm}+${width_pixel_50}+0 none	
}

#It only creates the monitors if the 50/50 is not
#already selected

#Creates monitor 50/50
if [ ${active_monitors} == 1 ]; then

	#Creates the screens
	split_screen_50_50
	
	#Calling the function to write the new values in txt
	new_screens_values
	echo "Cambiado a 5050"
fi
	
#If there are 2 active_monitors then deletes them and recreates them
if [ ${active_monitors} == 3 ]; then
	xrandr --delmonitor ${adapter}~1
	xrandr --delmonitor ${adapter}~2
	xrandr --delmonitor ${adapter}~3
	
	#Creates the screens
	split_screen_50_50
	
	#Calling the function to write the new values in txt
	new_screens_values
	echo "Cambiado a 5050"
fi


