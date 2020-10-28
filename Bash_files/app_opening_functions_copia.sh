#!/bin/sh
#Create variables to assign the coordinates on the app
width_1=""
height_1=""
width_2=""
height_2=""
width_3=""
height_3=""

regex='([0-9]):([0-9]+)x([0-9]+)'
value=$( cat ~/TvPost/Resolutions/new_resolutions.txt )

#Get the number of lines to assign variables
number_lines=$( wc -l < ~/TvPost/Resolutions/new_resolutions.txt)


while IFS= read -r line; do
	[[ $line =~ $regex ]]

	if [ ${BASH_REMATCH[1]} == 1 ]; then
		width_1=${BASH_REMATCH[2]}
		height_1=${BASH_REMATCH[3]}
	fi
	
	if [ ${BASH_REMATCH[1]} == 2 ]; then
		width_2=${BASH_REMATCH[2]}
		height_2=${BASH_REMATCH[3]}
	fi
	
	if [ ${BASH_REMATCH[1]} == 3 ]; then
		width_3=${BASH_REMATCH[2]}
		height_3=${BASH_REMATCH[3]}
	fi
	
done < <( cat ~/TvPost/Resolutions/new_resolutions.txt )

#Each file to reproduce in the screen will come with a number related to
#the corresponding screen. the argument $1 contains the amount of screens
#and the screen in which the file will be reproduced 
#For 1 screen:
#1-1 [file_screen_1]

#For 2 screens:
#2-1 [File_screen_1]
#2-2 [File_screen_2]
#2-3 [File_screen_1] [File_screen_2]

#For 3 screens:
#3-1 [File_screen_1]
#3-2 [File_screen_2]
#3-3 [File_screen_3]
#3-4 [File_screen_1] [File_screen_2] [File_screen_3]
#3-5 [File_screen_1] [File_screen_2] (Change screen 1 and 2)
#3-6 [File_screen_2] [File_screen_3] (Change screen 2 and 3)
#3-7 [File_screen_1] [File_screen_3] (Change screen 1 and 3)

select_screen="$1"
file_in_screen_1="$2"
file_in_screen_2="$3"
file_in_screen_3="$4"

active_window_1=""
active_window_2=""
active_window_3=""
#Read the file
if [ -f ~/TvPost/Resolutions/window_id.txt ]; then
	regex_window_id='([0-9]?:?[0-9]+)?-?\s?([0-9]?\:?[0-9]+)?-?\s?([0-9]?\:?[0-9]+)?-?'
	active_window_file=$(echo $(<~/TvPost/Resolutions/window_id.txt))
	
	[[ $active_window_file =~ $regex_window_id ]]
	
	#Assign the correct active window to variable
	i=1
	while [ $i -le 3 ]; do
		if [[ "${BASH_REMATCH[i]}" == *"1:"* ]]; then
			complete_string="${BASH_REMATCH[i]}"
			active_window_1="${complete_string:2}"
		fi
		if [[ "${BASH_REMATCH[i]}" == *"2:"* ]]; then
			complete_string="${BASH_REMATCH[i]}"
			active_window_2="${complete_string:2}"
		fi
		if [[ "${BASH_REMATCH[i]}" == *"3:"* ]]; then
			complete_string="${BASH_REMATCH[i]}"
			active_window_3="${complete_string:2}"
		fi
		i=$(( i + 1 ))
	done
	
	#active_window_1=${BASH_REMATCH[1]}
	#active_window_2=${BASH_REMATCH[2]}
	#active_window_3=${BASH_REMATCH[3]}
	echo "active 1:"${active_window_1}
	echo "active 2:"${active_window_2}
	echo "active 3:"${active_window_3}
fi




#Url matcher
regex_url_http_https='https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&\/=]*)'
regex_url_www='[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&\/=]*)'

#Online video matcher
regex_youtube='https?://)?(www\.)?(youtube|youtu|youtube-nocookie)\.(com|be)/(watch\?v=|embed/|v/|.+\?v=)?([^&=%\?]{11})'

#Local video matcher
regex_local_video='.*\/VideosPostTv\/.*'

#Images will be stored in /home/pi/ImagenesPosTv. They will only be 
#accepted if they come from there

#image matcher
#regex_image='\/home\/pi\/ImagenesPosTv\/.+\.(png|jpg|gif|bmp)'
regex_image='.*\/ImagenesPostTv\/.*'


