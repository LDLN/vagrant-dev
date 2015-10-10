#!/usr/bin/env bash

# GET MONGO SOURCES
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list

# GET NODE SOURCES
sudo apt-get install -y curl
/usr/bin/curl -sL https://deb.nodesource.com/setup | sudo bash -

# UPDATE UP
sudo apt-get update
#sudo apt-get upgrade -y
sudo apt-get install -y gcc libc6-dev git mercurial bzr mongodb-org

# POPULATE SAMPLE DATA
echo 'use landline' >> /home/vagrant/ldlnDB.js
echo 'db.Schemas.insert({ "object_key" : "memo", "object_label" : "Memo", "weight" : 1, "schema" : [ { "key" : "title", "label" : "Title", "type" : "text", "weight" : 1, "required" : true, "default" : "Enter title" }, { "key" : "description", "label" : "Description", "type" : "longtext", "weight" : 1, "required" : false, "default" : "" }, { "key" : "when", "label" : "When", "type" : "datetime", "weight" : 1, "required" : false, "default" : "" }, { "key" : "opt", "label" : "Opt-In", "type" : "checkbox", "weight" : 1, "required" : false, "default" : "" }, { "key" : "Switch", "label" : "switch", "type" : "radio", "options" : [ { "key" : "on", "label" : "On", "selected" : true }, { "key" : "off", "label" : "Off" } ], "weight" : 1, "required" : false, "default" : "" }, { "key" : "profile", "label" : "Profile", "type" : "image", "weight" : 1, "required" : false, "default" : "" }, { "key" : "favorites", "label" : "Favorites", "type" : "options", "options" : [ { "key" : "blue", "label" : "Blue", "selected" : true }, { "key" : "red", "label" : "Red", "selected" : false } ], "weight" : 1, "required" : false, "default" : "" }, { "key" : "pin", "label" : "Pin", "type" : "map_location", "weight" : 1, "required" : false, "default" : "" }, { "key" : "blue_dot", "label" : "Blue Dot", "type" : "current_location", "weight" : 1, "required" : false, "default" : "" }, { "key" : "background", "label" : "Background", "type" : "color", "weight" : 1, "required" : false, "default" : "" } ] })' >> /home/vagrant/ldlnDB.js
echo 'db.Schemas.insert({ "object_key" : "missing_person", "object_label" : "Missing Person", "weight" : 1, "schema" : [ { "label" : "First Name", "type" : "text", "weight" : 1 }, { "label" : "Last Name", "type" : "text", "weight" : 2 } ] })' >> /home/vagrant/ldlnDB.js
echo 'db.Schemas.insert({ "object_key" : "inventory", "object_label" : "Inventory", "weight" : 1, "schema" : [ { "label" : "Name", "type" : "text", "weight" : 1 }, { "label" : "Quantity", "type" : "number", "weight" : 2 } ] })' >> /home/vagrant/ldlnDB.js
echo 'db.Schemas.insert({ "object_key" : "wiki_page", "object_label" : "Wiki Page", "weight" : 1, "schema" : [ { "label" : "Title", "type" : "text", "weight" : 1 }, { "label" : "Synopsis", "type" : "longtext", "weight" : 2 }, { "label" : "Body", "type" : "richtext", "weight" : 2 } ] })' >> /home/vagrant/ldlnDB.js
echo 'db.Schemas.insert({ "object_key" : "poi", "object_label" : "Point of Interest", "weight" : 1, "schema" : [ { "key" : "title", "label" : "Title", "type" : "text", "weight" : 1, "required" : true, "default" : "Enter title" }, { "key" : "note", "label" : "Note", "type" : "longtext", "weight" : 1, "required" : false, "default" : "" }, { "key" : "image", "label" : "Image", "type" : "image", "weight" : 1, "required" : false, "default" : "" }, { "key" : "map_location", "label" : "Map Location", "type" : "map_location", "weight" : 1, "required" : false, "default" : "" }, { "key" : "current_location", "label" : "Current Location", "type" : "current_location", "weight" : 1, "required" : false, "default" : "" }, { "key" : "pin_color", "label" : "Pin Color", "type" : "color", "weight" : 1, "required" : false, "default" : "" } ] })' >> /home/vagrant/ldlnDB.js

# INSTALL GO
#if [ ! -d "/usr/local/go" ]; then
    VERSION=1.4.2
    OS=linux
    ARCH=amd64
    
    wget https://storage.googleapis.com/golang/go$VERSION.$OS-$ARCH.tar.gz
    tar -C /usr/local -xzf go$VERSION.$OS-$ARCH.tar.gz
    
    echo export PATH=\$PATH:/usr/local/go/bin >> .profile
    echo export GOPATH=\$HOME/go >> .profile
    echo export PATH=\$PATH:$GOPATH/bin >> .profile

    rm go$VERSION.$OS-$ARCH.tar.gz
