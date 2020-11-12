#!/bin/sh
echo "----------------------------------------"
echo "Actualizando..."
sudo apt-get update && sudo apt-get upgrade -y;
echo "----------------------------------------"
echo "Actualización correcta"

echo "----------------------------------------"
echo "Instalando Apache Server..."
sudo apt-get install apache2 -y;
echo "----------------------------------------"
echo "Apache instalado correctamente"

echo "----------------------------------------"
echo "Creando carpetas..."
sudo cp -r ~/TvPost/WebServer/* /var/www/html/;
sudo mkdir /var/www/html/ImagenesPostTv;
sudo mkdir /var/www/html/VideosPostTv;
echo "----------------------------------------"
echo "Carpetas creadas correctamente"

echo "----------------------------------------"
echo "Otorgando permisos..."
sudo chown pi: /var/www/html/ImagenesPostTv;
sudo chown pi: /var/www/html/VideosPostTv;
sudo chown pi: /var/www/html/upload_one_image.php;
sudo chown pi: /var/www/html/upload_one_video.php;
echo "----------------------------------------"
echo "Permisos otorgados correctamente"

echo "----------------------------------------"
echo "Instalando php..."
sudo apt-get install php libapache2-mod-php -y;
echo "----------------------------------------"
echo "Php instalado correctamente"
echo "----------------------------------------"
echo "Instalación de WebServer TvPost finalizada correctamente"
echo "----------------------------------------"
