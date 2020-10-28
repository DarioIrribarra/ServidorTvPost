import socket
import os
import io
import time
import threading
from PIL import Image

class ClientThread(threading.Thread):
    clientAddress = '';
    conn = '';
    def __init__(self, address, clientSocket):
        threading.Thread.__init__(self, name="hiloNuevo", target=ClientThread.run)
        self.conn = clientSocket
        self.clientAddress = address
        print ("Nueva conexión con: ", self.clientAddress)
    
    #Funciones que reciben y envían datos
    def ResponderPing(self):
        return "Conectado"
    
    def CambiarResolucion(self, Ancho, Alto):
        os.system('python3 /home/pi/TvPost/Py_files/CambiarResolucion.py {} {}'.format(Ancho,Alto))
        return ('Resolución cambiada a: ' + Ancho + 'x' + Alto)
    
    def NuevoLayout(self, ArregloDatos):
    #Tomo formato de la resolución
        FormatoLayout = ArregloDatos[1]
        try:
            if FormatoLayout == "100":
                os.system('python3 /home/pi/TvPost/Py_files/Formato_100.py')
            if FormatoLayout == "5050":
                os.system('python3 /home/pi/TvPost/Py_files/Formato_50_50.py')
            if FormatoLayout == "802010":
                os.system('python3 /home/pi/TvPost/Py_files/Formato_80_20_10.py')
        except:
            return 'Error al cambiar layout'
        
        #Cuando termina de cambiar formato, se abre la app correcta en las ventanas correspondientes
        try:
            archivoBash = 'bash /home/pi/TvPost/Bash_files/app_opening_functions.sh'
            for i in range (2, len(ArregloDatos)):
                archivoBash += ' ' + ArregloDatos[i]

            os.system(archivoBash)
            print('OK!')
        except:
            return 'Error al crear archivo bash'
        
        
        return 'Ok, vea sus pantallas'

    def ModificarLayout(self, ArregloDatos):
        #Se abre la app correcta en las ventanas correspondientes
        try:
            archivoBash = 'bash /home/pi/TvPost/Bash_files/app_opening_functions.sh'
            for i in range (1, len(ArregloDatos)):
                archivoBash += ' ' + ArregloDatos[i]

            os.system(archivoBash)
            print('OK!')
        except:
            return 'Error al crear archivo bash'
        
        return 'Ok, vea sus pantallas'
    
    def CapturarPantalla(self,conn):
        #Tomo captura
        os.system('bash /home/pi/TvPost/Bash_files/screenshot.sh')
        
        archivo="/home/pi/TvPost/Screenshots/pantalla.png"
        
        with open(archivo, "rb") as f:
            content = f.read()
            
        size = len(content)
        print("File bytes: ", size)
        
        #Envío tamaño
        #conn.sendall(size.to_bytes(4, byteorder='big'))
        #Espero respuetsa de tamaño
        #buff = conn.recv(4)
        #resp = int.from_bytes(buff, byteorder='big')
        #print("Respuesta: ",resp)
        
        #if size == resp:
        conn.sendall(content)
                 
        print("Enviando...")
        
        return "Datos enviados"
        
    def CantidadImagenes(self, conn):
        directorio = '/home/pi/TvPost/ImagenesPostTv/'
        dirs = os.listdir(directorio)
        #Cantidad de archivos a enviar
        cantidad = len(dirs)
        #Envío cantidad
        conn.sendall(cantidad.to_bytes(4, byteorder='big'))
        return "Cantidad imagenes encontradas: " + str(cantidad)
    
    
    def NombresImagenes(self, conn):
        directorio = '/home/pi/TvPost/ImagenesPostTv/'
        dirs = os.listdir(directorio)
        listadoItemsEnDirectorio = os.listdir(directorio)
        listadoItemsEnDirectorio.sort()
        listunido = ','.join(map(str, listadoItemsEnDirectorio))
        #listArray = bytearray(listadoItemsEnDirectorio)
        #Envío nombre de archivo
        conn.sendall(listunido.encode())
        
        print("Enviando Nombres")
        
        return "Nombres enviados"
    
    def ListadoImagenes(self, conn, command):
        #Obtiene el listado de archivos
        directorio = '/home/pi/TvPost/ImagenesPostTv/'
        listadoItemsEnDirectorio = os.listdir(directorio)
        listadoItemsEnDirectorio.sort()
        #Toma el valor que viene del cliente
        posicionImagenEnListado = command[15:];
        #Busca entre las imágenes que existen la que se pide
        imagen=listadoItemsEnDirectorio[int(posicionImagenEnListado)]
        #Se forma la ruta final
        archivo = directorio + imagen
        
        with open(archivo, "rb") as f:
            content = f.read()
            
        size = len(content)
        print("File bytes: ", size)
        
        #Envío tamaño
        #conn.sendall(size.to_bytes(4, byteorder='big'))
        #Espero respuetsa de tamaño
        #buff = conn.recv(4)
        #resp = int.from_bytes(buff, byteorder='big')
        #print("Respuesta: ",resp)
        
        try:
            #if size == resp:
            conn.sendall(content)
        except:
            print("Error al envío de datos")
                 
        #Espero respuetsa de envío
        #buff = conn.recv(1024)
        #resp = int.from_bytes(buff, byteorder='big')
        #resp = buff.decode("utf-8")
        #print("Respuesta de envío: ",resp)
        
        #Envío nombre de archivo
        #conn.sendall(imagen.encode())
        
        print("Enviando...")
        #Para que no se cierre antes la conexión
        #time.sleep(2)
        return "Datos enviados"
    
    def VerificarNombreImagen(self, conn, nombreImagen):
        #Obtiene el listado de archivos
        directorio = '/home/pi/TvPost/ImagenesPostTv/'
        dirs = os.listdir(directorio)
        resultado = '';
        if nombreImagen in dirs:
            resultado = 'Existe'
        else:
            resultado = 'No existe'
            
        print(resultado)
        conn.sendall(resultado.encode())
        return "Resultado Enviado"
    
    def RecibirImagen(self, conn):
        #conn.sendall("Recibiendo".encode())
        size = conn.recv(1024)
        sizeImagen = size.decode("utf-8")
        print('Tamaño: ' + sizeImagen)
        #Envio tamaño de respuesta
        #conn.sendall(sizeImagen.encode())
        
        nombre = conn.recv(1024)
        nombreImagen = nombre.decode("utf-8")
        
        
        direccionImagen = '/home/pi/TvPost/ImagenesPostTv/' + nombreImagen
        print('directorio: ' + direccionImagen)
        
        print('Nombre: ' + nombreImagen)
        with open(direccionImagen, 'wb') as img:
            while True:
                data = conn.recv(1024)
                #print(data)
                if not data:
                    break
                img.write(data)
        print('listo')
        
        return "Imagen Recibida"
    
    def ListadoVideos(self, conn, command):
        #Obtiene el listado de archivos
        directorio = '/home/pi/TvPost/VideosPostTv/Samples/'
        listadoItemsEnDirectorio = os.listdir(directorio)
        listadoItemsEnDirectorio.sort()
        #Toma el valor que viene del cliente
        posicionVideonEnListado = command[14:];
        #Busca entre los videos que existen el que se pide
        video=listadoItemsEnDirectorio[int(posicionVideonEnListado)]
        #Se forma la ruta final
        archivo = directorio + video
        
        with open(archivo, "rb") as f:
            content = f.read()
            
        size = len(content)
        print("File bytes: ", size)
        
        #Envío tamaño
        conn.sendall(size.to_bytes(4, byteorder='big'))
        #Espero respuetsa de tamaño
        buff = conn.recv(4)
        resp = int.from_bytes(buff, byteorder='big')
        print("Respuesta: ",resp)
        
        try:
            if size == resp:
                conn.sendall(content)
        except:
            print("Error al envío de datos")
                 
        #Espero respuetsa de envío
        buff = conn.recv(1024)
        #resp = int.from_bytes(buff, byteorder='big')
        resp = buff.decode("utf-8")
        print("Respuesta de envío: ",resp)
        
        #Envío nombre de archivo
        #conn.sendall(imagen.encode())
        
        print("Enviando...")
        #Para que no se cierre antes la conexión
        #time.sleep(2)
        return "Datos enviados"
    
    def NombresVideos(self, conn):
        directorio = '/home/pi/TvPost/VideosPostTv/Samples/'
        dirs = os.listdir(directorio)
        listadoItemsEnDirectorio = os.listdir(directorio)
        listadoItemsEnDirectorio.sort()
        listunido = ','.join(map(str, listadoItemsEnDirectorio))
        #listArray = bytearray(listadoItemsEnDirectorio)
        #Envío nombre de archivo
        conn.sendall(listunido.encode())
        
        print("Enviando Nombres")
        
        return "Enviado nombres"
    
    def VerificarNombreVideo(self, conn, nombreVideo):
        #Obtiene el listado de archivos
        directorio = '/home/pi/TvPost/VideosPostTv/'
        dirs = os.listdir(directorio)
        resultado = '';
        if nombreVideo in dirs:
            resultado = 'Existe'
        else:
            resultado = 'No existe'
            
        print(resultado)
        conn.sendall(resultado.encode())
        return "Resultado Enviado"
    
    def RecibirVideo(self, conn):
        #conn.sendall("Recibiendo".encode())
        size = conn.recv(1024)
        sizeVideo = size.decode("utf-8")
        print('Tamaño: ' + sizeVideo)
        #Envio tamaño de respuesta
        #conn.sendall(sizeImagen.encode())
        
        nombre = conn.recv(1024)
        nombreVideo = nombre.decode("utf-8")
        
        
        direccionVideo= '/home/pi/TvPost/VideosPostTv/' + nombreVideo
        print('directorio: ' + direccionVideo)
        
        print('Nombre: ' + nombreVideo)
        with open(direccionVideo, 'wb') as file:
            while True:
                data = conn.recv(1024)
                #print(data)
                if not data:
                    break
                file.write(data)
        print('listo')
        
        #Se toma un extracto de 3 segundos de video y se guarda
        #En la carpeta de samples con prefijo "sample"
        os.system('vlc /home/pi/TvPost/VideosPostTv/' + nombreVideo +
                  ' -V dummy --intf=dummy --sout file/'+
                  'mp4:/home/pi/TvPost/VideosPostTv/Samples/' +nombreVideo+
                  ' --run-time=10 vlc://quit')
        
        return "Video Recibido"

    def run(self):
        #print("Conección desde: ", self.clientAddress)
        while True:
            data = conn.recv(8192) #Recive la data
            data = data.decode('utf-8')
            dataMessage = data.split(' ')
            command = dataMessage[0]
            
            if command == 'TVPOSTPING':
                reply = self.ResponderPing()
                conn.send(bytes(reply,"UTF-8"))
                print(reply)
                conn.close()
                break
            
            elif command == 'TVPOSTRES':
                reply = self.CambiarResolucion(dataMessage[1], dataMessage[2])
                conn.send(bytes(reply,"UTF-8"))
                print(reply)
                conn.close()
                break
        
            elif command == 'TVPOSTNEWLAYOUT':
                reply = self.NuevoLayout(dataMessage)
                conn.send(bytes(reply,"UTF-8"))
                print(reply)
                conn.close()
                break
            
            elif command == 'TVPOSTMODLAYOUT':
                reply = self.ModificarLayout(dataMessage)
                conn.send(bytes(reply,"UTF-8"))
                print(reply)
                conn.close()
                break
            
            elif command == 'TVPOSTGETSCREEN':
                respuesta = self.CapturarPantalla(conn)
                print(respuesta)
                conn.close()
                break
            
            elif command == 'TVPOSTCANTIDADIMAGENES':
                respuesta = self.CantidadImagenes(conn)
                print(respuesta)
                conn.close()
                break
            
            elif command[:15] == 'TVPOSTGETIMAGEN':
                respuesta = self.ListadoImagenes(conn, command)
                print(respuesta)
                conn.close()
                break
            #Entrega el listado completo de nombres de imágenes
            elif command == 'TVPOSTGETNOMBREIMAGENES':
                respuesta = self.NombresImagenes(conn)
                print(respuesta)
                conn.close()
                break
            #Comprueba el nombre entrante para ver si existe y no
            #reemplazarlo
            elif 'TVPOSTVERIFICANOMBREIMAGEN' in command:
                respuesta = self.VerificarNombreImagen(conn, dataMessage[1])
                print(respuesta)
                conn.close()
                break
            #Recibe imagen desde android
            elif command == 'TVPOSTRECIBIRIMAGEN':
                respuesta = self.RecibirImagen(conn)
                print(respuesta)
                conn.close()
                break
            #Se envía el video seleccionado
            elif command[:14] == 'TVPOSTGETVIDEO':
                respuesta = self.ListadoVideos(conn, command)
                print(respuesta)
                conn.close()
                break
            #Entrega el listado completo de nombres de videos
            elif command == 'TVPOSTGETNOMBREVIDEOS':
                respuesta = self.NombresVideos(conn)
                print(respuesta)
                conn.close()
                break
            #Verifica nombre de video
            elif 'TVPOSTVERIFICANOMBREVIDEO' in command:
                respuesta = self.VerificarNombreVideo(conn, dataMessage[1])
                print(respuesta)
                conn.close()
                break
            #Recibe video desde android
            elif command == 'TVPOSTRECIBIRVIDEO':
                respuesta = self.RecibirVideo(conn)
                print(respuesta)
                conn.close()
                break
        