function check_if_new_app_opened() {
	#echo "entreé" 
	seconds=1;
	#Get all the currently running apps
	running_apps=$(wmctrl -l|echo $(awk '{print $1}'))
	
	while [ $seconds -le 300 ]; do
		#Check if the new list is eqyal to the old list
		if [ "${running_apps}" != "$(wmctrl -l|echo $(awk '{print $1}'))" ]; then
			echo $(wmctrl -l|echo $(awk '{print $1}')) 
			break;
		fi
		#sleep 0.5
		seconds=$(( ${seconds} + 1 ))
	done
}

function kill_app_left_corner() {
		#Kill any app in that window
	if [[ ! -z ${active_window_1} ]]; then
		echo "killing active 1: "${active_window_1} &&
		#xdotool windowactivate ${active_window_1}
		xdotool windowactivate ${active_window_1} key alt+F4;
		sudo grep -rv '1:' ~/TvPost/Resolutions/window_id.txt >> ~/TvPost/Resolutions/window_id_temp.txt;
		#sudo rm ~/TvPost/Resolutions/window_id.txt
		#echo $(cat /home/pi/window_id_temp.txt);
		sudo mv ~/TvPost/Resolutions/window_id_temp.txt ~/TvPost/Resolutions/window_id.txt;
		
	fi 
}

function kill_app_right_corner() {
		#Kill any app in that window
	if [[ ! -z ${active_window_2} ]]; then
		echo "killing active 2: "${active_window_2} &&
		#xdotool windowactivate ${active_window_1}
		xdotool windowactivate ${active_window_2} key alt+F4;
		sudo grep -rv '2:' ~/TvPost/Resolutions/window_id.txt >> ~/TvPost/Resolutions/window_id_temp.txt;
		#sudo rm ~/TvPost/Resolutions/window_id.txt
		#echo $(cat /home/pi/window_id_temp.txt);
		sudo mv ~/TvPost/Resolutions/window_id_temp.txt ~/TvPost/Resolutions/window_id.txt;
	fi 
}

function kill_app_bottom_corner() {
		#Kill any app in that window
	if [[ ! -z ${active_window_3} ]]; then
		echo "killing active 3: "${active_window_3} &&
		#xdotool windowactivate ${active_window_3}
		xdotool windowactivate ${active_window_3} key alt+F4;
		sudo grep -rv '3:' ~/TvPost/Resolutions/window_id.txt >> ~/TvPost/Resolutions/window_id_temp.txt;
		#sudo rm ~/TvPost/Resolutions/window_id.txt
		sudo mv ~/TvPost/Resolutions/window_id_temp.txt ~/TvPost/Resolutions/window_id.txt;
	fi 
}

