#!/usr/bin/env bash

#apt-get update
#apt-get upgrade -y

sudo apt-get install -y gcc libc6-dev git mercurial bzr

if [ ! -d "/usr/local/go" ]; then
    VERSION=1.4.2
    OS=linux
    ARCH=amd64
    
    wget https://storage.googleapis.com/golang/go$VERSION.$OS-$ARCH.tar.gz
    tar -C /usr/local -xzf go$VERSION.$OS-$ARCH.tar.gz
    
    echo export PATH=\$PATH:/usr/local/go/bin >> .profile
    echo export GOPATH=\$HOME/go >> .profile
    echo export PATH=\$PATH:$GOPATH/bin >> .profile
fi

mkdir /home/vagrant/go
export GOPATH=/home/vagrant/go
/usr/local/go/bin/go get github.com/revel/cmd/revel
/usr/local/go/bin/go get code.google.com/p/go.crypto/bcrypt
/usr/local/go/bin/go get github.com/nu7hatch/gouuid
/usr/local/go/bin/go get labix.org/v2/mgo
/usr/local/go/bin/go get github.com/ldln/landline-basestation
/usr/local/go/bin/go get code.google.com/p/go.net/websocket

if [ ! -f "/etc/init.d/ldln_dev_startup.sh" ]; then
    echo GOPATH=/home/vagrant/go >> /etc/init.d/ldln_dev_startup.sh
    echo /home/vagrant/go/bin/revel run github.com/ldln/landline-basestation >> /etc/init.d/ldln_dev_startup.sh
    echo /usr/local/go/bin/go run github.com/ldln/landline-basestation/ws/main.go >> /etc/init.d/ldln_dev_startup.sh

    # start tilestream
    #/usr/bin/node /home/ubuntu/tilestream/index.js start --host 184.73.255.76 --tiles=/home/ubuntu/tilestream/tiles &
    
    chmod +x /etc/init.d/ldln_dev_startup.sh
    update-rc.d ldln_dev_startup.sh defaults
fi