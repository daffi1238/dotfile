#!/bin/zsh

# Inicializamos las variables
ip=""
port=""
file=""
service=""
script=""
help_menu=0
endpoint=0
nmapScan=0
all=0
onGoing=0
addDone=""
doneFile=".parshell_done"

# Función para mostrar el menú de ayuda
show_help() {
    echo "Uso: $0 [OPCIONES]"
    echo "Script para hacer algo útil."
    echo ""
    echo "Opciones:"
    echo "  --ip       Dirección IP"
    echo "  --port     Puerto"
    echo "  --file     Nombre del archivo"
    echo "  --service  Nombre del servicio"
    echo "  --endpoint Muestra la información en formato ip:puerto"
    echo "  --nmapScan Depende de --endpoint; Muestra los comandos de nmap que habrán de lanzarse para los distintos puertos e IP's"
    echo "  --script   Depende de nmapScan; Genera los comandos de nmap con el script solicitado"
    echo "  --printAll Devuelve la relación IP-Puertos sin entrar en detalles, con esto podemos facilmente obtener todos los puertos únicos, así como todos los servicios únicos"
    echo "             [!] Para combinarlo con los parámetros ip, port o service necesitas añadir un valor para que no lo tome por vacío / parshell --printAll --ip 0" 
    echo "             [!] Actualmente este parámetro sólo aplica a los puertos TCP!! Con UDP no se ha desarrollado apropiadamente el software así que cuidadito"    
    echo "  --onGoing  Te muestra la información de los servicios o puertos que aún no se han escaneado!"
    echo "  --addDone  Añade al fichero .done "
    echo "  -h         Muestra este menú de ayuda"

}

# Comprobar si no se han proporcionado argumentos
if [[ $# -eq 0 ]]; then
    show_help
    exit 0
fi

# Iteramos sobre todos los argumentos
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        --ip)
        ip="$2"
        shift # Pasamos al siguiente argumento
        shift # Pasamos al siguiente argumento
        ;;
        --port)
        port="$2"
        shift # Pasamos al siguiente argumento
        shift # Pasamos al siguiente argumento
        ;;
        --file)
        file="$2"
        shift # Pasamos al siguiente argumento
        shift # Pasamos al siguiente argumento
        ;;
        --service)
        service="$2"
        shift # Pasamos al siguiente argumento
        shift # Pasamos al siguiente argumento
        ;;
        --script)
        script="$2"
        shift # Pasamos al siguiente argumento
        shift # Pasamos al siguiente argumento
        ;;
        -h)
        help_menu=1
        shift # Pasamos al siguiente argumento
        ;;
        --endpoint)
        endpoint=1
        shift # Pasamos al siguiente argumento
        ;;
        --nmapScan)
        nmapScan=1
        shift # Pasamos al siguiente argumento
        ;;
        --printAll)
        printAll=1
        shift # Pasamos al siguiente argumento
        ;;
        --onGoing)
        onGoing=1
        shift # Pasamos al siguiente argumento
        ;;
        --addDone)
        addDone="$2"
        shift # Pasamos al siguiente argumento
        shift # Pasamos al siguiente argumento
        ;;
        --orderByPorts)
        orderByPorts="1"
        shift # Pasamos al siguiente argumento
        shift # Pasamos al siguiente argumento
        ;;
        *)    # Cualquier argumento no reconocido
        echo "Argumento no reconocido: $1"
        exit 1
        ;;
    esac
done

# Si se activó el menú de ayuda, lo mostramos
if [[ $help_menu -eq 1 ]]; then
    show_help
    exit 0
fi

# ¿Que hace esto?
if [[ -n $addDone ]]; then
    echo $addDone >> $doneFile
    cat $doneFile
    exit 0
fi


#######################################Expresión para obtener los endpoints!#################################################
awk_endpoint="awk 'BEGIN { ip=\"\"; port=\"\" } /Nmap scan/ { if(ip!=\"\") { print ip \":\" port; ip=\"\"; port=\"\" } ip=\$NF } /[0-9]+\\/tcp/ { port=\$1; sub(/\\/tcp/, \"\", port); print ip \":\" port } END { if(ip!=\"\") { print ip \":\" port } }' | sort -u"
#############################################################################################################################



