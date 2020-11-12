import socket
import os
import io
import time
from PIL import Image
#Function that creates a new socket
def createSocket():
    
    host = ""
    port = 5560
    
    #Creates a socket
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        print("Socket creado. Esperando conexión...")
    except socket.error as msg:
        print("Error al crear socket: "+str(msg))
        
    #Binding Socket
    try:
        s.bind((host,port))
        s.listen(5)
    except socket.error as msg:
        print("Error al bind el socket: "+str(msg))
        
    conn, address = s.accept()
    print("Conectado a: " + address[0] + ":" + str(address[1]))
    dataTransfer(conn)
    conn.close()
    print("Conexión cerrada")
    return

#Funcion que envía y recibe datos
def dataTransfer(conn):
    while True:
        #Recive la data
        data = conn.recv(8192) #Recive la data
        data = data.decode('utf-8')
        #Separa la data entre comando e instrucción del resto de la data
        dataMessage = data.split(' ')
        command = dataMessage[0]
        
        if command == 'TVPOSTPING':
            reply = ResponderPing()
            conn.send(bytes(reply,"UTF-8"))
            print(reply)
            return
        
        if command == 'TVPOSTRES':
            reply = CambiarResolucion(dataMessage[1], dataMessage[2])
            conn.send(bytes(reply,"UTF-8"))
            print(reply)
            return
        
        elif command == 'TVPOSTMODLAYOUT':
            reply = ModificarLayout(dataMessage)
            conn.send(bytes(reply,"UTF-8"))
            print(reply)
            return
        
        elif command == 'TVPOSTGETSCREEN':
            respuesta = CapturarPantalla(conn)
            print(respuesta)
            return

        #Entrega el listado completo de nombres de imágenes
        elif command == 'TVPOSTGETNOMBREIMAGENES':
            respuesta = NombresImagenes(conn)
            print(respuesta)
            return
        #Comprueba el nombre entrante para ver si existe y no
        #reemplazarlo
        elif 'TVPOSTVERIFICANOMBREIMAGEN' in command:
            respuesta = VerificarNombreImagen(conn, dataMessage[1])
            print(respuesta)
            return

        #Entrega el listado completo de nombres de videos
        elif command == 'TVPOSTGETNOMBREVIDEOS':
            respuesta = NombresVideos(conn)
            print(respuesta)
            return
        #Verifica nombre de video
        elif 'TVPOSTVERIFICANOMBREVIDEO' in command:
            respuesta = VerificarNombreVideo(conn, dataMessage[1])
            print(respuesta)
            return

        #Recibe video desde android
        elif command == 'TVPOSTGETDATOSREPRODUCCIONACTUAL':
            respuesta = DatosReproduccionActual(conn)
            print(respuesta)
            return
        
#Funciones que reciben y envían datos
def ResponderPing():
    return "Conectado"
       
def CambiarResolucion(Ancho, Alto):
    os.system('python3 /home/pi/TvPost/Py_files/CambiarResolucion.py {} {}'.format(Ancho,Alto))
    return ('Resolución cambiada a: ' + Ancho + 'x' + Alto)

