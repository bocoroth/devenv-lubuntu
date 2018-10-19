#!/bin/bash

# set up my dev environment on Lubuntu

cd ~
sudo apt -qq update && sudo apt -y upgrade
echo -e ""

# curl, build-essential
echo -e "$(tput setaf 232)$(tput setab 11)$(tput bold)INSTALLING curl and build-essential.............................................$(tput sgr0)\n"
if command -v curl &>/dev/null; then
  echo -e "curl is already installed."
else
  sudo apt install -y curl
  echo -e ""
fi
if dpkg-query -W -f='${Status}' build-essential | grep "ok installed" &>/dev/null; then
  echo -e "build-essential is already installed.\n"
else
  sudo apt install -y build-essential
  echo -e ""
fi

# ruby
echo -e "$(tput setaf 232)$(tput setab 11)$(tput bold)INSTALLING ruby.................................................................$(tput sgr0)\n"
if dpkg-query -W -f='${Status}' ruby-full | grep "ok installed" &>/dev/null; then
  echo -e "ruby is already installed."
else
  sudo apt install -y ruby-full
  echo -e ""
fi
if command -v bundler &>/dev/null; then
  echo -e "bundler is already installed.\n"
else
  sudo gem install bundler
  echo -e ""
fi

# go
echo -e "$(tput setaf 232)$(tput setab 11)$(tput bold)INSTALLING golang...............................................................$(tput sgr0)\n"
if dpkg-query -W -f='${Status}' golang | grep "ok installed" &>/dev/null; then
  echo -e "go is already installed.\n"
else
  sudo apt install golang -y
  mkdir go
  mkdir -p go/src/hello && cd go/src/hello
  touch hello.go
  cat <<EOT >> hello.go
package main
import "fmt"
func main() {
    fmt.Printf("Hello, world! Go is GO!\n")
}
EOT
  go build
  ./hello
  cd ~
  echo -e ""
fi

# nodejs
echo -e "$(tput setaf 232)$(tput setab 11)$(tput bold)INSTALLING node-js..............................................................$(tput sgr0)\n"
if command -v node &>/dev/null; then
  echo -e "node is already installed."
  if command -v npm &>/dev/null; then
    echo -e "npm is already installed.\n"
  else
    echo -e "There is a problem with npm. Please reinstall node.\n"
  fi
else
  wget -qO- https://deb.nodesource.com/setup_8.x | sudo -E bash -
  sudo apt install -y nodejs
  sudo chown -R $USER:$(id -gn $USER) /home/matt/.config
  echo -e ""
fi

# mongo db
echo -e "$(tput setaf 232)$(tput setab 11)$(tput bold)INSTALLING mongodb-org..........................................................$(tput sgr0)\n"
if dpkg-query -W -f='${Status}' mongodb-org | grep "ok installed" &>/dev/null; then
  echo -e "mongodb-org is already installed.\n"
else
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
  echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
  sudo apt update && sudo apt install -y mongodb-org
  echo -e ""
fi
sudo service mongod start

# express
echo -e "$(tput setaf 232)$(tput setab 11)$(tput bold)INSTALLING express..............................................................$(tput sgr0)\n"
if sudo npm -g list | grep "express@" &>/dev/null; then
  echo -e "express is already installed.\n"
else
  sudo npm install -g @express
  echo -e ""
fi

# angular cli
echo -e "$(tput setaf 232)$(tput setab 11)$(tput bold)INSTALLING angular cli..........................................................$(tput sgr0)\n"
if sudo npm -g list | grep "angular/cli@" &>/dev/null; then
  echo -e "angular cli is already installed.\n"
else
  sudo npm install -g @angular/cli
  echo -e ""
fi

# git
echo -e "$(tput setaf 232)$(tput setab 11)$(tput bold)INSTALLING git..................................................................$(tput sgr0)\n"
if dpkg-query -W -f='${Status}' git | grep "ok installed" &>/dev/null; then
  echo -e "git is already installed.\n"
else
  sudo apt install -y git-core
  git config --global user.name "bocoroth"
  git config --global user.email "bocoroth@gmail.com"
  echo -e ""
fi
echo -e "$(tput setaf 232)$(tput setab 11)$(tput bold)CHECKING git SETTINGS...........................................................$(tput sgr0)\n"
git config --list
echo -e ""