#fi

# GET DEPENDENCIES
mkdir /home/vagrant/go
export GOPATH=/home/vagrant/go
/usr/local/go/bin/go get github.com/revel/cmd/revel
/usr/local/go/bin/go get code.google.com/p/go.crypto/bcrypt
/usr/local/go/bin/go get github.com/nu7hatch/gouuid
/usr/local/go/bin/go get labix.org/v2/mgo
/usr/local/go/bin/go get code.google.com/p/go.net/websocket
/usr/local/go/bin/go get github.com/tarm/serial
/usr/local/go/bin/go get github.com/gorilla/websocket

# LDLN SOURCE FOLDER SHOULD BE SYM LINKED TO DEV WORKSPACE
mkdir -p $GOPATH/src/github.com
ln -s /home/vagrant/ldln-workspace $GOPATH/src/github.com/ldln

# GET LDLN
/usr/local/go/bin/go get github.com/ldln/core
/usr/local/go/bin/go get github.com/ldln/web-app
/usr/local/go/bin/go get github.com/ldln/websocket-server
/usr/local/go/bin/go get github.com/ldln/websocket-client
/usr/local/go/bin/go get github.com/ldln/serial-server

# BUILD REVEL APPS
$GOPATH/bin/revel build github.com/ldln/web-app $GOPATH/bin/web-app

# MAKE VAGRANT THE OWNER
chown -R vagrant $GOPATH/*
chown -R vagrant /home/vagrant/ldln-workspace

# POPULATE SAMPLE DATA
/usr/bin/mongo < /home/vagrant/ldlnDB.js

# INSTALL TILESTREAM
sudo apt-get install -y nodejs
cd /home/vagrant
/usr/bin/npm install sqlite3
/usr/bin/git clone https://github.com/mapbox/tilestream.git /home/vagrant/tilestream
cd /home/vagrant/tilestream
/usr/bin/npm install
cd ..
mkdir /home/vagrant/ldln-workspace/mbtiles

# MAKE VAGRANT THE OWNER
chown -R vagrant /home/vagrant/node_modules
chown -R vagrant /home/vagrant/tilestream

# SETUP STARTUP FILE
# #if [ ! -f "/etc/init.d/ldln.sh" ]; then

     echo "#!/bin/sh" >> /etc/init.d/ldln.sh
     echo "### BEGIN INIT INFO" >> /etc/init.d/ldln.sh
     echo "# Provides:          god" >> /etc/init.d/ldln.sh
     echo "# Required-Start:    \$remote_fs $syslog" >> /etc/init.d/ldln.sh
     echo "# Required-Stop:     \$remote_fs $syslog " >> /etc/init.d/ldln.sh
     echo "# Default-Start:     2 3 4 5" >> /etc/init.d/ldln.sh
     echo "# Default-Stop:      0 1 6" >> /etc/init.d/ldln.sh
     echo "# Short-Description: start god process monitoring" >> /etc/init.d/ldln.sh
     echo "# Description:       Start god process monitoring" >> /etc/init.d/ldln.sh
     echo "### END INIT INFO" >> /etc/init.d/ldln.sh
   
     echo "/bin/fuser -k 9000/tcp" >> /etc/init.d/ldln.sh
     echo "/bin/fuser -k 8080/tcp" >> /etc/init.d/ldln.sh

     echo "export GOPATH=/home/vagrant/go" >> /etc/init.d/ldln.sh
     echo "/home/vagrant/go/bin/revel run github.com/ldln/web-app &" >> /etc/init.d/ldln.sh
     echo "/usr/local/go/bin/go run /home/vagrant/go/src/github.com/ldln/websocket-server/main.go &" >> /etc/init.d/ldln.sh
     echo "/usr/local/go/bin/go run /home/vagrant/go/src/github.com/ldln/websocket-client/main.go &" >> /etc/init.d/ldln.sh
     echo "/usr/local/go/bin/go run /home/vagrant/go/src/github.com/ldln/serial-server/main.go &" >> /etc/init.d/ldln.sh

     # start tilestream
     echo "/usr/bin/node /home/vagrant/tilestream/index.js start --tiles=/home/vagrant/ldln-workspace/mbtiles &" >> /etc/init.d/ldln.sh
   
     chmod +x /etc/init.d/ldln.sh
     update-rc.d ldln.sh defaults
# #fi

 /etc/init.d/ldln.sh
