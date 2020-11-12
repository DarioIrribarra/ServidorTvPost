<?php
	$image = $_POST['image'];
	$name = $_POST['name'];
	$ruta = "/var/www/html/ImagenesPostTv/{$name}";

	$imagenFinal = base64_decode($image);

	file_put_contents($ruta, $imagenFinal);

	echo "Imagen subida exitosamente";

?>
