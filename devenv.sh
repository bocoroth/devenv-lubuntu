#!/bin/bash

# set up my dev environment on Lubuntu

cd ~
sudo apt -qq update && sudo apt -y upgrade
echo -e ""

# filezilla
echo -e "$(tput setaf 232)$(tput setab 11)$(tput bold)INSTALLING filezilla...................................................$(tput sgr0)\n"
if dpkg-query -W -f='${Status}' filezilla | grep "ok installed" &>/dev/null; then
    echo -e "filezilla is already installed.\n"
else
    sudo apt install -y filezilla
    echo -e ""
fi

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
    sudo apt -q update && sudo apt install -y mongodb-org
    echo -e ""
fi
sudo service mongod start

# express
echo -e "$(tput setaf 232)$(tput setab 11)$(tput bold)INSTALLING express..............................................................$(tput sgr0)\n"
if sudo npm -g list | grep "express@" &>/dev/null; then
    echo -e "express is already installed.\n"
else
    sudo npm install -g express
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

# LAMP Stack
echo -e "$(tput setaf 232)$(tput setab 11)$(tput bold)INSTALLING LAMP stack...........................................................$(tput sgr0)\n"
sudo add-apt-repository ppa:ondrej/php
sudo apt -q update
sudo apt install -y apache2 mariadb-server mariadb-client php7.1 php7.1-common php7.1-mysql php7.1-gd php7.1-cli
echo -e ""

# git
echo -e "$(tput setaf 232)$(tput setab 11)$(tput bold)INSTALLING git..................................................................$(tput sgr0)\n"
if dpkg-query -W -f='${Status}' git | grep "ok installed" &>/dev/null; then
    echo -e "git is already installed.\n"
else
    sudo apt install -y git-core
    echo -e ""
fi
git config --global user.name "bocoroth"
git config --global user.email "bocoroth@gmail.com"
echo -e "$(tput setaf 232)$(tput setab 11)$(tput bold)CHECKING git SETTINGS...........................................................$(tput sgr0)\n"
git config --list
echo -e ""

# hub
echo -e "$(tput setaf 232)$(tput setab 11)$(tput bold)INSTALLING hub..................................................................$(tput sgr0)\n"
if command -v hub &>/dev/null; then
    echo -e "hub is already installed.\n"
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
    mkdir ~/.atom
    touch ~/.atom/config.cson
    sudo bash -c "cat > ~/.atom/config.cson" <<EOT
"*":
  core:
    telemetryConsent: "no"
  editor:
    showIndentGuide: true
    softWrap: true
    softWrapHangingIndent: 2
    tabLength: 4
    tabType: "hard"
  welcome:
    showOnStartup: false
EOT
	apm install minimap
	echo -e ""
fi

# Lubuntu panels setup
echo -e "$(tput setaf 232)$(tput setab 11)$(tput bold)SETTING UP LUBUNTU PANELS.......................................................$(tput sgr0)\n"
if test -a ~/devenv-lubuntu/panels; then
    cp ~/devenv-lubuntu/panels ~/.config/lxpanel/Lubuntu/panels
    sudo lxpanelctl restart
    echo -e "Done!\n"
else
    echo -e "Panels config not found, continuing...\n"
fi

# ----------------------------------------------- #
# things after here require some user interaction #
# ----------------------------------------------- #

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
    echo -e ""
fi

# set up phpmyadmin
echo -e "$(tput setaf 232)$(tput setab 11)$(tput bold)SETTING UP MYSQL and PHPMYADMIN................................................$(tput sgr0)\n"
sudo mysql_secure_installation
sudo apt install -y phpmyadmin php7.1-mbstring php7.1-gettext php7.1-curl php7.1-xml
sudo chown -R $USER:$(id -gn $USER) /var/www/html
ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
sudo phpenmod mbstring
sudo systemctl restart apache2
echo -e ""

# set up drupal
echo -e "$(tput setaf 232)$(tput setab 11)$(tput bold)SETTING UP DRUPAL.............................................................$(tput sgr0)\n"
cd ~
# -- install composer
echo -e "Installing composer........................."
curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
sudo chown -R $USER .composer/
composer -V
echo -e ""

