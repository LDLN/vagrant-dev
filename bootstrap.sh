#!/usr/bin/env bash

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list

apt-get update
#apt-get upgrade -y

sudo apt-get install -y gcc libc6-dev git mercurial bzr mongodb-org


echo 'use landline' >> /home/vagrant/ldlnDB.js
echo 'db.Schemas.insert({ "object_key" : "memo", "object_label" : "Memo", "weight" : 1, "schema" : [ { "key" : "title", "label" : "Title", "type" : "text", "weight" : 1, "required" : true, "default" : "Enter title" }, { "key" : "description", "label" : "Description", "type" : "longtext", "weight" : 1, "required" : false, "default" : "" }, { "key" : "when", "label" : "When", "type" : "datetime", "weight" : 1, "required" : false, "default" : "" }, { "key" : "opt", "label" : "Opt-In", "type" : "checkbox", "weight" : 1, "required" : false, "default" : "" }, { "key" : "Switch", "label" : "switch", "type" : "radio", "options" : [ { "key" : "on", "label" : "On", "selected" : true }, { "key" : "off", "label" : "Off" } ], "weight" : 1, "required" : false, "default" : "" }, { "key" : "profile", "label" : "Profile", "type" : "image", "weight" : 1, "required" : false, "default" : "" }, { "key" : "favorites", "label" : "Favorites", "type" : "options", "options" : [ { "key" : "blue", "label" : "Blue", "selected" : true }, { "key" : "red", "label" : "Red", "selected" : false } ], "weight" : 1, "required" : false, "default" : "" }, { "key" : "pin", "label" : "Pin", "type" : "map_location", "weight" : 1, "required" : false, "default" : "" }, { "key" : "blue_dot", "label" : "Blue Dot", "type" : "current_location", "weight" : 1, "required" : false, "default" : "" }, { "key" : "background", "label" : "Background", "type" : "color", "weight" : 1, "required" : false, "default" : "" } ] })' >> /home/vagrant/ldlnDB.js
echo 'db.Schemas.insert({ "object_key" : "missing_person", "object_label" : "Missing Person", "weight" : 1, "schema" : [ { "label" : "First Name", "type" : "text", "weight" : 1 }, { "label" : "Last Name", "type" : "text", "weight" : 2 } ] })' >> /home/vagrant/ldlnDB.js
echo 'db.Schemas.insert({ "object_key" : "inventory", "object_label" : "Inventory", "weight" : 1, "schema" : [ { "label" : "Name", "type" : "text", "weight" : 1 }, { "label" : "Quantity", "type" : "number", "weight" : 2 } ] })' >> /home/vagrant/ldlnDB.js
echo 'db.Schemas.insert({ "object_key" : "wiki_page", "object_label" : "Wiki Page", "weight" : 1, "schema" : [ { "label" : "Title", "type" : "text", "weight" : 1 }, { "label" : "Synopsis", "type" : "longtext", "weight" : 2 }, { "label" : "Body", "type" : "richtext", "weight" : 2 } ] })' >> /home/vagrant/ldlnDB.js
echo 'db.Schemas.insert({ "object_key" : "poi", "object_label" : "Point of Interest", "weight" : 1, "schema" : [ { "key" : "title", "label" : "Title", "type" : "text", "weight" : 1, "required" : true, "default" : "Enter title" }, { "key" : "note", "label" : "Note", "type" : "longtext", "weight" : 1, "required" : false, "default" : "" }, { "key" : "image", "label" : "Image", "type" : "image", "weight" : 1, "required" : false, "default" : "" }, { "key" : "map_location", "label" : "Map Location", "type" : "map_location", "weight" : 1, "required" : false, "default" : "" }, { "key" : "current_location", "label" : "Current Location", "type" : "current_location", "weight" : 1, "required" : false, "default" : "" }, { "key" : "pin_color", "label" : "Pin Color", "type" : "color", "weight" : 1, "required" : false, "default" : "" } ] })' >> /home/vagrant/ldlnDB.js

/usr/bin/mongo < /home/vagrant/ldlnDB.js