function left_screen() {
	#Kill app in the left corner
	kill_app_left_corner;
	#If matches an image open with image viewer
	if [[ $file_in_screen_1 =~ $regex_image ]]; then
		#Open with image viewer
		#Sleep to get activewindow as the image and then the keys
		#Mousemove and click to select the screen that runs the app
		#xdotool mousemove --sync 0 0 
		#xdotool click 1 
		#runs the app
		gpicview $file_in_screen_1 &
		
		#Check fore new apps
		check_if_new_app_opened 
		
		#sleep 1
		active_window_1=$(xdotool getactivewindow) 
		#echo "$active_window_1"
		xdotool windowmove --sync $active_window_1 0 0 
		sleep 1
		
		xdotool getactivewindow key f
		xdotool getactivewindow key F11 
		#Writing the id to later kill it
		echo "1:${active_window_1}-" >> ~/TvPost/Resolutions/window_id.txt
		
	else
	
		if	[[ $file_in_screen_1 =~ $regex_local_video ]]; then
			
			#xdotool mousemove --sync 0 0
			#xdotool click 1
			#runs the app
			vlc $file_in_screen_1 &
			
			#Check fore new apps
			check_if_new_app_opened 
			
			#sleep 4
			active_window_1=$(xdotool getactivewindow) 
			
			xdotool windowmove --sync $active_window_1 0 0
			#Wait 1.5 seconds and then goes fullscreen
			sleep 1.5
			xdotool mousemove --sync 100 200
			
			#Goes fullscreen here
			xdotool click 3
			xdotool getactivewindow key v
			xdotool getactivewindow key P
			xdotool getactivewindow key KP_Enter
			
			#Writing the id to later kill it
			echo "1:${active_window_1}-" >> ~/TvPost/Resolutions/window_id.txt
			
		else
			#If it matches a youtube link, open and play in full screen
			if [[ $file_in_screen_1 =~ $regex_youtube ]]; then
				#sleep 10;
				#Opening and moving Chrome. Waiting 7 seconds and go fullscreen
				bash ~/TvPost/Bash_files/chromeos-browser.bash $file_in_screen_1 &

				check_if_new_app_opened;
				
				sleep 20;
				
				active_window_1=$(xdotool getactivewindow)
				
				xdotool windowmove --sync $active_window_1 0 0
				echo 'la moví a la esquina izquierda '
				
				xdotool key --window $active_window_1 f
				
				echo "1:${active_window_1}-" >> ~/TvPost/Resolutions/window_id.txt
			else
				#If it matches a url open with firefox
				if [[ $file_in_screen_1 =~ $regex_url_http_https ]] || [[ $file_in_screen_1 =~ $regex_url_www ]]; then
					#xdotool mousemove --sync 0 0
					#xdotool click 1
					#runs the app
					#Opening and moving firefox
					bash ~/TvPost/Bash_files/chromeos-browser.bash $file_in_screen_1 &
					
					#Check fore new apps
					check_if_new_app_opened 
					
					#sleep 10
					active_window_1=$(xdotool getactivewindow)
					xdotool windowmove --sync $active_window_1 0 0 &
					sleep 8
					xdotool key --window $active_window_1 F11 &
					#Writing the id to later kill it
					echo "1:${active_window_1}-" >> ~/TvPost/Resolutions/window_id.txt
					
				else
					echo "Archivo no reproducible"
				fi
			fi
		
		fi

	fi
}

function right_screen() {
	#Kill right acreen app
	kill_app_right_corner
	
	#If matches an image open with image viewer
	if [[ $file_in_screen_1 =~ $regex_image ]]; then
	
		#xdotool mousemove --sync $(( ${width_1} + 200 )) 50 
		#xdotool click 1
		#sleep 1 &&
		#runs the app
		#Open with image viewer
		#gnome-terminal --geometry 10x10+$(( ${width_1} + 100 ))+0 -- 
		gpicview $file_in_screen_1 &
		
		#Check fore new apps
		check_if_new_app_opened 
		
		#sleep 4
		active_window_2=$(xdotool getactivewindow)
		#xdotool windowminimize
		xdotool windowmove --sync $active_window_2 $(( ${width_1} + 1 )) 0;
		#xdotool windowactivate $active_window_2
		#sleep 1
		xdotool getactivewindow key f
		xdotool getactivewindow key F11 
		echo "2:${active_window_2}-" >> ~/TvPost/Resolutions/window_id.txt
		
	else
	
		if	[[ $file_in_screen_1 =~ $regex_local_video ]]; then
			#xdotool mousemove --sync $(( ${width_1} + 10 )) 0
			#xdotool click 1 
			#runs the app
			#vlc $file_in_screen_1 --video-wallpaper &
			vlc $file_in_screen_1 &
			
			#Check fore new apps
			check_if_new_app_opened 
			
			#sleep 8
			active_window_2=$(xdotool getactivewindow)
			xdotool windowmove --sync $active_window_2 $(( ${width_1} + 1)) 0;
			#sleep 2
			#xdotool getactivewindow key f &
			sleep 1.5
			xdotool mousemove --sync $(( ${width_1} + 100 )) 100
			xdotool click 3
			xdotool getactivewindow key v
			xdotool getactivewindow key f
			sleep 2
			xdotool getactivewindow key f
			#xdotool click 3
			#xdotool getactivewindow key v
			#xdotool getactivewindow key P
			#xdotool getactivewindow key KP_Enter
			#sleep 3;
			#xdotool search --sync --onlyvisible --class "vlc" key F11;
			echo "2:${active_window_2}-" >> ~/TvPost/Resolutions/window_id.txt
			
		else
			#If it matches a youtube link, open and play in full screen
			if [[ $file_in_screen_1 =~ $regex_youtube ]]; then
				#xdotool mousemove --sync $(( ${width_1} + 10 )) 0
				#xdotool click 1
				#runs the app
				#Opening and moving firefox. Waiting 7 seconds and go fullscreen
				bash ~/TvPost/Bash_files/chromeos-browser.bash &
				#chromium &
				sleep 5 &&
				#xdotool key --window $active_window_1 ctrl+t 
				chromium $file_in_screen_1 || chromium-browser $file_in_screen_1 &
				#Check fore new apps
				check_if_new_app_opened 
				
				#sleep 10
				active_window_2=$(xdotool getactivewindow)
				xdotool windowmove --sync $active_window_2 $(( ${width_1} + 10 )) 0;
				#xdotool key --window $active_window_2 F11 
				sleep 15
				xdotool key --window $active_window_2 f 
				echo "2:${active_window_2}-" >> ~/TvPost/Resolutions/window_id.txt
				
			else
				#If it matches a url open with firefox
				if [[ $file_in_screen_1 =~ $regex_url_http_https ]] || [[ $file_in_screen_1 =~ $regex_url_www ]]; then
					#xdotool mousemove --sync $(( ${width_1} + 10 )) 0
					#xdotool click 1
					#runs the app
					#Opening and moving firefox
					bash ~/TvPost/Bash_files/chromeos-browser.bash $file_in_screen_1 &
					
					#Check fore new apps
					check_if_new_app_opened 
					
					#sleep 10
					active_window_2=$(xdotool getactivewindow)
					xdotool windowmove --sync $active_window_2 $(( ${width_1} + 10 )) 0 &
					sleep 8
					xdotool key --window $active_window_2 F11 
					#Writing the id to later kill it
					echo "2:${active_window_2}-" >> ~/TvPost/Resolutions/window_id.txt
					
				else
					echo "Archivo no reproducible"
				fi
			fi
		
		fi
		
	fi
}

