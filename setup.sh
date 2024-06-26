#!/bin/bash

# This script prepares a linux desktop environment for this first time by
# installing and configuring a bunch of commonly used applications. Before
# running it, you should read it, understand it, and tweak it as necessary.
# It is liable to fall out-of-date, and has some idiosyncatic configuration
# options that you might not want (such as setting vim as your default editor
# for git). It was tested with Ubuntu MATE 18.10 on 2/23/2019. It should be
# relatively safe to run multiple times in a row, although some commands will
# fail if, for example, certain directories and programs already exist.
# Author: Nathan J Cochran

if (( $(id -u) == 0 )); then
	printf "Please do not run as root (script will prompt for root credentials when necessary)\n"
	exit 1
fi

printf "\n--------------------\n"
printf "Updating system packages"
printf "\n--------------------\n"
sudo apt-get update
sudo apt-get dist-upgrade			# Smarter than upgrade. Handles updating/removing dependencies

printf "\n--------------------\n"
printf "Installing vim"
printf "\n--------------------\n"
sudo add-apt-repository ppa:jonathonf/vim	# More up-to-date than the default provided by the software manager
sudo apt-get update
sudo apt-get install vim-gnome              # Gnome version is necessary for gvim/clipboard support

printf "\n--------------------\n"
printf "Installing git"
printf "\n--------------------\n"
sudo add-apt-repository ppa:git-core/ppa	# More up-to-date than the default provided by the software manager
sudo apt-get update
sudo apt-get install git-all

printf "\n--------------------\n"
printf "Installing make"
printf "\n--------------------\n"
sudo apt-get install make

printf "\n--------------------\n"
printf "Installing tmux"
printf "\n--------------------\n"
sudo apt-get install tmux

printf "\n--------------------\n"
printf "Installing go"
printf "\n--------------------\n"
wget -P ~/Downloads https://dl.google.com/go/go1.16.3.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf ~/Downloads/go1.16.3.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin     # Not permament unless set in $HOME/.profile, but necessary for :GoInstallBinaries to work (see below)

printf "\n--------------------\n"
printf "Installing golang.org/x/tools"
printf "\n--------------------\n"
go get -u golang.org/x/tools/...

printf "\n--------------------\n"
printf "Installing graphviz"
printf "\n--------------------\n"
sudo apt-get install graphviz   # For visualizing dependency graphs - see: https://github.com/golang/dep#visualizing-dependencies

printf "\n--------------------\n"
printf "Installing vim plugins"
printf "\n--------------------\n"
# Install and initialize vim plugins
git submodule init
git submodule update --remote
vim -u NONE -c "GoInstallBinaries" -c "qa"
vim -u NONE -c "helptags ~/.vim/pack/plugins/start/vim-fugitive/doc" -c "qa"
vim -u NONE -c "helptags ~/.vim/pack/plugins/start/vim-surround/doc" -c "qa"
vim -u NONE -c "helptags ~/.vim/pack/plugins/start/vim-dadbod/doc" -c "qa"

printf "\n--------------------\n"
printf "Installing gnome terminal"
printf "\n--------------------\n"
sudo apt-get install gnome-terminal         # You will want to update your default terminal

printf "\n--------------------\n"
printf "Installing gnome terminal solarized"
printf "\n--------------------\n"
sudo apt-get install dconf-cli              # Vim solarized colors only work if terminal is also solarized. See: https://github.com/altercation/vim-colors-solarized#important-note-for-terminal-users
cd ~
git clone https://github.com/Anthony25/gnome-terminal-colors-solarized.git
cd gnome-terminal-colors-solarized
./install.sh -s dark --install-dircolors    # This will walk the user through the process, and they can abort if they want to
mv ~/.dir_colors/dircolors ~/.dircolors     # See note at bottom: https://github.com/seebi/dircolors-solarized#general-instructions
rm -r ~/.dir_colors
cd ~