# -- apache virtual hosts
echo -e "Creating Apache Virtual Hosts..............."
sudo mkdir -p /var/www/html/drupal.localhost
sudo chown -R $USER:$USER /var/www/html/drupal.localhost
sudo chmod -R 755 /var/www/html
sudo echo -e '<html><head><title>Virtual Host Works!</title></head><body><h1>The drupal.localhost virtual host is working!</h1></body></html>' > /var/www/html/drupal.localhost/index.html
sudo bash -c "cat > /etc/apache2/sites-available/drupal.localhost.conf" <<EOT
<VirtualHost *:80>
    ServerAdmin bocoroth@gmail.com
    ServerName drupal.localhost
    ServerAlias www.drupal.localhost
    DocumentRoot /var/www/html/drupal.localhost
    ErrorLog /var/www/html/logs/drupal.localhost/error.log
    CustomLog /var/www/html/logs/drupal.localhost/access.log combined
	<Directory "/var/www/html/drupal.localhost/web">
		Options Indexes FollowSymLinks
		AllowOverride All
		Require all granted
	</Directory>
</VirtualHost>
EOT
sudo mkdir -p /var/www/html/logs/drupal.localhost
sudo a2ensite drupal.localhost.conf
sudo a2enmod rewrite
sudo systemctl restart apache2
echo -e "\n\nOutputting contents of http://drupal.localhost/ ......\n\n\n\n"
curl http://drupal.localhost/
echo -e "\n\n\n\n"

# -- apache permissions
echo -e "Setting Apache permissions.................."
sudo chgrp -R www-data /var/www/html
sudo find /var/www/html -type d -exec chmod g+rx {} +
sudo find /var/www/html -type f -exec chmod g+r {} +
sudo chown -R $USER /var/www/html/
sudo find /var/www/html -type d -exec chmod u+rwx {} +
sudo find /var/www/html -type f -exec chmod u+rw {} +
sudo find /var/www/html -type d -exec chmod g+s {} +
echo -e "Done.\n"

# -- install Drupal
echo -e "Installing Drupal..........................."
cd /var/tmp
composer create-project drupal-composer/drupal-project:7.x-dev drupal.localhost --stability dev --no-interaction
cp -a --link /var/tmp/drupal.localhost/* /var/www/html/drupal.localhost/ && rm -rf /var/tmp/drupal.localhost
sudo mysql -u root -e "USE mysql;CREATE USER 'drupal'@'localhost' IDENTIFIED BY 'drupal';GRANT ALL PRIVILEGES ON *.* TO 'drupal'@'localhost';FLUSH PRIVILEGES;"
sudo mysql -u drupal --password=drupal -e "CREATE DATABASE drupal_localhost"
cd /var/www/html/drupal.localhost/web
sudo ../vendor/bin/drush site-install --db-url=mysql://drupal:drupal@localhost/drupal_localhost
sudo systemctl restart apache2
read -p "Press enter to finish the Drupal install from the browser (ref user/pass above). Close browser to continue script when finished."
firefox http://drupal.localhost/web/
echo -e "\n\n"

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
echo -e "apache2.....................................$(apache2 -v | head -n 1 | awk '{print $3}' | cut -c 8-)"
echo -e "mariadb.....................................$(mysql --version | awk '{print $5}' | cut -c -7)"
echo -e "php.........................................$(php -v | head -n 1 | awk '{print $2}' | cut -c -6)"
echo -e "git.........................................$(git --version | awk '{print $3}')"
echo -e "hub.........................................$(hub --version | tail -n 1 | awk '{print $3}')"
echo -e "atom........................................$(atom -v | head -n 1 | awk '{print $3}')"
echo -e "composer....................................$(composer -V | awk '{print $3}')"
echo -e "drupal......................................$(cat /var/www/html/drupal.localhost/web/CHANGELOG.txt | head -n 1 | awk '{print $2}' | rev | cut -c 2- | rev)"
echo -e "\n"

# update/upgrade check - probably nothing to upgrade, but check anyway
sudo apt -qq update && sudo apt -qqy upgrade
sudo apt auto-remove
echo -e "\n"

# finished
read -p "Script finished. Press Enter to reboot or ctrl-c to cancel."
sudo reboot
