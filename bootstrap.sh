#!/usr/bin/env bash

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list

apt-get update
#apt-get upgrade -y

sudo apt-get install -y gcc libc6-dev git mercurial bzr mongodb-org

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
    echo "fuser -k 9000/tcp" >> /etc/init.d/ldln_dev_startup.sh
    echo "fuser -k 8080/tcp" >> /etc/init.d/ldln_dev_startup.sh
    echo "GOPATH=/home/vagrant/go" >> /etc/init.d/ldln_dev_startup.sh
    echo "/home/vagrant/go/bin/revel run github.com/ldln/landline-basestation &" >> /etc/init.d/ldln_dev_startup.sh
    echo "/usr/local/go/bin/go run /home/vagrant/go/src/github.com/ldln/landline-basestation/ws/main.go &" >> /etc/init.d/ldln_dev_startup.sh

    # start tilestream
    #/usr/bin/node /home/ubuntu/tilestream/index.js start --host 184.73.255.76 --tiles=/home/ubuntu/tilestream/tiles &
    
    chmod +x /etc/init.d/ldln_dev_startup.sh
    update-rc.d ldln_dev_startup.sh defaults
#fi