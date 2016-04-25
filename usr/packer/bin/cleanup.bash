#!/bin/bash -u

## <Functions> ##
fn_lsb_bootstrap(){
    [[ -f /etc/redhat-release ]] \
	|| [[ -f /etc/centos-release ]] \
	&& yum -y install redhat-lsb-core
    [[ -f /etc/debian-release ]] \
	&& apt-get -y install lsb-release
}
fn_cleanup_opt_00(){
    yum -y clean all
}
fn_cleanup_opt_01(){
    # clean up redhat interface persistence
    rm -f /etc/udev/rules.d/70-persistent-net.rules
    sed -i 's/^HWADDR.*$//' /etc/sysconfig/network-scripts/ifcfg-eth0
    sed -i 's/^UUID.*$//' /etc/sysconfig/network-scripts/ifcfg-eth0
}
fn_cleanup_opt_02(){
    rm -rf VBoxGuestAdditions_*.iso VBoxGuestAdditions_*.iso.?
}
fn_cleanup_opt_03(){
    rm -rf /tmp/*
}
## </Functions>
## <Main> ##
fn_lsb_bootstrap ; sleep 5
osdistro=$(lsb_release -is 2>/dev/null)
osversion=$(lsb_release -rs 2>/dev/null)
echo "nfo: osdistro=${osdistro} ,, osversion=${osversion}"
case ${osdistro} in
    CentOS|RedHat)
	case ${osversion} in
	    5*)
		echo "dbg: match cent5"
		fn_cleanup_opt_00
		fn_cleanup_opt_01
		fn_cleanup_opt_02
		;;
	    6*)
		echo "dbg: match cent6"
		fn_cleanup_opt_00
		fn_cleanup_opt_01
		fn_cleanup_opt_02
		;;
	    7*)
		echo "dbg: match cent7"
		fn_cleanup_opt_00
		fn_cleanup_opt_02
		;;
	    *)
		echo "wrn: no match, cent ?version?"
		;;
	esac
	;;
    Ubuntu|Debian)
	echo "nfo: osdistro Ubuntu a/o Debian"
	echo "wrn: not implemented yet"
	;;
    *)
	echo "wrn: no match on osdistro"
	echo "wrn: not implemented yet"
	;;
esac	    
##- </Main>
