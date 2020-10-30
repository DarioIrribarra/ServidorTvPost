#!/bin/sh

#image matcher
regex_image_nopng='.*\/ImagenesPostTv\/.+\.(jpg|gif|jpeg)'
regex_image_png='.*\/ImagenesPostTv\/.+\.(png)'

#Local video matcher
regex_local_video='.*\/VideosPostTv\/.*'

#Online video matcher
regex_youtube='(https?://)?(www\.)?(m.youtube|youtube|youtu|youtube-nocookie)\.'

#Url matcher
regex_url_http_https='https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&\/=]*)'
regex_url_www='[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&\/=]*)'

file="$1"

if [ ! -z ${file} ]
then

	if [[ ${file} =~ $regex_image_nopng ]]
	then
		echo "image_nopng"
		exit
	fi
	
	if [[ ${file} =~ $regex_image_png ]]
	then
		echo "image_png"
		exit
	fi
	
	if [[ ${file} =~ $regex_local_video ]]
	then
		echo "local_video"
		exit
	fi
	
	if [[ ${file} =~ $regex_youtube ]]
	then
		echo "online_youtube"
		exit
	fi
	
	if [[ ${file} =~ $regex_url_http_https ]] || [[ ${file} =~ $regex_url_www ]]
	then
		echo "online_browser"
		exit
	fi
	
else
	echo "Variable vacía"
	exit 0
fi