# hub
echo -e "$(tput setaf 232)$(tput setab 11)$(tput bold)INSTALLING hub..................................................................$(tput sgr0)\n"
if command -v hub &>/dev/null; then
  echo -n "hub is already installed.\n"
else
  go get github.com/github/hub
  cd go/src/github.com/github/hub
  sudo make install prefix=/usr/local
  cat <<EOT >> ~/.profile
eval "$(hub alias -s)"
EOT
  cd ~
  echo -e ""
fi

# atom
echo -e "$(tput setaf 232)$(tput setab 11)$(tput bold)INSTALLING atom.................................................................$(tput sgr0)\n"
if command -v atom &>/dev/null; then
  echo -e "atom is already installed.\n"
else
  curl -sL https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
  sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
  sudo apt update && sudo apt install -y atom
  echo -e ""
fi

# update/upgrade check - probably nothing to upgrade, but check anyway
sudo apt -qq update && sudo apt -qqy upgrade
echo -e "\n"

# check installed
echo -e "$(tput setaf 232)$(tput setab 11)$(tput bold)INSTALL CHECKLIST..............................................................$(tput sgr0)\n"
echo -e "curl........................................$(curl -V | head -n 1 | awk '{print $2}')"
echo -e "perl........................................$(perl --version | head -n 2 | tail -n 1 | awk '{print $9}' | cut -c 3- | rev | cut -c 2- | rev)"
echo -e "make........................................$(make -v | head -n 1 | awk '{print $3}')"
echo -e "patch.......................................$(patch -v | head -n 1 | awk '{print $3}')"
echo -e "tar.........................................$(tar --version | head -n 1 | awk '{print $4}')"
echo -e "cpp.........................................$(cpp --version | head -n 1 | awk '{print $4}')"
echo -e "gcc.........................................$(gcc --version | head -n 1 | awk '{print $4}')"
echo -e "g++.........................................$(g++ --version | head -n 1 | awk '{print $4}')"
echo -e "ruby........................................$(ruby --version | awk '{print $2}')"
echo -e "  bundler...................................$(bundler --version | awk '{print $3}')"
echo -e "go..........................................$(go version | awk '{print $3}' | cut -c 3-)"
echo -e "node........................................$(node -v)"
echo -e "  npm.......................................$(npm -v)"
echo -e "  express...................................$(sudo npm -g list | grep "express@" | cut -c 19-)"
echo -e "  angular cli...............................$(sudo npm -g list | grep "angular/cli@" | cut -c 24-)"
echo -e "mongo.......................................$(mongo --version | head -n 1 | awk '{print $4}' | cut -c 2-)"
if grep -q "waiting for connections on port 27017" /var/log/mongodb/mongod.log; then
	echo -e "mongod......................................$(tput setaf 10)$(tput setab 28)$(tput bold)RUNNING$(tput sgr0)"
else
	echo -e "mongod......................................$(tput setaf 196)$(tput setab 52)$(tput bold)NOT RUNNING$(tput sgr0)"
fi
echo -e "git.........................................$(git --version | awk '{print $3}')"
echo -e "hub.........................................$(hub --version | tail -n 1 | awk '{print $3}')"
echo -e "atom........................................$(atom -v | head -n 1 | awk '{print $3}')"

# Lubuntu panels setup
echo -e "$(tput setaf 232)$(tput setab 11)$(tput bold)SETTING UP LUBUNTU PANELS.......................................................$(tput sgr0)\n"
if [ -e ./panels ] then
  cp ./panels ~/.config/lxpanel/Lubuntu/panels
  lxpanelctl restart
else
  echo -e "Panels config not found, continuing..."
fi

# github SSH setup
echo -e "$(tput setaf 232)$(tput setab 11)$(tput bold)SETTING UP GITHUB SSH..........................................................$(tput sgr0)\n"
if ls -al ~/.ssh | grep id_rsa.pub &>/dev/null; then
  echo -e "ssh key found, assuming already set up (if not, do it manually).\n"
else
  sudo apt install -y xclip
  ssh-keygen -t rsa -b 4096 -C "bocoroth@gmail.com"
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_rsa
  xclip -sel clip < ~/.ssh/id_rsa.pub
  read -p "Key copied to clipboard. Press enter to launch firefox (paste key into 'Key' box)."
  firefox https://github.com/settings/ssh/new
  read -p "Waiting... press enter once key is set up to test."
  ssh -T git@github.com
fi
