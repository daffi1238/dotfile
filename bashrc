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

function extractPorts_own(){
	cat $1 | grep -oP "\d{1,5}/open" | tr -d "/open" | tr "\n" ","
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


myip() {
	curl ifconfig.me
}


wakeonlan() {
	MAC=18:c0:4d:98:00:9fç
	echo -e $(echo $(printf 'f%.0s' {1..12}; printf "$(echo $MAC | sed 's/://g')%.0s" {1..16}) | sed -e 's/../\\x&/g') | nc -w1 -u -b 255.255.255.255 4000
}

function makeBackUp() {
        date=$(date +"%Y-%m-%d-%h")
        zip -r /ruta/$date-File.zip /ruta/$date-File.zip
}

alias smbServer='sudo impacket-smbserver smbFolder $(pwd) -smb2support'


function globalv(){
	cp ~/.zshrc ~/zshrc_bck
	echo "sed -i 's/^$1=.*//g' ~/.zshrc" | bash
	echo $1=$2 >> ~/.zshrc
	source ~/.zshrc
}