# Ahora puedes usar las variables $ip, $port y $file como quieras
echo "IP: $ip"
echo "Port: $port"
echo "File: $file"
echo "Service: $service"
echo
echo

# Recuerda que solo aplica sobre los ficheros con terminación .nmap!
if [[ -z "$file" ]]; then
    # file="*"
    file=$(find \-name "*.nmap" | xargs)
fi


if [[ $printAll -eq 1 ]]; then
    echo "Dentro del printAll!"
    if [[ -z "$ip" && -z "$port" && -z "$service" ]]; then
        if [[ $onGoing -eq 1 ]]; then
            done=$(cat $doneFile | xargs | tr " " "|")
            eval "cat $file | grep -Ev \"$(echo $done)\" | grep -v \"|\""
        else
            eval "cat $file"
        fi
    elif [[ -z "$ip" && -z "$port" && -n "$service" ]]; then
        eval "cat $file" | grep -E "/tcp|/udp" | awk '{for (i=4; i<=NF; ++i) printf "%s ", $i; print ""}' | sort -u
    elif [[ -n "$ip" && -z "$port" && -z "$service" ]]; then
        eval "cat $file" | grep -P '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | sort -u
    elif [[ -z "$ip" && -n "$port" && -z "$service" ]]; then
        eval "cat $file" | grep -E "/tcp|/udp"
    else
        echo "Opción no válida con --printAll"
    fi
    exit 0
fi





# Obtenemos la relación 


# Después de tu bucle while y la asignación de valores por defecto

# Asumimos que 'file' nunca estará vacío, como has indicado

if [[ -n "$ip" && -z "$port" && -z "$service" ]]; then
    echo "Buscar toda la información relativa a la IP $ip."
    echo
    # Buscar toda la información relativa a una IP
    if [[ $endpoint -eq 1 ]]; then
        eval "cat $file" | awk -v ip="$ip" '/^$/ { flag=0 } { if(flag) print } $0 ~ ip { print; flag=1 }' | grep -P ":\d{1,5}" | eval "$awk_endpoint"
    else
        eval "cat $file" | awk -v ip="$ip" '/^$/ { flag=0 } { if(flag) print } $0 ~ ip { print; flag=1 }'
    fi


elif [[ -n "$ip" && -n "$port" && -z "$service" ]]; then
    echo "Buscar la información al par IP-puerto"
    echo
    eval "cat $file" | awk -v ip="$ip" '/^$/ { flag=0 } { if(flag) print } $0 ~ ip { print; flag=1 }' | awk -v port="$port" 'BEGIN {flag=0} $1 ~ port "/tcp|udp" {flag=1} flag && /^[0-9]+\/tcp/ && $1 !~ port "/tcp" {flag=0} flag' | tee .parshell
    

elif [[ -z "$ip" && -n "$port" && -z "$service" ]]; then
    echo "Devolviendo toda la información relativa al puerto $port"
    echo
    if [[ $endpoint -eq 1 ]]; then
        eval "cat $file" | awk -v port="$port" 'BEGIN {flag=0; last_nmap=""} /Nmap scan/ {last_nmap=$0} $1 ~ port "/tcp|/udp" {flag=1; if (last_nmap != "") {print "\n" last_nmap; last_nmap=""}} flag && /^[0-9]+\/tcp/ && $1 !~ port "/tcp" {flag=0} flag' | eval "$awk_endpoint" | grep -P ":\d{1,5}" | tee .parshell
    else
        eval "cat $file" | awk -v port="$port" 'BEGIN {flag=0; last_nmap=""} /Nmap scan/ {last_nmap=$0} $1 ~ port "/tcp|/udp" {flag=1; if (last_nmap != "") {print "\n" last_nmap; last_nmap=""}} flag && /^[0-9]+\/(tcp|udp)/ && $1 !~ port "/(tcp|udp)" {flag=0} flag' | tee .parshell
    fi

