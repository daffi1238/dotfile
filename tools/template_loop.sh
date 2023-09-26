#!/bin/bash

# Función para manejar Ctrl+C
ctrl_c() {
  echo -e "\nScript interrumpido por el usuario."
  exit 1
}

# Configurar la trampa para Ctrl+C (SIGINT)
trap 'ctrl_c' SIGINT

if [[ ! -f "$1" ]]; then
  echo "Por favor, proporciona un archivo válido."
  exit 1
fi

lines=$($1 | wc -l)
counter=1

while IFS= read -r linea
do
  echo $counter/$lines
  echo "$linea"
  count=$((counter+1))
done < "$1"