def ModificarLayout(ArregloDatos):
    #Leer el archivo de información si existe y obtener el layout.
    #Si al compararlo con el layout que viene desde el móvil son distinos, se cambia
    #la resolucion, sino, se mantiene

    #Datos que se escriben en el archivo para obtenerlos en el equipo móvil
    layout = ""
    if (ArregloDatos[1] == '100'):
        layout = "1"
    if (ArregloDatos[1] == '5050'):
        layout = "2"
    if (ArregloDatos[1] == '802010'):
        layout = "3"
    tipoArchivo1 = ArregloDatos[3]
    tipoArchivo2 = ArregloDatos[4]
    tipoArchivo3 = ArregloDatos[5]
    archivo1 = ArregloDatos[6]
    archivo2 = ArregloDatos[7]
    archivo3 = ArregloDatos[8]
    porcionACambiar = ArregloDatos[2]
    if (porcionACambiar == "null"):
        #Preguntar que layout viene para mantener cierta porcion
        #layout 100 mantiene archivo izquierda
        #layout 2 mantiene izquierda y derecha
        #layout 3 mantiene todo
        if layout == "1":
            porcionACambiar = "mantener1"
        if layout == "2":
            porcionACambiar = "mantener2"
        if layout == "3":
            porcionACambiar = "mantener3"
    else:
        #Verifico si se necesita cambiar layout o no
        #solo cambia layout si no se desea mantener algo
        #si se desea mantener, se cambio luego de manipular
        #las apps en el bash opening_apps
        CambioLayout(layout)
        
    #Se escriben los datos del archivo de repŕoduccion atual
    CrearArchivoDatosReproduccion(ArregloDatos)
    
    try:
        
        
        listadoArchivosUtilizar = []

        if (porcionACambiar == "1-1"):
            listadoArchivosUtilizar.clear()
            listadoArchivosUtilizar.append(archivo1)
            
        if (porcionACambiar == "2-1"):
            listadoArchivosUtilizar.clear()
            listadoArchivosUtilizar.append(archivo1)
            
        if (porcionACambiar == "2-2"):
            listadoArchivosUtilizar.clear()
            listadoArchivosUtilizar.append(archivo2)
            
        if (porcionACambiar == "2-3"):
            listadoArchivosUtilizar.clear()
            listadoArchivosUtilizar.append(archivo1)
            listadoArchivosUtilizar.append(archivo2)
            
        if (porcionACambiar == "3-1"):
            listadoArchivosUtilizar.clear()
            listadoArchivosUtilizar.append(archivo1)
        
        if (porcionACambiar == "3-2"):
            listadoArchivosUtilizar.clear()
            listadoArchivosUtilizar.append(archivo2)
            
        if (porcionACambiar == "3-3"):
            listadoArchivosUtilizar.clear()
            listadoArchivosUtilizar.append(archivo3)
        
        if (porcionACambiar == "3-4"):
            listadoArchivosUtilizar.clear()
            listadoArchivosUtilizar.append(archivo1)
            listadoArchivosUtilizar.append(archivo2)
            listadoArchivosUtilizar.append(archivo3)
            
        if (porcionACambiar == "3-5"):
            listadoArchivosUtilizar.clear()
            listadoArchivosUtilizar.append(archivo1)
            listadoArchivosUtilizar.append(archivo2)
            
        if (porcionACambiar == "3-6"):
            listadoArchivosUtilizar.clear()
            listadoArchivosUtilizar.append(archivo2)
            listadoArchivosUtilizar.append(archivo3)
            
        if (porcionACambiar == "3-7"):
            listadoArchivosUtilizar.clear()
            listadoArchivosUtilizar.append(archivo1)
            listadoArchivosUtilizar.append(archivo3)
            

        archivoBash = 'bash /home/pi/TvPost/Bash_files/app_opening_functions.sh'
        archivoBash += ' ' + porcionACambiar
        #for i in range (5, len(ArregloDatos)):
        for archivo in listadoArchivosUtilizar:
            print("Archivo: " + archivo)
            #archivoBash += ' ' + ArregloDatos[i]
            archivoBash += ' ' + archivo
        
        print("Instruccion al cambiar: " + archivoBash)
        os.system(archivoBash)
        print('OK!')
    except:
        return 'Error al crear archivo bash'
    
    return 'Ok, vea sus pantallas'

def CrearArchivoDatosReproduccion(ArregloDatos):
    
    #Datos que se escriben en el archivo para obtenerlos en el equipo móvil
    layout = ""
    if (ArregloDatos[1] == '100'):
        layout = "1"
    if (ArregloDatos[1] == '5050'):
        layout = "2"
    if (ArregloDatos[1] == '802010'):
        layout = "3"
    tipoArchivo1 = ArregloDatos[3]
    tipoArchivo2 = ArregloDatos[4]
    tipoArchivo3 = ArregloDatos[5]
    archivo1 = ArregloDatos[6]
    archivo2 = ArregloDatos[7]
    archivo3 = ArregloDatos[8]
    
    #Crea archivo de datos de reproduccion actual
    try:
        #Verifrica contenido de archivo actual
        archivoDatosReprroduccion = "/home/pi/TvPost/Resolutions/datos_reproduccion.txt"
        d = {}
        if (os.path.exists(archivoDatosReprroduccion)):
            with open(archivoDatosReprroduccion) as f:
                for line in f:
                    (key, val) = line.strip().split(",")
                    d[key] = val
        
        if archivo1 != '0' and '/var/www/html' in archivo1:
            archivo1 = archivo1[13:]
        if archivo2 != '0' and '/var/www/html' in archivo2:
            archivo2 = archivo2[13:]
        if archivo3 != '0' and '/var/www/html' in archivo3:
            archivo3 = archivo3[13:]
            
        archivoDatos = "/home/pi/TvPost/Resolutions/datos_reproduccion.txt"
        #Escribe los datos
        with open(archivoDatos, "w") as f:
            f.write("layout," + layout + "\n")
            f.write("tipoArchivo1," + tipoArchivo1 + "\n")
            f.write("tipoArchivo2," + tipoArchivo2 + "\n")
            f.write("tipoArchivo3," + tipoArchivo3 + "\n")
            f.write("archivo1," + archivo1 + "\n")
            f.write("archivo2," + archivo2 + "\n")
            f.write("archivo3," + archivo3)
            
    except:
        print('Error al crear archivo datos reprroducicon')
    

