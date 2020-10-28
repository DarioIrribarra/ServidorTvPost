import os
import subprocess
import tkinter
import re
import Formato_50_50
import Formato_100
import Formato_80_20_10
#import Screen_info

#Selecting the screen resolution
def menu(screen_selection):
    os.system("bash Bash_files/Menu.sh {}".format(screen_selection))
    
def screen_info():
    Screen_info.py
    
def check_amount_monitors():
    info = subprocess.run("bash Bash_files/check_active_monitors.sh",
                          shell=True,
                          capture_output=True,
                          text=True)
    return info.stdout
    
def monitor_80_20_10():
    Formato_80_20_10.formato_80_20_10()
    
def monitor_100():
    Formato_100.formato_100()
    
def monitor_50_50():
    Formato_50_50.formato_50_50()
    
def app_opener():
    os.system('bash /home/pi/Desktop/app_opening_functions.sh 3-1 /home/pi/VideosPosTv/jellyfish-25-mbps-hd-hevc.avi')
#Creating the program window
root = tkinter.Tk()
root.title("Elija un tamaño de pantalla")
frame = tkinter.Frame(root)
frame.pack()

button_apps_opening = tkinter.Button(frame,
                                     text = "Abrir vlc app",
                                     command=lambda: app_opener())
button_apps_opening.pack()

#Adding buttons - use lambda expressions to pass an argument to the function
button_check_screens = tkinter.Button(frame,
                                      text= "Cantidad monitores",
                                      command=lambda: print(check_amount_monitors()))
button_check_screens.pack()

button_info_screens = tkinter.Button(frame,
                                     text="resoluciones",
                                     command=lambda: screen_info())
button_info_screens.pack()

button_1_screen = tkinter.Button(frame,
                                 text="Una pantalla",
                                 command=lambda: monitor_100())
button_1_screen.pack()

button_2_screens = tkinter.Button(frame,
                                  text="Dos pantallas",
                                  command=lambda: monitor_50_50())
button_2_screens.pack()

button_3_screens = tkinter.Button(frame,
                                  text="Tres pantallas",
                                  command=lambda: monitor_80_20_10())
button_3_screens.pack()

root.mainloop()





