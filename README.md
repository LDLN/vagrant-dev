# vagrant-dev

Vagrant config and bootstrap files for setting up a virtual LDLN development environment.

## Get started

Note that in the steps below [Local] indicates commands to be run on the development machine, while [VM] indicates it is to be run within the vagrant box.

### Prerequisites (all [Local])

1. [Download vagrant](https://www.vagrantup.com/downloads)
2. Download a VM provider, e.g. [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
3. Clone this `vagrant-dev` repository

### Start the vagrant box (all [Local])
4. `cd vagrant-dev`
5. `vagrant up`

### Start the LDLN services (if needed for troubleshooting)
6. [Local] `vagrant ssh` (or `ssh vagrant@localhost -p 2222` with the [default password](https://www.vagrantup.com/docs/boxes/base#vagrant-user) of `vagrant`)
7. [VM] export PATH=$PATH:/usr/local/go/bin >> ~/.bashrc
8. [VM] source ~/.bashrc
9. [VM] /etc/init.d/ldln_dev_startup.sh

### 

## What Does It Do?

_TODO_

## Serial Ports

Good resource on developing on serial ports with Vagrant:
http://yagamy.logdown.com/posts/138888-serialport-programming-on-platform-virtual-machines

<hr />

Stuck on something? Check [the wiki](https://github.com/LDLN/core/wiki)!
