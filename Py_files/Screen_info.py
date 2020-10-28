import os

#list of User folders
usr = os.listdir("/home")

#Creates the file with the base resolutions if there isn't any
def screen_info():
    if os.path.isfile(os.path.join("/home", usr[0], "TvPost/Resolutions", "base_resolution.txt")) == False:
        os.system("bash ~/TvPost/Bash_files/screen_info.sh")

screen_info()
