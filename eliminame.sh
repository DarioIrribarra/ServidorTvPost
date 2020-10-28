#!/bin/sh
function right_screen() {
	
	#Kill right acreen app
	kill_app_right_corner
	
	#If matches a gif, jpg or jpeg open with viewnior
	if [[ $file_in_screen_1 =~ $regex_image_nopng ]]
	then

		#runs the app
		viewnior $file_in_screen_1 &
		
		#Check fore new apps
		check_if_new_app_opened 
		
		#sleep 1
		active_window_2=$(xdotool getactivewindow)
		
		xdotool windowmove --sync $active_window_2 $(( ${width_1} + 1 )) 0;
		#sleep 1
		
		xdotool getactivewindow key F11 
		#Writing the id to later kill it
		echo "2:${active_window_2}-" >> ~/TvPost/Resolutions/window_id.txt
		return
	fi
	
	#If matches a png open with gpicview
	if [[ $file_in_screen_1 =~ $regex_image_png ]]
	then

		#runs the app
		gpicview $file_in_screen_1 &
		
		#Check fore new apps
		check_if_new_app_opened 
		
		#sleep 1
		active_window_2=$(xdotool getactivewindow)
		
		xdotool windowmove --sync $active_window_2 $(( ${width_1} + 1 )) 0;
		#sleep 1
		
		xdotool getactivewindow key F11 
		#Writing the id to later kill it
		echo "2:${active_window_2}-" >> ~/TvPost/Resolutions/window_id.txt
		return
	fi
		
	#If it matches a video open with vlc
	if	[[ $file_in_screen_1 =~ $regex_local_video ]]
	then
	
		#runs the app
		cvlc -A alsa,none --alsa-audio-device default --repeat $file_in_screen_1 &
		
		#Check fore new apps
		check_if_new_app_opened 
		
		#sleep 4
		active_window_2=$(xdotool getactivewindow)
		
		xdotool windowmove --sync $active_window_2 $(( ${width_1} + 1)) 0
		#Wait 1.5 seconds and then goes fullscreen
		#sleep 1.5
		xdotool mousemove --sync $(( ${width_1} + 100 )) 100
		
		#Goes fullscreen here
		sleep 1.5
		xdotool getactivewindow key f
		
		#Writing the id to later kill it
		echo "2:${active_window_2}-" >> ~/TvPost/Resolutions/window_id.txt
		return
	fi
		
	#If it matches a youtube link, open and play in full screen
	if [[ $file_in_screen_1 =~ $regex_youtube ]]
	then

		#Opening and moving chrome. Waiting 7 seconds and go fullscreen
		bash ~/TvPost/Bash_files/chromeos-browser.bash $file_in_screen_1 &

		check_if_new_app_opened;
		
		sleep 20
		
		active_window_2=$(xdotool getactivewindow)
		
		xdotool windowmove --sync $active_window_2 $(( ${width_1} + 10 )) 0;
		
		xdotool key --window $active_window_2 f 
		
		echo "2:${active_window_2}-" >> ~/TvPost/Resolutions/window_id.txt
		return
	fi
	
	#If it matches a url open with chromium
	if [[ $file_in_screen_1 =~ $regex_url_http_https ]] || [[ $file_in_screen_1 =~ $regex_url_www ]]
	then
		#runs the app
		bash ~/TvPost/Bash_files/chromeos-browser.bash $file_in_screen_1 &
		
		#Check fore new apps
		check_if_new_app_opened 
		
		active_window_2=$(xdotool getactivewindow)
		
		xdotool windowmove --sync $active_window_2 $(( ${width_1} + 10 )) 0 &

		#Writing the id to later kill it
		echo "2:${active_window_2}-" >> ~/TvPost/Resolutions/window_id.txt
	fi

}