# vim +TmuxlineSnapshot\!\ .tmuxline.conf +qall     # Only necessary if not pulling down existing .tmuxline.conf

printf "\n--------------------\n"
printf "Installing network-manager-l2tp"
printf "\n--------------------\n"
sudo apt install network-manager-l2tp network-manager-l2tp-gnome resolvconf
sudo systemctl restart network-manager
sudo systemctl disable xl2tpd

#printf "\n--------------------\n"
#printf "Installing postgreSQL"
#printf "\n--------------------\n"
#wget -q -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - # See: https://www.postgresql.org/download/linux/ubuntu/
#line='deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main'
#file='/etc/apt/sources.list.d/pgdg.list'
#grep -q -F "$line" $file || sudo sh -c "echo \"$line\" >> $file" # Only add line if it doesn't already exist
#sudo apt-get update
#sudo apt-get install postgresql-10 		# May need to update version number
#sudo apt-get install postgresql-contrib-10

#echo -n "Please enter password for default postgres user: "
#read password
#sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '$password'"

# Create postgres user with same name as operating system user (makes
# local login via IDENT authentication possible - in pgAdminIII, you must
# leave host and password blank, and set username to your username).
# NOTE: Decided to set password for default postgres user instead,
# because clients connecting over TCP/IP need to use password
# authentication anyways (IDENT only works locally):
#user=$USER
#sudo -u postgres createuser -s $user    

#printf "\n--------------------\n"
#printf "Installing pgAdmin"
#printf "\n--------------------\n"
#sudo apt-get install pgadmin3			# People seem to prefer pgadmin3 over pgadmin4

#printf "\n--------------------\n"
#printf "Installing mssql-tools"
#printf "\n--------------------\n"
#wget -q -O - https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
#line=$(wget -q -O - https://packages.microsoft.com/config/ubuntu/16.04/prod.list)
#file='/etc/apt/sources.list.d/msprod.list'
#grep -q -F "$line" $file || sudo sh -c "echo \"$line\" >> $file" # Only add line if it doesn't already exist
#sudo apt-get update 
#sudo apt-get install mssql-tools unixodbc-dev

printf "\n--------------------\n"
printf "Installing dbeaver"
printf "\n--------------------\n"
wget -P ~/Downloads https://dbeaver.jkiss.org/files/dbeaver-ce_latest_amd64.deb # May need to update at some point (visit dbeaver download page to find link)
sudo apt-get install ~/Downloads/dbeaver-ce_latest_amd64.deb

# See: https://www.ubuntuupdates.org/ppa/postgresql
printf "\n--------------------\n"
printf "Installing pgformatter"
printf "\n--------------------\n"
sudo apt install curl ca-certificates gnupg
curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/apt.postgresql.org.gpg >/dev/null
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ focal-pgdg main" >> /etc/apt/sources.list.d/postgresql.list'
sudo apt-get update 
sudo apt-get install pgformatter

printf "\n--------------------\n"
printf "Installing docker"
printf "\n--------------------\n"
# See: https://docs.docker.com/install/linux/docker-ce/ubuntu/#set-up-the-repository
# And: https://docs.docker.com/install/linux/linux-postinstall/
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
wget -q -O - https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker

printf "\n--------------------\n"
printf "Installing docker-compose"
printf "\n--------------------\n"
# See: https://docs.docker.com/compose/install/#install-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose # May need to update version number
sudo chmod +x /usr/local/bin/docker-compose

# printf "\n--------------------\n"
# printf "Installing kafka"
# printf "\n--------------------\n"
# wget -P ~/Downloads http://us.mirrors.quenda.co/apache/kafka/1.1.1/kafka_2.11-1.1.1.tgz
# tar -xvzf ~/Downloads/kafka_2.11-1.0.0.tgz -C ~/
# mv ~/kafka_2.11-1.0.0 ~/kafka

# NOTE: Should already be installed
#printf "\n--------------------\n"
#printf "Installing firefox"
#printf "\n--------------------\n"
#sudo add-apt-repository ppa:mozillateam/firefox-next
#sudo apt-get update
#sudo apt install firefox

