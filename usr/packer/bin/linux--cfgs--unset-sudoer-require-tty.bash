#!/bin/bash -ux

sed -i.orig_$(date "+%Y%M%dT%H%m%Z") 's/^\(Defaults\W*requiretty\)$/#+ORIG: \1/' /etc/sudoers

#cat /etc/sudoers
