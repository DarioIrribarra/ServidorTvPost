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
regex_youtube='https?://)?(www\.)?(m.youtube|youtube|youtu|youtube-nocookie)\.(com|be)/(watch\?v=|embed/|v/|.+\?v=)?([^&=%\?]{11})'

#Local video matcher
regex_local_video='.*\/VideosPostTv\/.*'

#Images will be stored in /home/pi/ImagenesPosTv. They will only be 
#accepted if they come from there

#image matcher
#regex_image='\/home\/pi\/ImagenesPosTv\/.+\.(png|jpg|gif|bmp)'
#regex_image='.*\/ImagenesPostTv\/.*'
regex_image_nopng='.*\/ImagenesPostTv\/.+\.(jpg|gif|jpeg)'
regex_image_png='.*\/ImagenesPostTv\/.+\.(png)'


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
		#xdotool windowactivate ${active_window_1} key alt+F4;
		wmctrl -ic ${active_window_1};
		sudo grep -rv '1:' ~/TvPost/Resolutions/window_id.txt >> ~/TvPost/Resolutions/window_id_temp.txt;
		#sudo rm ~/TvPost/Resolutions/window_id.txt
		#echo $(cat /home/pi/window_id_temp.txt);
		sudo mv ~/TvPost/Resolutions/window_id_temp.txt ~/TvPost/Resolutions/window_id.txt;
		return;
	fi 
}

function kill_app_right_corner() {
		#Kill any app in that window
	if [[ ! -z ${active_window_2} ]]; then
		echo "killing active 2: "${active_window_2} &&
		#xdotool windowactivate ${active_window_1}
		#xdotool windowactivate ${active_window_2} key alt+F4;
		wmctrl -ic ${active_window_2};
		sudo grep -rv '2:' ~/TvPost/Resolutions/window_id.txt >> ~/TvPost/Resolutions/window_id_temp.txt;
		#sudo rm ~/TvPost/Resolutions/window_id.txt
		#echo $(cat /home/pi/window_id_temp.txt);
		sudo mv ~/TvPost/Resolutions/window_id_temp.txt ~/TvPost/Resolutions/window_id.txt;
		return;
	fi 
}

function kill_app_bottom_corner() {
		#Kill any app in that window
	if [[ ! -z ${active_window_3} ]]; then
		echo "killing active 3: "${active_window_3} &&
		#xdotool windowactivate ${active_window_3}
		#xdotool windowactivate ${active_window_3} key alt+F4;
		wmctrl -ic ${active_window_3};
		sudo grep -rv '3:' ~/TvPost/Resolutions/window_id.txt >> ~/TvPost/Resolutions/window_id_temp.txt;
		#sudo rm ~/TvPost/Resolutions/window_id.txt
		sudo mv ~/TvPost/Resolutions/window_id_temp.txt ~/TvPost/Resolutions/window_id.txt;
		return;
	fi 
}


function left_screen() {
	
	#Kill app in the left corner
	kill_app_left_corner;
	
	sleep 3;
	
	#Sends info file to file opener
	bash ~/TvPost/Bash_files/left_portion_file.sh ${file_in_screen_1};
	return;
	
}

function right_screen() {
	
	#Kill right acreen app
	kill_app_right_corner
	
	sleep 3;
	
	#Sends info file to file opener
	bash ~/TvPost/Bash_files/right_portion_file.sh ${file_in_screen_1};
	return;

}

function right_screen_second_file() {
	#Kill right acreen app
	kill_app_right_corner
	
	sleep 3;
	
	#Sends info file to file opener
	bash ~/TvPost/Bash_files/right_portion_file.sh ${file_in_screen_2};
	return;

}

function bottom_screen() {
	#Kill bottom app
	kill_app_bottom_corner
	
	sleep 3;
	
	#Sends info file to file opener
	bash ~/TvPost/Bash_files/bottom_portion_file.sh ${file_in_screen_1};
	return;
		
}

function bottom_screen_second_file() {
	#Kill bottom app
	kill_app_bottom_corner
	
	sleep 3;
	
	#Sends info file to file opener
	bash ~/TvPost/Bash_files/bottom_portion_file.sh ${file_in_screen_2};
	return;
	
}

function bottom_screen_third_file() {
	#Kill bottom app
	kill_app_bottom_corner
	
	sleep 3;
	
	#Sends info file to file opener
	bash ~/TvPost/Bash_files/bottom_portion_file.sh ${file_in_screen_3};
	return;
	
}

function change_left_and_right_screens() {
	
	#Change left screen
	left_screen;
	#Change right screen
	right_screen_second_file;
}

function change_right_and_bottom() {
	#Change right screen
	right_screen;
	#Change bottom screen
	bottom_screen_second_file;
}

function change_left_and_bottom() {
	
	#Change left screen
	left_screen;
	#Change bottom screen - 2nd argument
	bottom_screen_second_file;
}

