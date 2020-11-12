<?php
	$image = $_POST['video'];
	$name = $_POST['name'];
	$ruta = "/var/www/html/VideosPostTv/{$name}";

	$videoFinal = base64_decode($image);

	file_put_contents($ruta, $videoFinal);

	echo "Video subido exitosamente";

?>
