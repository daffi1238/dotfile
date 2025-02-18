#!/bin/bash

# Mostrar ayuda si no se proporcionan argumentos
if [ "$#" -eq 0 ]; then
    echo "Uso: $0 -u <url> -w <wordlist> -t <threads> -x <proxy> -of <output_format> -o <output_file> -fw <filter_wordcount>"
    echo
    echo "[*]Wordlists recomendadas:"
    echo "/usr/share/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt"
    echo "/usr/share/seclists/Discovery/Web-Content/common.txt"

    exit 1
fi

# Leer argumentos
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -u) url="$2"; shift 2 ;;
        -w) wordlist="$2"; shift 2 ;;
        -t) threads="$2"; shift 2 ;;
        -x) proxy="$2"; shift 2 ;;
        *) echo "Argumento desconocido: $1"; exit 1 ;;
    esac
done

if [[ -z "$url" ]] || [[ -z "$wordlist" ]] || [[ -z "$threads" ]]; then
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
out=$(echo "ffuf -u \"$url\" -w \"$wordlist\" -t \"$threads\" -x \"$proxy\" -fw \"$filter_wordcount\" -of json -o \"$output_name\".json | tee $output_name.ffuf")
echo $out > .my_fuzz.out
cat .my_fuzz.out
cat .my_fuzz.out | xclip -sel c