function right_screen_second_file() {
	#Kill right acreen app
	kill_app_right_corner
	sleep 7;
	#If matches an image open with image viewer
	if [[ $file_in_screen_2 =~ $regex_image ]]; then
		
		
		
		#xdotool mousemove --sync $(( ${width_1} + 10 )) 0
		#xdotool click 1
		#runs the app
		#Open with image viewer
		gpicview $file_in_screen_2 &
		
		#Check fore new apps
		check_if_new_app_opened 
		
		#sleep 4
		active_window_2=$(xdotool getactivewindow)
		xdotool windowmove --sync $active_window_2 $(( ${width_1} + 10 )) 0;
		sleep 1
		xdotool getactivewindow key f
		xdotool getactivewindow key F11 
		echo "2:${active_window_2}-" >> ~/TvPost/Resolutions/window_id.txt
		
	else
	
		if	[[ $file_in_screen_2 =~ $regex_local_video ]]; then
			#xdotool mousemove --sync $(( ${width_1} + 10 )) 0
			#xdotool click 1
			#runs the app
			vlc $file_in_screen_2 &
			
			#Check fore new apps
			check_if_new_app_opened 
			
			#sleep 8
			active_window_2=$(xdotool getactivewindow)
			xdotool windowmove --sync $active_window_2 $(( ${width_1} + 50 )) 0;
			#sleep 2
			#xdotool getactivewindow key f &
			sleep 1.5
			xdotool mousemove --sync $(( ${width_1} + 100 )) 100
			xdotool click 3
			xdotool getactivewindow key v
			xdotool getactivewindow key f
			sleep 2
			xdotool getactivewindow key f
			#xdotool click 3
			#xdotool getactivewindow key v
			#xdotool getactivewindow key P
			#xdotool getactivewindow key KP_Enter
			#sleep 3;
			#xdotool search --sync --onlyvisible --class "vlc" key F11;
			echo "2:${active_window_2}-" >> ~/TvPost/Resolutions/window_id.txt
			
		else
			#If it matches a youtube link, open and play in full screen
			if [[ $file_in_screen_2 =~ $regex_youtube ]]; then
				#xdotool mousemove --sync $(( ${width_1} + 10 )) 0
				#xdotool click 1
				#runs the app
				#Opening and moving firefox. Waiting 7 seconds and go fullscreen
				bash ~/TvPost/Bash_files/chromeos-browser.bash &
				#chromium &
				sleep 5 &&
				#xdotool key --window $active_window_1 ctrl+t 
				chromium $file_in_screen_1 || chromium-browser $file_in_screen_1 &
				#Check fore new apps
				check_if_new_app_opened 
				
				#sleep 10
				active_window_2=$(xdotool getactivewindow)
				xdotool windowmove --sync $active_window_2 $(( ${width_1} + 10 )) 0;
				#xdotool key --window $active_window_2 F11 
				sleep 15
				xdotool key --window $active_window_2 f 
				echo "2:${active_window_2}-" >> ~/TvPost/Resolutions/window_id.txt
				
			else
				#If it matches a url open with firefox
				if [[ $file_in_screen_2 =~ $regex_url_http_https ]] || [[ $file_in_screen_2 =~ $regex_url_www ]]; then
					#xdotool mousemove --sync $(( ${width_1} + 10 )) 0
					#xdotool click 1
					#runs the app
					#Opening and moving firefox
					bash ~/TvPost/Bash_files/chromeos-browser.bash $file_in_screen_2 &
					
					#Check fore new apps
					check_if_new_app_opened 
					
					#sleep 10
					active_window_2=$(xdotool getactivewindow)
					xdotool windowmove --sync $active_window_2 $(( ${width_1} + 10 )) 0 &
					sleep 8
					xdotool key --window $active_window_2 F11 
					#Writing the id to later kill it
					echo "2:${active_window_2}-" >> ~/TvPost/Resolutions/window_id.txt
					
				else
					echo "Archivo no reproducible"
				fi
			fi
		
		fi
		
	fi
}

