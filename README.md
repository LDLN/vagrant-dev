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
7. [VM] `sudo /etc/init.d/ldln_dev_startup.sh`

### Open your development environment (all [Local])

8. `open -a "Visual Studio Code" ./` – the vagrant config stuff will be in the top level directory, and all LDLN modules can be found in the `ldln-workspace` directory, which is mapped to a VM directory (i.e. updates in the local IDE will be reflected in the VM)

### Remove vm and filesystem (i.e. nuclear option if troubleshooting not going well – all [Local])
1. vagrant destroy
2. rm -Rf ldln-basestation
3. rm -Rf .vagrant

## What Does It Do?

If all goes well, it should run all services necessary to simulate a deployment of a single LDLN Basestation. The [web-app](https://github.com/LDLN/web-app) interface is exposed via http://localhost:9000 and the websocket interface is exposed via ws://localhost:8080/ws

## Serial Ports

Good resource on developing on serial ports with Vagrant:
http://yagamy.logdown.com/posts/138888-serialport-programming-on-platform-virtual-machines

<hr />

Stuck on something? Check [the wiki](https://github.com/LDLN/core/wiki)!
