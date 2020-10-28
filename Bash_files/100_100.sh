#!/bin/sh
#Base resolution Data
width_pixel="$1"
width_mm="$2"
height_pixel="$3"
height_mm="$4"
adapter="$5"
active_monitors="$6"

#Get the values of the new percentajes:
new_screens_values() {
	echo "Screen 1:${width_pixel}x${height_pixel}" > ~/TvPost/Resolutions/new_resolutions.txt
}
	
#function full_screen_100() {
	#xrandr --setmonitor ${adapter} ${width_pixel}/${width_mm}x${height_pixel}/${height_mm}+0+0 ${adapter}	
#}

#It only creates the monitors if the 100% is not
#already selected
if [ ${active_monitors} == 1 ]; then
	new_screens_values
fi


#If there are 2 active_monitors then deletes them and recreates them
if [ ${active_monitors} == 2 ]; then
	xrandr --delmonitor ${adapter}~1
	xrandr --delmonitor ${adapter}~2
	
	#Creates the screens
	#full_screen_100
	
	#Calling the function to write the new values in txt
	new_screens_values
	
	echo "Cambiado a 100"
fi


#Creates monitor 100%
if [ ${active_monitors} == 3 ]; then

	xrandr --delmonitor ${adapter}~1
	xrandr --delmonitor ${adapter}~2
	xrandr --delmonitor ${adapter}~3
	
	#Creates the screens
	#full_screen_100
	
	#Calling the function to write the new values in txt
	new_screens_values
	
	echo "Cambiado a 100"
	
fi
