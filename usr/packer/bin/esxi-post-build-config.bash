#!/bin/bash -u

echo "packer    ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
sync

GATEWAY=10.0.0.1

sudo tee /etc/network/interfaces <<EOF
# The loopback network interface
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
address $(sudo /sbin/ifconfig | grep "inet addr" |cut -d ' ' -f 12 | sed 's/addr://'|grep -v 127\.0\.0\.1)
netmask 255.255.255.0
gateway ${GATEWAY}

EOF

