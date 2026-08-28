#!/bin/bash

#set -e

if [[ $1 == "--scratch" || $1 == "-s" ]];
then
	echo "doing all installations from scratch for the new vm..."
	sudo apt-get -y update

	gsettings set org.gnome.desktop.interface text-scaling-factor 0.85
	sudo apt-get -y install zsh curl vim git make

	curl -fsSL https://go.microsoft.com/fwlink/?LinkID=760868 -o vs.deb
	sudo apt-get -y install ./vs.deb
	rm -rf vs.deb 

	ssh-keygen

	read -p 'email associated with github: ' email
	git config --global user.email $email
	git config --global user.user moist-bread
	
	echo ""
	echo "mostly done only switching to zsh missing"
	chsh -s $(which zsh)
	
	echo "things to do manually:"
	echo "	- reboot"
	echo "	- add ssh key on github"
	echo "	- add custom zshrc"
	echo "	- install extentions and dash to dock"

else
	echo "(debian) doing requirement installations for this inception repo..."

	sudo apt-get -y update
	sudo apt-get -y install curl make

	sudo apt-get -y remove $(dpkg --get-selections docker.io docker-compose docker-doc docker-buildx podman-docker containerd runc | cut -f1)

	curl -fsSL https://get.docker.com -o get-docker.sh
	sudo sh get-docker.sh
	rm -rf get-docker.sh

	echo ""
	echo "docker has been installed"
	echo "things to do manually:"
	echo "	- reboot"

	sudo usermod -aG docker $USER
	newgrp docker
fi	
