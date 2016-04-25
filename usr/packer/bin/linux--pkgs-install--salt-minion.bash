#!/bin/bash -u

enable="n"
autostart="n"

# CentOS v7
cat /etc/centos-release | grep -sq 'CentOS Linux release 7' && ( yum -y install epel-release && yum -y install salt-minion ; [[ "${enable}" =~ ^[yY] ]] && systemctl start salt-minion && [[ "${autostart}" =~ ^[yY] ]] && systemctl enable salt-minion && echo 'OK: minion init as cent7' )

# CentOS v6
cat /etc/centos-release | grep -sq 'CentOS release 6' && ( yum -y install epel-release ; sed -i 's/https/http/' /etc/yum.repos.d/epel.repo ; yum -y install salt-minion ; [[ "${enable}" =~ ^[yY] ]] && service salt-minion start && [[ "${autostart}" =~ ^[yY] ]] && chkconfig salt-minion on && echo 'OK: minion init as cent6' )

# CentOS v5
cat /etc/redhat-release | grep -sq 'CentOS release 5' && ( yum -y install python-hashlib && wget https://copr.fedorainfracloud.org/coprs/saltstack/salt-el5/repo/epel-5/saltstack-salt-el5-epel-5.repo -O /etc/yum.repos.d/saltstack-copr.repo && wget --no-check-certificate https://copr-be.cloud.fedoraproject.org/results/saltstack/salt-el5/pubkey.gpg && rpm --import pubkey.gpg && yum -y install salt-minion ; [[ "${enable}" =~ ^[yY] ]] && /sbin/service salt-minion start && [[ "${autostart}" =~ ^[yY] ]] && /sbin/chkconfig salt-minion on && echo 'OK: minion init as cent5' )


# end on a high note
exit 0