def CrearSamplesVideos():
    #Obtiene el listado de archivos
    directorioVideos = '/home/pi/TvPost/VideosPostTv/'

    #Se crea el listado que guarda los nombres de videos
    dirsVideos = []
    for archivo in os.scandir(directorioVideos):
        if archivo.is_file():
            dirsVideos.append(archivo.name)

    #Se obtienen los nombres de samples
    directorioSamples = '/home/pi/TvPost/VideosPostTv/Samples/'

    #Se crea el listado que guarda los nombres de samples
    dirsSamples = []
    for archivo in os.scandir(directorioSamples):
        dirsSamples.append(archivo.name)

    #Se busca cada archivo en el listado de Samples
    for nombreVideo in dirsVideos:
        #Si no tiene un samplke creado, se crea
        if nombreVideo not in dirsSamples:
            os.system('vlc /home/pi/TvPost/VideosPostTv/' + nombreVideo +
                      ' -V dummy --intf=dummy --sout file/'+
                      'mp4:/home/pi/TvPost/VideosPostTv/Samples/' +nombreVideo+
                      ' --run-time=10 vlc://quit')
            
    return "Samples creados"        

host = ""
port = 5560

#Se crean los samples de los videos y luego inicia
CrearSamplesVideos()

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
    
except socket.error as msg:
    print("Error al bind el socket: "+str(msg))
    
while True:
    s.listen(5)
    conn, address = s.accept()
    newthread = ClientThread(address, conn)
    newthread.start()
