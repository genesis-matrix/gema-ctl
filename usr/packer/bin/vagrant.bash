#!/bin/bash -ux

#+PURPOSE: get vagrant.pub from upstream vagrant project
#+NB: vagrant will automatically swap out this key for a less insecure variant on 'vagrant up'

# previously, 'https://github.com/mitchellh/vagrant/raw/master/keys/vagrant.pub'
uri_vagrantkey="https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub"

mkdir -p /home/vagrant/.ssh
curl -L "${uri_vagrantkey}" -o /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh
chmod -R go-rwsx /home/vagrant/.ssh
