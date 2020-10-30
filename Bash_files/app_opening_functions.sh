#!/bin/sh
#Create variables to assign the coordinates on the app
width_1=""
height_1=""
width_2=""
height_2=""
width_3=""
height_3=""

function widths_heights(){
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
	return
}

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
	
	echo "active 1:"${active_window_1}
	echo "active 2:"${active_window_2}
	echo "active 3:"${active_window_3}
fi


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
	return
}

function change_right_and_bottom() {
	#Change right screen
	right_screen;
	#Change bottom screen
	bottom_screen_second_file;
	return
}

function change_left_and_bottom() {
	
	#Change left screen
	left_screen;
	#Change bottom screen - 2nd argument
	bottom_screen_second_file;
	return
}

function change_left_right_and_bottom_screens() {
	
	#Change left screen
	left_screen;
	#Change right screen
	right_screen_second_file;
	#Change bottom screen
	bottom_screen_third_file;
	return
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
	return

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
	return
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
	return
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
	change_left_and_right_screens;
	
	kill_app_bottom_corner;
	return

fi

#3 screens changing left screen
if [ $select_screen == "3-1" ]
then
	#Change the left screen
	echo "Cambiando pantalla 3-1"
	left_screen;
	return
fi

#3 screens changing right screen
if [ $select_screen == "3-2" ]
then
	#Change the right screen
	echo "Cambiando pantalla 3-2"
	right_screen;
	return
fi

#3 screens changing bottom screen
if [ $select_screen == "3-3" ]
then
	#Change the bottom screen
	echo "Cambiando pantalla 3-3"
	bottom_screen;
	return
fi

#3 screens changing 3 screens
if [ $select_screen == "3-4" ]
then
	#Change 3 screens
	echo "Cambiando pantalla 3-4"
	change_left_right_and_bottom_screens
	return
fi

#3 screens changing left and right screens
if [ $select_screen == "3-5" ]
then
	
	#Change both screens
	echo "Cambiando pantalla 3-5"
	change_left_and_right_screens
	return
fi

#3 screens changing right and left screens
if [ $select_screen == "3-6" ]
then
	
	#Change both screens
	echo "Cambiando pantalla 3-6"
	change_right_and_bottom
	return

fi

#3 screens changing left and bottom screen
if [ $select_screen == "3-7" ]
then
	
	#both screens
	echo "Cambiando pantalla 3-7"
	change_left_and_bottom
	return

fi

#Para no cambiar archivos y solo mantener abiertos los que vienen por 
#parámetro
#Cuando se mantienen algunos archivos, se deben mover para que quepan
#correctamente en la porción al cambiar resolución. Especialmente
#mantener3
if [ $select_screen == "mantener1" ]
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
	
	#It changes format after manipulating opened apps
	python3 /home/pi/TvPost/Py_files/Formato_100.py
	
	#kill other apps
	kill_app_right_corner;
	kill_app_bottom_corner;
fi

if [ $select_screen == "mantener2" ]
then

	#Minize other apps
	if [[ ! -z ${active_window_3} ]]
	then
		xdotool windowminimize ${active_window_3}
	fi
	
	#minimize other apps
	if [[ ! -z ${active_window_2} ]]; then
		xdotool windowminimize ${active_window_2}
	fi 


	#It changes format after manipulating opened apps
	python3 /home/pi/TvPost/Py_files/Formato_50_50.py
	
	#recalculate size
	widths_heights;

	#Se debe  mover el archivo de la porción derecha a la derecha
	if [[ ! -z ${active_window_2} ]]; then
		xdotool windowmove $active_window_2 $(( ${width_1} + 1 )) 0;
		xdotool windowactivate $active_window_2
	fi 
	
	#kill other apps
	kill_app_bottom_corner;
	
fi

if [ $select_screen == "mantener3" ]
then

	#minimize other apps
	if [[ ! -z ${active_window_2} ]]; then
		xdotool windowminimize ${active_window_2}
	fi 

	#It changes format after manipulating opened apps
	python3 /home/pi/TvPost/Py_files/Formato_80_20_10.py

	#recalculate size
	widths_heights;

	#Se debe  mover el archivo de la porción derecha a la derecha
	if [[ ! -z ${active_window_2} ]]; then
		xdotool windowmove $active_window_2 $(( ${width_1} + 1 )) 0;
		xdotool windowactivate $active_window_2
	fi 

fi