function bottom_screen() {
	#Kill bottom app
	kill_app_bottom_corner
	
	#If matches an image open with image viewer
	if [[ $file_in_screen_1 =~ $regex_image ]]; then
		#xdotool mousemove --sync 0 $(( ${height_1} + 10 ))
		#xdotool click 1
		#runs the app
		#Open with image viewer
		gpicview $file_in_screen_1 &
		
		#Check fore new apps
		check_if_new_app_opened 
		
		#sleep 4
		active_window_3=$(xdotool getactivewindow)
		xdotool windowmove --sync $active_window_3 0 $(( ${height_1} + 10 ))
		sleep 1
		xdotool getactivewindow key f
		xdotool getactivewindow key F11 
		echo "3:${active_window_3}-" >> ~/TvPost/Resolutions/window_id.txt
		
	else
	
		if	[[ $file_in_screen_1 =~ $regex_local_video ]]; then
			#xdotool mousemove --sync 0 $(( ${height_1} + 10 ))
			#xdotool click 1
			#runs the app
			vlc $file_in_screen_1 &
			
			#Check fore new apps
			check_if_new_app_opened 
			
			#sleep 8
			active_window_3=$(xdotool getactivewindow)
			xdotool windowmove --sync $active_window_3 0 $(( ${height_1} + 10 ))
			#sleep 2
			#xdotool getactivewindow key f &
			sleep 1.5
			xdotool mousemove --sync 0 $(( ${height_1} + 10 ))
			xdotool click 3
			xdotool getactivewindow key v
			xdotool getactivewindow key f
			sleep 2
			xdotool getactivewindow key f 
			echo "3:${active_window_3}-" >> ~/TvPost/Resolutions/window_id.txt
			
			#sleep 3;
			#xdotool search --sync --onlyvisible --class "vlc" key F11;
		else
			#If it matches a youtube link, open and play in full screen
			if [[ $file_in_screen_1 =~ $regex_youtube ]]; then
				#xdotool mousemove --sync 0 $(( ${height_1} + 10 ))
				#xdotool click 1
				#runs the app
				#Opening and moving firefox. Waiting 7 seconds and go fullscreen
				bash ~/TvPost/Bash_files/chromeos-browser.bash &
				#chromium &
				sleep 5 &&
				#xdotool key --window $active_window_1 ctrl+t 
				chromium $file_in_screen_1 || chromium-browser $file_in_screen_1 &
				#Check fore new apps
				check_if_new_app_opened 
				
				#sleep 10
				active_window_3=$(xdotool getactivewindow)
				xdotool windowmove --sync $active_window_3 0 $(( ${height_1} + 10 ))
				#xdotool key --window $active_window_3 F11 
				sleep 15
				xdotool key --window $active_window_3 f 
				#Writing the id to later kill it
				echo "3:${active_window_3}-" >> ~/TvPost/Resolutions/window_id.txt
				
			else
				#If it matches a url open with firefox
				if [[ $file_in_screen_1 =~ $regex_url_http_https ]] || [[ $file_in_screen_1 =~ $regex_url_www ]]; then
					#xdotool mousemove --sync 0 $(( ${height_1} + 10 ))
					#xdotool click 1
					#runs the app
					#Opening and moving firefox
					bash ~/TvPost/Bash_files/chromeos-browser.bash $file_in_screen_1 &
					
					#Check fore new apps
					check_if_new_app_opened 
					
					#sleep 10
					active_window_3=$(xdotool getactivewindow)
					xdotool windowmove --sync $active_window_3 0 $(( ${height_1} + 10 )) &
					sleep 8
					xdotool key --window $active_window_3 F11 
					#Writing the id to later kill it
					echo "3:${active_window_3}-" >> ~/TvPost/Resolutions/window_id.txt
					
				else
					echo "Archivo no reproducible"
				fi
			fi
		
		fi
		
	fi
}

