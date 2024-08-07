sudo apt-get update
sudo apt-get install xclip

##docker
sudo apt install -y docker.io
sudo systemctl enable docker --now
sudo usermod -aG docker $USER
printf '%s\n' "deb https://download.docker.com/linux/debian bullseye stable" | sudo tee /etc/apt/sources.list.d/docker-ce.list
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-ce-archive-keyring.gpg
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

sudo apt install docker-compose

mkdir /home/kali/.local/bin
cp .zshrc_hack ~/.zshrc_hack
cp .tmux.conf ~/.tmux.conf
cp .tmux.conf.local ~/.tmux.conf.local
cp .fuzz ~/.fuzz
cp ./tools/* /home/kali/.local/bin