#if [ ! -d "/usr/local/go" ]; then
    VERSION=1.4.2
    OS=linux
    ARCH=amd64
    
    wget https://storage.googleapis.com/golang/go$VERSION.$OS-$ARCH.tar.gz
    tar -C /usr/local -xzf go$VERSION.$OS-$ARCH.tar.gz
    
    echo export PATH=\$PATH:/usr/local/go/bin >> .profile
    echo export GOPATH=\$HOME/go >> .profile
    echo export PATH=\$PATH:$GOPATH/bin >> .profile
#fi

mkdir /home/vagrant/go
export GOPATH=/home/vagrant/go
/usr/local/go/bin/go get github.com/revel/cmd/revel
/usr/local/go/bin/go get code.google.com/p/go.crypto/bcrypt
/usr/local/go/bin/go get github.com/nu7hatch/gouuid
/usr/local/go/bin/go get labix.org/v2/mgo
/usr/local/go/bin/go get code.google.com/p/go.net/websocket
/usr/local/go/bin/go get github.com/tarm/serial

# DEPLOY LDLN FOR PRODUCTION
#/usr/local/go/bin/go get github.com/ldln/landline-basestation

# DEPLOY LDLN FOR DEVELOPMENT
git clone https://github.com/LDLN/landline-basestation.git /home/vagrant/landline-basestation
mkdir -p $GOPATH/src/github.com/ldln/
ln -s /home/vagrant/landline-basestation/ $GOPATH/src/github.com/ldln/landline-basestation

mkdir $GOPATH/src/github.com/ldln/landline-basestation/app/tmp
chown -R vagrant $GOPATH/*
chown -R vagrant /home/vagrant/landline-basestation

#if [ ! -f "/etc/init.d/ldln_dev_startup.sh" ]; then

    echo "#!/bin/sh" >> /etc/init.d/ldln_dev_startup.sh
    echo "### BEGIN INIT INFO" >> /etc/init.d/ldln_dev_startup.sh
    echo "# Provides:          god" >> /etc/init.d/ldln_dev_startup.sh
    echo "# Required-Start:    \$remote_fs $syslog" >> /etc/init.d/ldln_dev_startup.sh
    echo "# Required-Stop:     \$remote_fs $syslog " >> /etc/init.d/ldln_dev_startup.sh
    echo "# Default-Start:     2 3 4 5" >> /etc/init.d/ldln_dev_startup.sh
    echo "# Default-Stop:      0 1 6" >> /etc/init.d/ldln_dev_startup.sh
    echo "# Short-Description: start god process monitoring" >> /etc/init.d/ldln_dev_startup.sh
    echo "# Description:       Start god process monitoring" >> /etc/init.d/ldln_dev_startup.sh
    echo "### END INIT INFO" >> /etc/init.d/ldln_dev_startup.sh
    
    echo "/bin/fuser -k 9000/tcp" >> /etc/init.d/ldln_dev_startup.sh
    echo "/bin/fuser -k 8080/tcp" >> /etc/init.d/ldln_dev_startup.sh
    echo "export GOPATH=/home/vagrant/go" >> /etc/init.d/ldln_dev_startup.sh
    echo "/home/vagrant/go/bin/revel run github.com/ldln/landline-basestation &" >> /etc/init.d/ldln_dev_startup.sh
    echo "/usr/local/go/bin/go run /home/vagrant/go/src/github.com/ldln/landline-basestation/ws/main.go &" >> /etc/init.d/ldln_dev_startup.sh
    echo "/usr/local/go/bin/go run /home/vagrant/go/src/github.com/ldln/landline-basestation/serial/main.go &" >> /etc/init.d/ldln_dev_startup.sh

    # start tilestream
    #/usr/bin/node /home/ubuntu/tilestream/index.js start --host 184.73.255.76 --tiles=/home/ubuntu/tilestream/tiles &
    
    chmod +x /etc/init.d/ldln_dev_startup.sh
    update-rc.d ldln_dev_startup.sh defaults
#fi

/etc/init.d/ldln_dev_startup.sh