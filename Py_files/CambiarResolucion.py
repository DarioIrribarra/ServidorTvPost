import os
import subprocess
import sys

#Kill all the active windows
os.system('pkill -o chromium')
os.system('pkill gpicview')
os.system('pkill vlc')
#Check the amount of active monitors
info = subprocess.run("bash ~/TvPost/Bash_files/check_active_monitors.sh",
                      shell=True,
                      capture_output=True,
                      text=True)
#Check the name of the display
infoDisplay = subprocess.run("bash ~/TvPost/Bash_files/NombreDipsositivoVideo.sh",
                      shell=True,
                      capture_output=True,
                      text=True)
infoDisplay=str(infoDisplay.stdout).replace("\n", "")

#If there are more than 1 monitors, delete all the other monitors
if int(info.stdout) == 2:
    os.system('xrandr --delmonitor ' +infoDisplay+'~1; '+
              'xrandr --delmonitor ' +infoDisplay+'~2')
    
if int(info.stdout) == 3:
    os.system('xrandr --delmonitor ' +infoDisplay+'~1; '+
              'xrandr --delmonitor ' +infoDisplay+'~2; '+
              'xrandr --delmonitor ' +infoDisplay+'~3')

#If resolution files exist in the Resolution folder I delete them
if os.path.exists('/home/pi/TvPost/Resolutions/base_resolution.txt'):
    os.remove('/home/pi/TvPost/Resolutions/base_resolution.txt')

if os.path.exists('/home/pi/TvPost/Resolutions/new_resolutions.txt'):
    os.remove('/home/pi/TvPost/Resolutions/new_resolutions.txt')
    
if os.path.exists('/home/pi/TvPost/Resolutions/window_id.txt'):
    os.remove('/home/pi/TvPost/Resolutions/window_id.txt')
#Change resolution
ancho = str(sys.argv[1]).replace("\n", "")
alto = str(sys.argv[2]).replace("\n", "")

os.system('xrandr --size {}x{}'.format(ancho,alto))
#Create resolution file
os.system('python3 /home/pi/TvPost/Py_files/Screen_info.py')