#!/bin/sh
if [ "${1}" == "1" ]; then
	echo "Una pantalla: "${1}
fi

if [ "${1}" == "2" ]; then
	echo "Dos pantallas: "${1}
fi

if [ "${1}" == "3" ]; then
	echo "Tres pantallas: "${1}
fi

if [ "${1}" != "1" ] && [ "${1}" != "2" ] && [ "${1}" != "3" ] || [ "${1}" == " " ]; then
	echo "Error: Pantalla no seleccionada"
fi