printf "\n--------------------\n"
printf "Installing chrome"    
printf "\n--------------------\n"
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - # See: https://askubuntu.com/a/510186
line='deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main'
file='/etc/apt/sources.list.d/google-chrome.list'
grep -q -F "$line" $file || sudo sh -c "echo \"$line\" >> $file" # Only add line if it doesn't already exist
sudo apt-get update 
sudo apt-get install google-chrome-stable

printf "\n--------------------\n"
printf "Installing postman"
printf "\n--------------------\n"
wget -O ~/Downloads/postman.tar.gz https://dl.pstmn.io/download/latest/linux64 # See: https://blog.bluematador.com/posts/postman-how-to-install-on-ubuntu-1604/
sudo tar -xzf ~/Downloads/postman.tar.gz -C /opt
sudo ln -s /opt/Postman/Postman /usr/bin/postman

printf "\n--------------------\n"
printf "Installing slack"
printf "\n--------------------\n"
wget -P ~/Downloads https://downloads.slack-edge.com/linux_releases/slack-desktop-4.19.2-amd64.deb # May need to update version number (visit slack download page to find it)
sudo apt-get install ~/Downloads/slack-desktop-4.19.2-amd64.deb

printf "\n--------------------\n"
printf "Installing spotify"
printf "\n--------------------\n"
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
line='deb http://repository.spotify.com stable non-free'
file='/etc/apt/sources.list.d/spotify.list'
grep -q -F "$line" $file || sudo sh -c "echo \"$line\" >> $file" # Only add line if it doesn't already exist
sudo apt-get update
sudo apt-get install spotify-client

printf "\n--------------------\n"
printf "Installing shutter"
printf "\n--------------------\n"
#sudo add-apt-repository ppa:shutter/ppa
#sudo apt-get update
#sudo apt-get install shutter libgoo-canvas-perl gnome-web-photo # Enables editing screenshots and capturing web pages

sudo add-apt-repository ppa:linuxuprising/shutter
sudo apt-get install shutter

printf "\n--------------------\n"
printf "Installing peek"
printf "\n--------------------\n"
sudo apt-get install peek
# sudo add-apt-repository ppa:peek-developers/stable
# sudo apt-get update
# sudo apt-get install peek

printf "\n--------------------\n"
printf "Installing inotify-tools"
printf "\n--------------------\n"
sudo apt-get install inotify-tools

# printf "\n--------------------\n"
# printf "Installing hub"
# printf "\n--------------------\n"
# go get -u github.com/github/hub

#printf "\n--------------------\n"
#printf "Installing rvm and ruby 2.3.4"
#printf "\n--------------------\n"
#sudo gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
#sudo curl -sSL https://get.rvm.io | sudo bash -s stable --ruby=2.3.4

#printf "\n--------------------\n"
#printf "Installing pip and virtualenv"
#printf "\n--------------------\n"
#sudo apt-get install python-pip python-dev build-essential 
#sudo pip install --upgrade pip 
#sudo pip install --upgrade virtualenv 

#printf "\n--------------------\n"
#printf "Installing grip"
#printf "\n--------------------\n"
#sudo pip install setuptools
#sudo pip install grip

#printf "\n--------------------\n"
#printf "Installing google-cloud-sdk"
#printf "\n--------------------\n"
#wget -P ~/Downloads https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-180.0.0-linux-x86_64.tar.gz
#tar -xvzf ~/Downloads/google-cloud-sdk-180.0.0-linux-x86_64.tar.gz -C ~/
#~/google-cloud-sdk/install.sh
#~/google-cloud-sdk/bin/gcloud init
#~/google-cloud-sdk/bin/gcloud components install app-engine-go
#~/google-cloud-sdk/bin/gcloud components update