function bottom_screen_second_file() {
	#Kill bottom app
	kill_app_bottom_corner
	
	#If matches an image open with image viewer
	if [[ $file_in_screen_2 =~ $regex_image ]]; then
		#xdotool mousemove --sync 0 $(( ${height_1} + 10 ))
		#xdotool click 1
		#runs the app
		#Open with image viewer
		gpicview $file_in_screen_2 &
		
		#Check fore new apps
		check_if_new_app_opened 
		
		#sleep 4
		active_window_3=$(xdotool getactivewindow)
		xdotool windowmove --sync $active_window_3 0 $(( ${height_1} + 10 ))
		sleep 1
		xdotool getactivewindow key f
		xdotool getactivewindow key F11 
		echo "3:${active_window_3}-" >> ~/TvPost/Resolutions/window_id.txt
		
	else
	
		if	[[ $file_in_screen_2 =~ $regex_local_video ]]; then
			#xdotool mousemove --sync 0 $(( ${height_1} + 10 ))
			#xdotool click 1
			#runs the app
			vlc $file_in_screen_2 &
			
			#Check fore new apps
			check_if_new_app_opened 
			
			#sleep 8
			active_window_3=$(xdotool getactivewindow)
			xdotool windowmove --sync $active_window_3 0 $(( ${height_1} + 10 ))
			#sleep 2
			#xdotool getactivewindow key f &
			sleep 1.5
			xdotool mousemove --sync 0 $(( ${height_1} + 10 ))
			xdotool click 3
			xdotool getactivewindow key v
			xdotool getactivewindow key f
			sleep 2
			xdotool getactivewindow key f 
			echo "3:${active_window_3}-" >> ~/TvPost/Resolutions/window_id.txt
			
			#sleep 3;
			#xdotool search --sync --onlyvisible --class "vlc" key F11;
		else
			#If it matches a youtube link, open and play in full screen
			if [[ $file_in_screen_2 =~ $regex_youtube ]]; then
				#xdotool mousemove --sync 0 $(( ${height_1} + 10 ))
				#xdotool click 1
				#runs the app
				#Opening and moving firefox. Waiting 7 seconds and go fullscreen
				bash ~/TvPost/Bash_files/chromeos-browser.bash &
				#chromium &
				sleep 5 &&
				#xdotool key --window $active_window_1 ctrl+t 
				chromium $file_in_screen_1 || chromium-browser $file_in_screen_1 &
				#Check fore new apps
				check_if_new_app_opened 
				
				#sleep 10
				active_window_3=$(xdotool getactivewindow)
				xdotool windowmove --sync $active_window_3 0 $(( ${height_1} + 10 ))
				#xdotool key --window $active_window_3 F11 
				sleep 15
				xdotool key --window $active_window_3 f 
				#Writing the id to later kill it
				echo "3:${active_window_3}-" >> ~/TvPost/Resolutions/window_id.txt
				
			else
				#If it matches a url open with firefox
				if [[ $file_in_screen_2 =~ $regex_url_http_https ]] || [[ $file_in_screen_2 =~ $regex_url_www ]]; then
					#xdotool mousemove --sync 0 $(( ${height_1} + 10 ))
					#xdotool click 1
					#runs the app
					#Opening and moving firefox
					bash ~/TvPost/Bash_files/chromeos-browser.bash $file_in_screen_2 &
					
					#Check fore new apps
					check_if_new_app_opened 
					
					#sleep 10
					active_window_3=$(xdotool getactivewindow)
					xdotool windowmove --sync $active_window_3 0 $(( ${height_1} + 10 )) &
					sleep 8
					xdotool key --window $active_window_3 F11 
					#Writing the id to later kill it
					echo "3:${active_window_3}-" >> ~/TvPost/Resolutions/window_id.txt
					
				else
					echo "Archivo no reproducible"
				fi
			fi
		
		fi
		
	fi
}