function change_left_right_and_bottom_screens() {
	
	#Change left screen
	left_screen;
	#Change right screen
	right_screen_second_file;
	#Change bottom screen
	bottom_screen_third_file;
}
#Validate that 'select_screen' is available in the resolutions

#1 Screen
if [ $select_screen == "1-1" ] 
then

	#minimize other apps
	if [[ ! -z ${active_window_2} ]]
	then
		xdotool windowminimize ${active_window_2}
	fi
	
	if [[ ! -z ${active_window_3} ]]
	then
		xdotool windowminimize ${active_window_3}
	fi

	echo "Cambiando pantalla 1"
	left_screen

	kill_app_right_corner;
	sleep 1;
	kill_app_bottom_corner;
	sleep 1;

fi

#2 screens - Changing file in the left screen
if [ $select_screen == "2-1" ]
then
	if [[ ! -z ${active_window_3} ]]
	then
		xdotool windowminimize ${active_window_3}
	fi

	sleep 1;
	echo "Cambiando pantalla 2-1"
	left_screen
	
	kill_app_bottom_corner;
fi

#2 screens - File in right screen
if [ $select_screen == "2-2" ]
then
	if [[ ! -z ${active_window_3} ]]
	then
		xdotool windowminimize ${active_window_3}
	fi
	
	sleep 1;
	echo "Cambiando pantalla 2-2"
	right_screen
	
	kill_app_bottom_corner;
fi

#2 screens - changing both screens
if [ $select_screen == "2-3" ]
then
	if [[ ! -z ${active_window_3} ]]
	then
		xdotool windowminimize ${active_window_3}
	fi
	
	sleep 1;
	#Change both screens
	echo "Cambiando pantalla 2-3"
	change_left_and_right_screens
	
	kill_app_bottom_corner;

fi

#3 screens changing left screen
if [ $select_screen == "3-1" ]
then
	#Change the left screen
	echo "Cambiando pantalla 3-1"
	left_screen
fi

#3 screens changing right screen
if [ $select_screen == "3-2" ]
then
	#Change the right screen
	echo "Cambiando pantalla 3-2"
	right_screen
fi

#3 screens changing bottom screen
if [ $select_screen == "3-3" ]
then
	#Change the bottom screen
	echo "Cambiando pantalla 3-3"
	bottom_screen
fi

#3 screens changing 3 screens
if [ $select_screen == "3-4" ]
then
	#Change 3 screens
	echo "Cambiando pantalla 3-4"
	change_left_right_and_bottom_screens
fi

#3 screens changing left and right screens
if [ $select_screen == "3-5" ]
then
	
	#Change both screens
	echo "Cambiando pantalla 3-5"
	change_left_and_right_screens
fi

#3 screens changing right and left screens
if [ $select_screen == "3-6" ]
then
	
	#Change both screens
	echo "Cambiando pantalla 3-6"
	change_right_and_bottom

fi

#3 screens changing left and bottom screen
if [ $select_screen == "3-7" ]
then
	
	#both screens
	echo "Cambiando pantalla 3-7"
	change_left_and_bottom

fi

#Para no cambiar archivos y solo mantener abiertos los que vienen por 
#parámetro
#Cuando se mantienen algunos archivos, se deben mover para que quepan
#correctamente en la porción al cambiar resolución. Especialmente
#mantener3
if [ $select_screen == "mantener1" ]
then
	kill_app_right_corner;
	kill_app_bottom_corner;
fi

if [ $select_screen == "mantener2" ]
then

	kill_app_bottom_corner;

	#Se debe  mover el archivo de la porción derecha a la derecha
	if [[ ! -z ${active_window_2} ]]; then
		echo "Ventana 2: ${active_window_2}"
		xdotool windowactivate ${active_window_2} key F11
		xdotool windowminimize ${active_window_2}
		sleep 1;
		xdotool windowmove ${active_window_2} $(( ${width_1} + 10 )) 0;
		xdotool windowactivate ${active_window_2} key F11;
	fi 

	
fi

if [ $select_screen == "mantener3" ]
then
	#Se debe  mover el archivo de la porción derecha a la derecha
	if [[ ! -z ${active_window_2} ]]; then
		xdotool windowactivate ${active_window_2} key F11
		xdotool windowminimize ${active_window_2}
		sleep 1;
		xdotool windowmove ${active_window_2} $(( ${width_1} + 10 )) 0;
		xdotool windowactivate ${active_window_2} key F11;
	fi 
	#Se debe  mover el archivo de la porción abajo al fondo
	#if [[ ! -z ${active_window_3} ]]; then
		#xdotool windowactivate ${active_window_3} key F11;
		#sleep 1;
		#xdotool windowmove ${active_window_3} 0 $(( ${height_1} + 10 ))
		#xdotool windowactivate ${active_window_3} key F11;
	#fi 
fi

#firefox -new-window www.google.cl & 
#xdotool getactivewindow windowmove 1537 y
#Move a an app wherever you want
#This needs to give receive the width or height to work perfectly
#xdotool search --sync --onlyvisible --class "Firefox" windowmove 1537 y
