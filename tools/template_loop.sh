#!/bin/bash

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