function bottom_screen_third_file() {
	#Kill bottom app
	kill_app_bottom_corner
	sleep 7;
	#If matches an image open with image viewer
	if [[ $file_in_screen_3 =~ $regex_image ]]; then
		#xdotool mousemove --sync 0 $(( ${height_1} + 10 ))
		#xdotool click 1
		#runs the app
		#Open with image viewer
		gpicview $file_in_screen_3 &
		
		#Check fore new apps
		check_if_new_app_opened 
		
		#sleep 4
		active_window_3=$(xdotool getactivewindow)
		xdotool windowmove --sync $active_window_3 0 $(( ${height_1} + 10 ))
		sleep 1
		xdotool getactivewindow key f
		xdotool getactivewindow key F11 
		echo "3:${active_window_3}-" >> ~/TvPost/Resolutions/window_id.txt
		
	else
	
		if	[[ $file_in_screen_3 =~ $regex_local_video ]]; then
			#xdotool mousemove --sync 0 $(( ${height_1} + 10 ))
			#xdotool click 1
			#runs the app
			vlc $file_in_screen_3 &
			
			#Check fore new apps
			check_if_new_app_opened 
			
			#sleep 8
			active_window_3=$(xdotool getactivewindow)
			xdotool windowmove --sync $active_window_3 0 $(( ${height_1} + 10 ))
			#sleep 2
			#xdotool getactivewindow key f &
			sleep 1.5
			xdotool mousemove --sync 0 $(( ${height_1} + 10 ))
			xdotool click 3
			xdotool getactivewindow key v
			xdotool getactivewindow key f
			sleep 2
			xdotool getactivewindow key f 
			echo "3:${active_window_3}-" >> ~/TvPost/Resolutions/window_id.txt
			
			#sleep 3;
			#xdotool search --sync --onlyvisible --class "vlc" key F11;
		else
			#If it matches a youtube link, open and play in full screen
			if [[ $file_in_screen_3 =~ $regex_youtube ]]; then
				#xdotool mousemove --sync 0 $(( ${height_1} + 10 ))
				#xdotool click 1
				#runs the app
				#Opening and moving firefox. Waiting 7 seconds and go fullscreen
				bash ~/TvPost/Bash_files/chromeos-browser.bash &
				#chromium &
				sleep 5 &&
				#xdotool key --window $active_window_1 ctrl+t 
				chromium $file_in_screen_1 || chromium-browser $file_in_screen_1 &
				#Check fore new apps
				check_if_new_app_opened 
				
				#sleep 10
				active_window_3=$(xdotool getactivewindow)
				xdotool windowmove --sync $active_window_3 0 $(( ${height_1} + 10 ))
				#xdotool key --window $active_window_3 F11 
				sleep 15
				xdotool key --window $active_window_3 f 
				#Writing the id to later kill it
				echo "3:${active_window_3}-" >> ~/TvPost/Resolutions/window_id.txt
				
			else
				#If it matches a url open with firefox
				if [[ $file_in_screen_3 =~ $regex_url_http_https ]] || [[ $file_in_screen_3 =~ $regex_url_www ]]; then
					#xdotool mousemove --sync 0 $(( ${height_1} + 10 ))
					#xdotool click 1
					#runs the app
					#Opening and moving firefox
					bash ~/TvPost/Bash_files/chromeos-browser.bash $file_in_screen_3 &
					
					#Check fore new apps
					check_if_new_app_opened 
					
					#sleep 10
					active_window_3=$(xdotool getactivewindow)
					xdotool windowmove --sync $active_window_3 0 $(( ${height_1} + 10 )) &
					sleep 8
					xdotool key --window $active_window_3 F11 
					#Writing the id to later kill it
					echo "3:${active_window_3}-" >> ~/TvPost/Resolutions/window_id.txt
					
				else
					echo "Archivo no reproducible"
				fi
			fi
		
		fi
		
	fi
}

