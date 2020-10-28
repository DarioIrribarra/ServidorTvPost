import os
import subprocess
import re

#list of User folders
usr = os.listdir("/home")

def check_amount_monitors():
    info = subprocess.run("bash ~/TvPost/Bash_files/check_active_monitors.sh",
                          shell=True,
                          capture_output=True,
                          text=True)
    return info.stdout

def formato_80_20_10():
    
        #Check that the base resolutions file exsits
    os.system('python3 /home/pi/TvPost/Py_files/Screen_info.py')        ;
    
    
    resolution_values=[]
    
    try:
        with open(os.path.join("/home", usr[0], "TvPost/Resolutions", "base_resolution.txt")) as file:
            for line in file:
                regex = re.search(r':-(.+)', line)
                if regex:
                    resolution_values.append(regex.group(1))
    except:
        print('No se encuentra el archivo')
        
    
    #Pass the argument to screen layout bash
    #$1 = width in pixels
    #$2 = width in mm
    #$3 = height in pixels
    #$4 = height in mm
    #$5 = video adapter name
    #$6 = amount of active monitors (Split screen already selected and functioning)
    #for value in resolution_values:
      #  print(value)
    #Gettin active monitors
    resolution_values.append(int(check_amount_monitors()))
    os.system('bash ~/TvPost/Bash_files/80_20_10.sh {} {} {} {} {} {}'.format(resolution_values[0], resolution_values[1], resolution_values[2], resolution_values[3], resolution_values[4], resolution_values[5]))
    #print(resolution_values)

formato_80_20_10()