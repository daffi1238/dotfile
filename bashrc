mkt () {                                                                                                                                    130 ⨯
  mkdir {nmap,content,exploits,scripts,tmp}
}

function extractPorts(){
    ports="$(cat $1 | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"
    ip_address="$(cat $1 | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | sort -u | head -n 1)"
    echo -e "\n[*] Extracting information...\n" > extractPorts.tmp
    echo -e "\t[*] IP Address: $ip_address"  >> extractPorts.tmp
    echo -e "\t[*] Open ports: $ports\n"  >> extractPorts.tmp
    echo $ports | tr -d '\n' | xclip -sel clip
    echo -e "[*] Ports copied to clipboard\n"  >> extractPorts.tmp
    cat extractPorts.tmp; rm extractPorts.tmp
}
#Para eliminar ficheros de forma no recuperable
function rmk(){
    scrub -p dod $1
    shred -zun 10 -v $1
}



### Kali Linux --> ~/.zshrc
### To configure resolution and keyboard t¡for the kali ova image in virtualbox
auto() {
        echo "changing keyboard and display configuration"
        setxkbmap -layout 'es,es' && xrandr --size 1920x1200
}

