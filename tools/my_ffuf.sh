#!/bin/bash

# Mostrar ayuda si no se proporcionan argumentos
if [ "$#" -eq 0 ]; then
    echo "Uso: $0 -u <url> -w <wordlist> -t <threads> -x <proxy> -of <output_format> -o <output_file> -fw <filter_wordcount>"
    exit 1
fi

# Leer argumentos
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -u) url="$2"; shift ;;
        -w) wordlist="$2"; shift ;;
        -t) threads="$2"; shift ;;
        -x) proxy="$2"; shift ;;
        -of) output_format="$2"; shift ;;
        -o) output_file="$2"; shift ;;
        -fw) filter_wordcount="$2"; shift ;;
        *) echo "Argumento desconocido: $1"; exit 1 ;;
    esac
    shift
done

# Verificar si las variables obligatorias están establecidas
if [[ -z "$url"  -z "$wordlist"  -z "$threads" || -z "$proxy" ]]; then
    echo "Faltan argumentos."
    exit 1
fi

#Creamos las variables para los ficheros de output
# Elimina el "https://"
url_out=$(echo $url | sed 's/https\?:\/\///g')
# Elimina "/FUZZ" del final
url_out="${url_out%/FUZZ}"
# Reemplaza todos los "/" con "_"
url_out=$(echo "$url_out" | sed 's/\//_/g' | sed 's/:/_/g')

wordlist_out=$(echo $wordlist | awk '{print $NF}' FS="/" | tr -d ".txt")

output_name="${url_out}_${wordlist_out}"


# Llamar a ffuf con las opciones proporcionadas
ffuf -u "$url" -w "$wordlist" -t "$threads" -x "$proxy" -of "$output_format" -o "$output_file" -fw "$filter_wordcount" -of json -o "$output_name".json
