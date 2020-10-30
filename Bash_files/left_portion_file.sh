#!/bin/sh

file_in_screen_1="$1"

file_type=$( bash /home/pi/TvPost/Bash_files/regex_file.sh "${file_in_screen_1}" )

#Moves to the correct portion of the screen
xdotool mousemove 0 40;
xdotool click 1;

#If matches gif, jpg or jpeg open with viewnior
if [ ${file_type} == "image_nopng" ]
then
	
	#runs the app
	viewnior $file_in_screen_1 &
	
	#Check fore new apps
	nueva_id=$( bash ~/TvPost/Bash_files/check_new_app_opened.sh )
		
	#moves the window
	active_window_1=${nueva_id}
	xdotool windowmove $active_window_1 0 0 

	#goes fullscreen
	xdotool getactivewindow key F11 
	
	#Writing the id to later kill it
	echo "1:${active_window_1}-" >> ~/TvPost/Resolutions/window_id.txt
	exit
fi

#If matches an png open with image viewer
if [ ${file_type} == "image_png" ]
then
	
	#runs the app
	gpicview $file_in_screen_1 &
	
	#Check fore new apps
	nueva_id=$( bash ~/TvPost/Bash_files/check_new_app_opened.sh )
		
	#moves the window
	active_window_1=${nueva_id}
	xdotool windowmove $active_window_1 0 0 

	#goes fullscreen
	xdotool getactivewindow key F11 
	
	#Writing the id to later kill it
	echo "1:${active_window_1}-" >> ~/TvPost/Resolutions/window_id.txt
	exit
fi

#If it matches a video open with vlc
if [ ${file_type} == "local_video" ]
then

	#runs the app
	cvlc -A alsa,none --alsa-audio-device default --repeat $file_in_screen_1 &
	
	#Check fore new apps
	nueva_id=$( bash ~/TvPost/Bash_files/check_new_app_opened.sh )
		
	#moves the window
	active_window_1=${nueva_id}
	xdotool windowmove $active_window_1 0 0 
	
	#Wait 1.5 seconds and then goes fullscreen
	#goes fullscreen
	sleep 1.5
	xdotool getactivewindow key f
	
	#Writing the id to later kill it
	echo "1:${active_window_1}-" >> ~/TvPost/Resolutions/window_id.txt
	exit
fi

#If it matches a youtube link, open and play in full screen
if [ ${file_type} == "online_youtube" ]
then

	#Opening and moving Chrome. Waiting seconds and go fullscreen
	bash ~/TvPost/Bash_files/chromeos-browser.bash $file_in_screen_1 &

	#Check fore new apps
	nueva_id=$( bash ~/TvPost/Bash_files/check_new_app_opened.sh )
		
	#moves the window
	active_window_1=${nueva_id}
	xdotool windowmove $active_window_1 0 0 
	sleep 20;
	
	#goes fullscreen
	xdotool key f $active_window_1
	
	echo "1:${active_window_1}-" >> ~/TvPost/Resolutions/window_id.txt
	exit
fi

#If it matches a url open with chromium
if [ ${file_type} == "online_browser" ]
then

	#runs the app
	bash ~/TvPost/Bash_files/chromeos-browser.bash $file_in_screen_1 &
	
	#Check fore new apps
	nueva_id=$( bash ~/TvPost/Bash_files/check_new_app_opened.sh )
		
	#moves the window
	active_window_1=${nueva_id}
	xdotool windowmove $active_window_1 0 0 
	
	#Writing the id to later kill it
	echo "1:${active_window_1}-" >> ~/TvPost/Resolutions/window_id.txt
	exit
fi
