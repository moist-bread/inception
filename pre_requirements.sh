#!/bin/bash

if [[ $1 == "--scratch" || $1 == "-s" ]];
then
	echo "doing all installations from scratch for the new vm..."
	sudo apt-get -y update

	gsettings set org.gnome.desktop.interface text-scaling-factor 0.85
	sudo apt-get -y install zsh curl vim git

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
	echo "doing requirement installations for this inception repo..."

	sudo apt-get -y remove $(dpkg --get-selections docker.io docker-compose docker-doc docker-buildx podman-docker containerd runc | cut -f1)

	# Add Docker's official GPG key:
	sudo apt-get -y update
	sudo apt-get -y install ca-certificates curl
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc

	# Add the repository to Apt sources:
	sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
	Types: deb
	URIs: https://download.docker.com/linux/debian
	Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
	Components: stable
	Architectures: $(dpkg --print-architecture)
	Signed-By: /etc/apt/keyrings/docker.asc
	EOF

	sudo apt-get -y update

	sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

	sudo usermod -aG docker $USER
	newgrp docker
	echo ""
	echo "docker has been installed"
	
	echo "things to do manually:"
	echo "	- reboot"

fi	
