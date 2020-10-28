#!/bin/sh
#Data
width_pixel="$1"
width_mm="$2"
height_pixel="$3"
height_mm="$4"
adapter="$5"
active_monitors="$6"

#First monitor 80% width and 90% height
width_pixel_80=$(( width_pixel * 80/100 ))
width_mm_80=$(( width_mm * 80/100 ))
height_pixel_90=$(( height_pixel * 90/100 ))
height_mm_90=$(( height_mm * 90/100 ))

#Second monitor 20% width and 90% height (Already calculated)
width_pixel_20=$(( width_pixel * 20/100 ))
width_mm_20=$(( width_mm * 20/100 ))

#Third monitor 100% width and 10% height
height_pixel_10=$(( height_pixel * 10/100 ))
height_mm_10=$(( height_mm * 10/10 ))

#Get the values of the new percentajes:
new_screens_values() {
	echo "Screen 1:${width_pixel_80}x${height_pixel_90}" > ~/TvPost/Resolutions/new_resolutions.txt
	echo "Screen 2:${width_pixel_20}x${height_pixel_90}" >> ~/TvPost/Resolutions/new_resolutions.txt
	echo "Screen 3:${width_pixel}x${height_pixel_10}" >> ~/TvPost/Resolutions/new_resolutions.txt
}
	
function split_screen_80_20_10() {
	xrandr --setmonitor ${adapter}~1 ${width_pixel_80}/${width_mm_80}x${height_pixel_90}/${height_mm_90}+0+0 ${adapter}
	xrandr --setmonitor ${adapter}~2 ${width_pixel_20}/${width_mm_20}x${height_pixel_90}/${height_mm_90}+${width_pixel_80}+0 none
	xrandr --setmonitor ${adapter}~3 ${width_pixel}/${width_mm}x${height_pixel_10}/${height_mm_10}+0+${height_pixel_90} none
	
}

#It only creates the monitors if the 80/20/10 is not
#already selected

#Creates monitor 80/20/10
if [ ${active_monitors} == 1 ]; then
	#echo "entré al if"
	#Creates the screens
	split_screen_80_20_10
	
	#Calling the function to write the new values in txt
	new_screens_values
	
	echo "Cambiado a 802010"
fi
	
#If there are 2 active_monitors then deletes them and recreates them
if [ ${active_monitors} == 2 ]; then
	xrandr --delmonitor ${adapter}~1
	xrandr --delmonitor ${adapter}~2
	
	#Creates the screens
	split_screen_80_20_10
	
	#Calling the function to write the new values in txt
	new_screens_values
	
	echo "Cambiado a 802010"
fi


#if [ -z "$(xrandr --listactivemonitors | grep '${adapter}~1')" ]; then
#	xrandr --setmonitor ${adapter}~1 ${width_pixel_80}/${width_mm_80}x${height_pixel_90}/${height_mm_90}+0+0 ${adapter}
#	xrandr --setmonitor ${adapter}~2 ${width_pixel_20}/${width_mm_20}x${height_pixel_90}/${height_mm_90}+${width_pixel_80}+0 none
#	xrandr --setmonitor ${adapter}~3 ${width_pixel}/${width_mm}x${height_pixel_10}/${height_mm_10}+0+${height_pixel_90} none
#	echo "El tamaño de la pantalla izquierda es: ${width_pixel_80}x${height_pixel_90}"
#	echo "El tamaño de la pantalla derecha es: ${width_pixel_20}x${height_pixel_90}"
#	echo "El tamaño de la pantalla inferior es: ${width_pixel}x${height_pixel_10}"
#else
#	xrandr --delmonitor ${adapter}~1
#	xrandr --delmonitor ${adapter}~2
#	xrandr --delmonitor ${adapter}~3
#	
#fi