function change_left_and_right_screens() {
	
	#Change left screen
	left_screen
	
	sleep 5
	
	#Change right screen
	right_screen_second_file
}

function change_right_and_bottom() {
	#Change right screen
	right_screen
	
	sleep 5
	
	#Change bottom screen
	bottom_screen_second_file
}

function change_left_and_bottom() {
	
	#Change left screen
	left_screen
	
	sleep 5
	
	#Change bottom screen - 2nd argument
	bottom_screen_second_file
	
	sleep 5
}

function change_left_right_and_bottom_screens() {
	
	#Change left screen
	left_screen;
	
	sleep 2;
	
	#Change right screen
	right_screen_second_file;
	
	sleep 2;
	
	#Change bottom screen
	bottom_screen_third_file;
}
#Validate that 'select_screen' is available in the resolutions

#1 Screen
if [ $select_screen == "1-1" ] && [ width_1 != "" ] && [ height_1 != "" ]; then

	left_screen
	
else
	echo "No existe pantalla 1"
fi

#2 screens - Changing file in the left screen
if [ $select_screen == "2-1" ] && [ width_1 != "" ] && [ height_1 != "" ]; then

	left_screen
	
else
	echo "No existe pantalla 2-1"
fi

#2 screens - File in right screen
if [ $select_screen == "2-2" ] && [ width_2 != "" ] && [ height_2 != "" ]; then

	right_screen

else
	echo "No existe pantalla 2-2"
fi

#2 screens - changing both screens
if [ $select_screen == "2-3" ] && [ width_1 != "" ] && [ height_1 != "" ] && [ width_2 != "" ] && [ height_2 != "" ]; then
	
	#Change both screens
	change_left_and_right_screens

else
	echo "No existe pantalla 2-3"
fi

#3 screens changing left screen
if [ $select_screen == "3-1" ] && [ width_1 != "" ] && [ height_1 != "" ]; then
	#Change the left screen
	left_screen
else
	echo "No existe pantalla 3-1"
fi

#3 screens changing right screen
if [ $select_screen == "3-2" ] && [ width_2 != "" ] && [ height_2 != "" ]; then
	#Change the right screen
	right_screen
else
	echo "No existe pantalla 3-2"
fi

#3 screens changing bottom screen
if [ $select_screen == "3-3" ] && [ width_3 != "" ] && [ height_3 != "" ]; then
	#Change the bottom screen
	bottom_screen
else
	echo "No existe pantalla 3-3"
fi

#3 screens changing 3 screens
if [ $select_screen == "3-4" ] && [ width_1 != "" ] && [ height_1 != "" ] && [ width_2 != "" ] && [ height_2 != "" ] && [ width_3 != "" ] && [ height_3 != "" ]; then
	#Change 3 screens
	change_left_right_and_bottom_screens
else
	echo "No existe pantalla 3-4"
fi

#3 screens changing left and right screens
if [ $select_screen == "3-5" ] && [ width_1 != "" ] && [ height_1 != "" ] && [ width_2 != "" ] && [ height_2 != "" ]; then
	
	#Change both screens
	change_left_and_right_screens

else
	echo "No existe pantalla 3-5"
fi

#3 screens changing right and left screens
if [ $select_screen == "3-6" ] && [ width_2 != "" ] && [ height_2 != "" ] && [ width_3 != "" ] && [ height_3 != "" ]; then
	
	#Change both screens
	change_right_and_bottom

else
	echo "No existe pantalla 3-6"
fi

#3 screens changing left and bottom screen
if [ $select_screen == "3-7" ] && [ width_1 != "" ] && [ height_1 != "" ] && [ width_3 != "" ] && [ height_3 != "" ]; then
	
	#both screens
	change_left_and_bottom

else
	echo "No existe pantalla 3-7"
fi

#firefox -new-window www.google.cl & 
#xdotool getactivewindow windowmove 1537 y
#Move a an app wherever you want
#This needs to give receive the width or height to work perfectly
#xdotool search --sync --onlyvisible --class "Firefox" windowmove 1537 y