def CambioLayout(layout):
    #Cambio de porción solo si es distinto
        direccion_archivo_datos = "/home/pi/TvPost/Resolutions/datos_reproduccion.txt"
        layoutActualEnArchivo = ""
        if os.path.exists(direccion_archivo_datos):
            with open(direccion_archivo_datos, "rt") as f:
                for line in f:
                    if "layout," in line:
                        #Asigna valor
                        layoutActualEnArchivo = str(line[line.index(',') + 1:]).strip()
                        if layout != layoutActualEnArchivo:
                            try:
                                if layout == "1":
                                    if os.system('python3 /home/pi/TvPost/Py_files/Formato_100.py'):
                                        os.wait()
                                if layout == "2":
                                    if os.system('python3 /home/pi/TvPost/Py_files/Formato_50_50.py'):
                                        os.wait()
                                if layout == "3":
                                    if os.system('python3 /home/pi/TvPost/Py_files/Formato_80_20_10.py'):
                                        os.wait()
                            except:
                                return 'Error al cambiar layout'
                        break
                
        else:
            #Si no existe el archivo, se genera una nueva partición de pantalla utilizando
            #el valor que viene desde l dispositvo
            
            try:
                if layout == "1":
                    if os.system('python3 /home/pi/TvPost/Py_files/Formato_100.py'):
                        os.wait()
                if layout == "2":
                    if os.system('python3 /home/pi/TvPost/Py_files/Formato_50_50.py'):
                        os.wait()
                if layout == "3":
                    if os.system('python3 /home/pi/TvPost/Py_files/Formato_80_20_10.py'):
                        os.wait()
            except:
                return 'Error al cambiar layout'
            
        
def CapturarPantalla(conn):
    #Tomo captura
    os.system('bash /home/pi/TvPost/Bash_files/screenshot.sh')
    
    archivo="/home/pi/TvPost/Screenshots/pantalla.png"
    
    with open(archivo, "rb") as f:
        content = f.read()
        
    size = len(content)
    print("File bytes: ", size)

    conn.sendall(content)
             
    print("Enviando...")
    
    return "Datos enviados"

def NombresImagenes(conn):
    directorio = '/var/www/html/ImagenesPostTv'
    #directorio = '/home/pi/TvPost/ImagenesPostTv/'
    dirs = os.listdir(directorio)
    listadoItemsEnDirectorio = os.listdir(directorio)
    listadoItemsEnDirectorio.sort()
    listunido = ','.join(map(str, listadoItemsEnDirectorio))
    #Envío nombre de archivo
    conn.sendall(listunido.encode())
    
    print("Enviando Nombres")
    
    return "ENviado nombres"

def VerificarNombreImagen(conn, nombreImagen):
    #Obtiene el listado de archivos
    directorio = '/var/www/html/ImagenesPostTv'
    dirs = os.listdir(directorio)
    resultado = '';
    if nombreImagen in dirs:
        resultado = 'Existe'
    else:
        resultado = 'No existe'
        
    print(resultado)
    conn.sendall(resultado.encode())
    return "Resultado Enviado"

def NombresVideos(conn):
    #directorio = '/var/www/html/VideosPostTv'
    #Obtiene el listado de archivos
    directorioVideos = '/var/www/html/VideosPostTv'

    #Se crea el listado que guarda los nombres de videos
    dirsVideos = []
    for archivo in os.scandir(directorioVideos):
        if archivo.is_file():
            dirsVideos.append(archivo.name)

    dirsVideos.sort()
    listunido = ','.join(map(str, dirsVideos))
    
    #Envío nombre de archivo
    conn.sendall(listunido.encode())
    
    print("Enviando Nombres")
    
    return "Eviado nombres"

def VerificarNombreVideo(conn, nombreVideo):
    #Obtiene el listado de archivos
    directorio = '/var/www/html/VideosPostTv/'
    dirs = os.listdir(directorio)
    resultado = '';
    if nombreVideo in dirs:
        resultado = 'Existe'
    else:
        resultado = 'No existe'
        
    print(resultado)
    conn.sendall(resultado.encode())
    return "Resultado Enviado"

def DatosReproduccionActual(conn):
    #va a buscar archivo con datos de reproduccion actual.
    archivoDatosReprroduccion = "/home/pi/TvPost/Resolutions/datos_reproduccion.txt"
    d = {}
    if (os.path.exists(archivoDatosReprroduccion)):
        with open(archivoDatosReprroduccion) as f:
            for line in f:
                (key, val) = line.strip().split(",")
                d[key] = val
    #Acá debe retornar el diccionario
    dTransformado = str(d)
    dTransformado = dTransformado.replace("'", '"')
    #print(dTransformado)
    conn.sendall(dTransformado.encode())
    #conn.sendall("{}".encode())

    return 'Datos reproduccion enviados'

def Main():
    while True:
        createSocket()
        
#Se ejecuta la creación de socket en Main
Main()
    