#printf "\n--------------------\n"
#printf "Installing VirtualBox"
#printf "\n--------------------\n"
#wget -P ~/Downloads https://download.virtualbox.org/virtualbox/5.2.20/virtualbox-5.2_5.2.20-125813~Ubuntu~xenial_amd64.deb # May need to update at some point (visit VirtualBox download page to find link)
#sudo apt-get install ~/Downloads/virtualbox-5.2_5.2.20-125813~Ubuntu~xenial_amd64.deb

#printf "\n--------------------\n"
#printf "Installing VirtualBox Extension Pack"
#printf "\n--------------------\n"
#wget -P ~/Downloads https://download.virtualbox.org/virtualbox/5.2.14/Oracle_VM_VirtualBox_Extension_Pack-5.2.14.vbox-extpack
#virtualbox ~/Downloads/Oracle_VM_VirtualBox_Extension_Pack-5.2.14.vbox-extpack

#printf "\n--------------------\n"
#printf "Installing Vagrant"
#printf "\n--------------------\n"
#wget -P ~/Downloads https://releases.hashicorp.com/vagrant/2.1.2/vagrant_2.1.2_x86_64.deb
#sudo apt-get install ~/Downloads/vagrant_2.1.2_x86_64.deb

printf "\n--------------------\n"
printf "Installing github.com/nicheinc/development"
printf "\n--------------------\n"
git clone --recurse-submodules https://github.com/nicheinc/development ~/src/github.com/nicheinc/development/

# Create symbolic links in home directory to niche and development directories
#ln -s ~/src/github.com/nicheinc
#ln -s ~/src/github.com/nicheinc/development

#printf "\n--------------------\n"
#printf "Installing nvm"
#printf "\n--------------------\n"
#wget -q -O - https://raw.githubusercontent.com/creationix/nvm/v0.33.4/install.sh | bash # May need to update version number
#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#printf "\n--------------------\n"
#printf "Installing node.js"
#printf "\n--------------------\n"
#nvm install 6.11.2

#printf "\n--------------------\n"
#printf "Installing nodemon"
#printf "\n--------------------\n"
#npm install -g nodemon

#printf "\n--------------------\n"
#printf "Installing doctoc"
#printf "\n--------------------\n"
#npm install -g doctoc

printf "\n--------------------\n"
printf "Installing xclip"
printf "\n--------------------\n"
sudo apt-get install xclip

#if [ ! -f ~/.ssh/id_rsa ]; then
#	# See: https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/
#    # NOTE: If you have multiple github accounts, and you want to use ssh for both of them,
#    # you will have to run the following commnds twice, creating two different ssh keys. See
#    # my .gitconfig and .ssh/config to see how to correctly configure the rest from there.
#	printf "Generating ssh key required for github.com/nicheinc dependencies\n"
#	ssh-keygen -t rsa -b 4096 -C "$email" -f ~/.ssh/id_rsa -N ''
#	eval "$(ssh-agent -s)"
#	ssh-add ~/.ssh/id_rsa
#	sudo apt-get install xclip
#	xclip -sel clip < ~/.ssh/id_rsa.pub
#    firefox https://github.com/settings/keys
#	printf "\n--------------------\n"
#	printf "NOTE: Please log in to github.com, click 'New SSH Key', and paste into the 'Key' textbox (the ssh key has already been copied to your clipboard)\n"
#	printf "NOTE: You may give the key any descriptive name you want (e.g. niche-linux)\n"
#	printf "NOTE: Once finished, press [Enter] to continue"
#	read -s
#fi

# Use ssh instead of https by default
#git config --global url.ssh://git@github.com/.insteadOf https://github.com/
#git config --global url.ssh://git@gitlab.com/.insteadOf https://gitlab.com/

# This can sometimes have unintended side-effects
#printf "\n--------------------\n"
#printf "Cleaning up unused dependencies"
#printf "\n--------------------\n"
# sudo apt-get autoremove

#printf "\n--------------------\n"
#printf "Creating $HOME/bin directory"
#printf "\n--------------------\n"
#mkdir ~/bin
