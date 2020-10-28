import socket
import os
import io
import time
from PIL import Image

direccion_archivo_datos = "/home/pi/TvPost/Resolutions/datos_reproduccion.txt"
layoutActualEnArchivo = ""
if os.path.exists(direccion_archivo_datos):
    with open(direccion_archivo_datos, "rt") as f:
        for line in f:
            if "layout," in line:
                #Asigna valor
                layoutActualEnArchivo = line[line.index(',') + 1:]
                break
        
else:
    #Si no existe el archivo, se genera una nueva partición de pantalla utilizando
    #el valor que viene desde l dispositvo
        