elif [[ -z "$ip" && -z "$port" && -n "$service" ]]; then
    echo "Buscando el servicio $service."
    echo
    # Si se activó el menú de ayuda, lo mostramos
    if [[ $endpoint -eq 1 ]]; then
        echo "[*] DEBUG: Filtrando por servicio (endpoint)"
        eval "cat $file" | awk -v pattern="$service" 'BEGIN {last_nmap=""; final_nmap=""} /Nmap scan/ {last_nmap=$0; final_nmap=$0} $0 ~ pattern {if (last_nmap != "") {print last_nmap; last_nmap=""} print $0} END {if (final_nmap != "") {print "\nÚltimo Nmap scan: " final_nmap}}' | eval "$awk_endpoint" | grep -P ":\d{1,5}" | tee .parshell
    else
        echo "[*] DEBUG2"
        eval "cat $file" | awk -v pattern="$service" 'BEGIN {last_nmap=""; final_nmap=""} /Nmap scan/ {last_nmap=$0; final_nmap=$0} $0 ~ pattern {if (last_nmap != "") {print last_nmap; last_nmap=""} print $0} END {if (final_nmap != "") {print "\nÚltimo Nmap scan: " final_nmap}}' | tee .parshell
    fi

# endpoints sin definir parámetros, es decir de todos los pares IP:puerto
elif [[ -z "$ip" && -z "$port" && -z "$service" && $endpoint -eq 1 ]]; then
    echo "Devolviendo todos lo endpoints."
    eval "cat $file" | awk -v pattern="/tcp|/udp" 'BEGIN {last_nmap=""; final_nmap=""} /Nmap scan/ {last_nmap=$0; final_nmap=$0} $0 ~ pattern {if (last_nmap != "") {print last_nmap; last_nmap=""} print $0} END {if (final_nmap != "") {print "\nÚltimo Nmap scan: " final_nmap}}' | eval "$awk_endpoint" | tee .parshell
    
else
    echo "Otro caso no especificado."
    # Código para manejar otros casos
fi


## En caso de tener la flag nmapScan así como endpoint sacamos los distintos escaneos de nmap que hay que lanzar
if [[ $endpoint -eq 1 && $nmapScan -eq 1 ]]; then
    folder=$(pwd)
    ip_ports=$(eval "cat $folder/.parshell")
    declare -a ports
    ports_data=$(echo $ip_ports | grep -oP ":\d{1,5}" | tr -d ":" | sort -u)
    echo
    echo ports_data
    echo $ports_data
    
    # Guardamos los distintos puertos que tenemos identificados
    while IFS= read -r line; do
        echo "Dentro del while!"
        ports+=("$line")
    done <<< "$ports_data"

    # Obtenemos todas las IP's que tienen dicho puerto abierto
    counter=0
    for port in "${ports[@]}";do
        ips=$(echo $ip_ports | grep -P "$port" | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | xargs)
        #ips=$(grep -P "111" | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | xargs)
        echo "nmap -sT -p$port -Pn --script='$script' $ips -oN $port-s$service-$script-nmapScan_$counter.nmap"
        counter=$((counter + 1))
    done

    echo "Elementos del array: ${mi_array[@]}"
    
fi



# Función para ordenar los equipos de más puertos a menos puertos abiertos (Mostrar número, y puertos en cada caso)
if [[ $orderByPorts -eq 1 ]]; then
    parshell --endpoint > .endpoint
    cat .endpoint | gripo | sort -u > .ips

    while IFS= read -r line; do
        echo $line > /tmp/parshell.tmp
        cat .endpoint | grep $line | awk '{print "\t" $2}' FS=":" | sed 's/^$//g' >> /tmp/parshell.tmp
        cat /tmp/parshell.tmp | sed '/^[[:space:]]*$/d' >> ips_and_ports.txt
        echo
    done < .ips 

    file="ips_and_ports.txt"
    awk '
        {
            if ($1 ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/) {
            ip = $1
            count[ip] = 0
            ips[ip] = ip
            } else if ($1 ~ /^[0-9]+$/) {
            count[ip]++
            }
        }
        END {
            for (ip in ips) {
            print count[ip], ips[ip]
            }
        }
        ' "$file" | sort -nr | while read -r count ip; do
        echo "$ip - $count puertos abiertos"
        awk -v ip="$ip" '
            $1 == ip {show = 1; next}
            show && $1 !~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/ && $1 ~ /^[0-9]+$/ {print "\t" $1}
            show && $1 ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/ {show = 0}
        ' "$file"
        done
    rm .endpoint
    rm /tmp/parshell.tmp
    rm ips_and_ports.txt
fi



