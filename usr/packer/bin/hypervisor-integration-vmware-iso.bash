#!/bin/bash -ux
#+PURPOSE: support hypervisor-specific enablements and configs
#+NB: insufficiently current CA info will cause connection errors to VMware repos
echo $(grep '#+PURPOSE' "${BASH_SOURCE[0]}") >&2
#+TODO: if possible, replace this with a Salt state for basebox provisioning

## <global_variables> ##
export uri_vmware_repo=""
export uri_vmware_repo_opt_cent5="https://packages.vmware.com/tools/releases/latest/repos/vmware-tools-repo-RHEL5-10.0.5-1.el5.x86_64.rpm"
export uri_vmware_repo_opt_cent6="https://packages.vmware.com/tools/releases/latest/repos/vmware-tools-repo-RHEL6-10.0.5-1.el6.x86_64.rpm"
export uri_vmware_repo_opt_cent7=""
export uri_vmtools_osp="https://github.com/vmware/open-vm-tools/files/133266/open-vm-tools-10.0.7-3227872.tar.gz"
## </global_variables>
## <functions> ##
fn_lsb_bootstrap(){
    [[ -f /etc/redhat-release ]] \
	|| [[ -f /etc/centos-release ]] \
	&& yum -y install redhat-lsb-core
    [[ -f /etc/debian-release ]] \
	&& apt-get -y install lsb-release
}
fn_vmtoolsd_opt_00(){
    # https://github.com/mitchellh/vagrant/issues/4362
    yum -y install build-essentials linux-headers-$(uname -r)
    yum -y install epel-release
    yum -y install open-vm-tools
}
fn_vmtoolsd_opt_01(){
    curl -L "${uri_vmtools_osp}" -o open-vm-tools.tgz
    tar -xzf open-vm-tools.tgz
    
}    
fn_vmtoolsd_opt_02(){
    # (opt. 2) Install Upstream Vendor Packages (proprietary)
    # prereq, update CA bundle
    #+TODO: check for dist-release version and arch
    [[ -n "${uri_vmware_repo}" ]] || exit 1
    cd $(mktemp -d)
    curl -Lko vmware-tools-repo.rpm "${uri_vmware_repo}"
    yum -y install $(basename "${uri_vmware_repo}")
    yum -y install vmware-tools-esx-nox vmware-tools-hgfs

}
fn_vmtoolsd_opt_03(){
    #+REF: http://www.boche.net/blog/index.php/2015/08/09/rhel-7-open-vm-tools-and-guest-customization/
    cd $(mktemp -d)
    #+HINT: add VMware pkg signing keys from http://packages.vmware.com/tools/keys
    curl -LO https://packages.vmware.com/tools/keys/VMWARE-PACKAGING-GPG-DSA-KEY.pub
    curl -LO https://packages.vmware.com/tools/keys/VMWARE-PACKAGING-GPG-RSA-KEY.pub
    rpm --import ./VMWARE-PACKAGING-GPG-DSA-KEY.pub
    rpm --import ./VMWARE-PACKAGING-GPG-RSA-KEY.pub

    #+HINT: Create the yum repository file
    cat > /etc/yum.repos.d/vmware-tools.repo <<-EOF
	# 
	#+NB: this repo contains only 'open-vm-tools-deploypkg'
	[vmware-tools]
	name = VMware Tools
	baseurl = http://packages.vmware.com/packages/rhel7/x86_64/
	enabled = 1
	gpgcheck = 1

	EOF
    
}
fn_vmtoolsd_opt_04(){
    [[ -e /home/vagrant/linux.iso ]] || echo "wrn: vmware-tools iso not found at /home/vagrant/linux.iso"
    yum install -y perl gcc make kernel-headers kernel-devel
    cd $(mktemp -d)
    mkdir mnt
    /sbin/losetup -fr /home/vagrant/linux.iso
    #+ASSUME: that loop0 is the next available loopback device name
    mount /dev/loop0 ./mnt
    tar -xzf ./mnt/VMwareTools-*.tar.gz
    ./vmware-tools-distrib/vmware-install.pl -d default

}
fn_vmtoolsd_opt_05(){
    if [[ -f /etc/vmware-tools/locations ]] ;then
	sed -i '/answer AUTO_KMODS_ENABLED /d' /etc/vmware-tools/locations 
	sed -i '/answer AUTO_KMODS_ENABLED_ANSWER /d' /etc/vmware-tools/locations 
	echo "answer AUTO_KMODS_ENABLED yes" | tee -a /etc/vmware-tools/locations 
	echo "answer AUTO_KMODS_ENABLED_ANSWER yes" | tee -a /etc/vmware-tools/locations 
    fi
    echo -e "#\n# VMware Host-Guest Filesystem\n/sbin/modprobe vmhgfs" | tee -a /etc/rc.modules 
    chmod +x /etc/rc.modules
}
fn_vmtoolsd_opt_06(){
    /sbin/chkconfig vmware-tools on
    /sbin/service vmware-tools restart
}
fn_vmtoolsd_opt_07(){
    systemctl enable vmtoolsd
    systemctl restart vmtoolsd
}
fn_vmtoolsd_opt_08(){
    /sbin/chkconfig vmtoolsd on
    /sbin/service vmtoolsd restart
}

## </functions>
## <Main> ##
fn_lsb_bootstrap
osdistro=$(lsb_release -is 2>/dev/null)
osversion=$(lsb_release -rs 2>/dev/null)
case ${osdistro} in
    CentOS|RedHat)
	case ${osversion} in
	    5*)
		uri_vmware_repo="${uri_vmware_repo_opt_cent5}"
		fn_vmtoolsd_opt_00
		fn_vmtoolsd_opt_03
		fn_vmtoolsd_opt_04
		fn_vmtoolsd_opt_05
		fn_vmtoolsd_opt_06
		;;
	    6*)
		uri_vmware_repo="${uri_vmware_repo_opt_cent6}"
		fn_vmtoolsd_opt_00
		#fn_vmtoolsd_opt_02
		fn_vmtoolsd_opt_04
		fn_vmtoolsd_opt_05
		fn_vmtoolsd_opt_08
		;;
	    7*)
		uri_vmware_repo="${uri_vmware_repo_opt_cent7}"
		fn_vmtoolsd_opt_00
		fn_vmtoolsd_opt_03
		fn_vmtoolsd_opt_04
		fn_vmtoolsd_opt_05
		fn_vmtoolsd_opt_07
		;;
	    *)
		echo "wrn: no match"
		;;
	esac
	;;
    Ubuntu|Debian)
	echo "wrn: not implemented yet" ;;
    *)
	echo "wrn: no match"
	;;
esac	    
## </Main>
