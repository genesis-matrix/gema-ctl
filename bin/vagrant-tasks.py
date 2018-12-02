#!/usr/bin/env python
# -*- encoding: utf-8 -*-


from invoke import task


# module variables
_key = vagrant
_phony = ['vagrant-help', 'vagrant-ssh', 'vagrant-up', 'vagrant-restart', 'vagrant-down', 'vagrant-clean', 'vagrant-build', 'vagrant-run']


# functions
@task
def vagrant_help(ctx):
    """
    ## $@ ##
	#+TODO: $@
    """
    pass


@task
def vagrant_setup():
    """
	## $@ ##
    """
    pass


@task
def vagrant_up():
    """
	## $@ ##
	@vagrant up --parallel --provision
    """
    ctx.run('vagrant up --parallel --provision')


@task
def vagrant_prep(ctx, arg):
    """
vagrant-prep-%:
	## $@ ##
	@vagrant up $(@:vagrant-prep-%=%) && vagrant provision $(@:vagrant-prep-%=%)
    """
    pass


@task
def vagrant_ssh(ctx, arg):
    """
vagrant-ssh-%:
	@vagrant ssh $(@:vagrant-ssh-%=%)
    """
    pass


@task
def vagrant_into(ctx, vm=None):
    """
    vagrant-into-%: vagrant-prep-% vagrant-ssh-%
	## $@ ##
	@#vagrant up $(@:vagrant-into-%=%) && vagrant provision $(@:vagrant-into-%=%) && vagrant ssh $(@:vagrant-into-%=%)
    """
    pass


@task
def vagrant_restart(ctx):
    """
vagrant-restart:
	## $@ ##
	@vagrant down && vagrant up
vagrant-down:
	## $@ ##
	@vagrant halt
vagrant-destroy: vagrant-down vagrant-dnsresolv-off
	## $@ ##
	-@vagrant destroy -f
vagrant-dnsresolv-clear:
	## $@ ##
	-@vagrant landrush ls | awk '{print $2}' | xargs -n1 vagrant landrush del
vagrant-dnsresolv-off: vagrant-dnsresolv-clear
	## $@ ##
	-@vagrant landrush stop
vagrant-wipe: vagrant-destroy
	## $@ ## 
	-@rm -rf $(project_root)/.vagrant
	-@rm -rf $(project_root)/output-vmware-iso
vagrant-purge: 
	## $@ ## delete all "gema-" basebox images registered to vagrant
	@vagrant box list | sed -ne '/There are no installed boxes/! s/^\(gema-[^[:space:]]*\) .*$$/\1/p' |xargs -n1 vagrant box remove -f --all 
vagrant-finish: vagrant-dnsresolv-off 
	## $@ ##

vagrant-die: 
	## $@ ##

vagrant-build: vagrant-up
	## $@ ##
vagrant-run: vagrant-up
	## $@ ##
vagrant-debug: vagrant-up
	## $@ ##



#
## workarounds a/o fixes
#



# https://github.com/vagrant-landrush/landrush/issues/292
workaround-landrush-issue-295:
workaround-landrush-issue-292:
	## $@ ##
	@ln -f -s $(find ~/.vagrant.d/gems/* -type d -maxdepth 0 2>/dev/null | sort -r | head -1) ~/.vagrant/gems/gems



#
##
### core
##
#



vagrant-boxadd-qemu-%: packer-build-qemu-%.box_vagrant
	## $@ ## add new base box to Vagrant
	@vagrant box add --force $(BUILD_DIR)/$(PACKER_URI_OUTFILE_PFX)$(@:vagrant-boxadd-%=%)$(PACKER_URI_OUTFILE_SFX)_vagrant --name $(word 2,$(subst --,$(space),$(@:vagrant-boxadd-%=%))) --provider libvirt #--box-version $(timestamp)


vagrant-boxadd-virtualbox-iso-%: packer-build-virtualbox-iso-%.box_vagrant
	## $@ ## add new base box to Vagrant
	@vagrant box add --force $(BUILD_DIR)/$(PACKER_URI_OUTFILE_PFX)$(@:vagrant-boxadd-%=%)$(PACKER_URI_OUTFILE_SFX)_vagrant --name $(word 2,$(subst --,$(space),$(@:vagrant-boxadd-%=%))) --provider virtualbox #--box-version $(timestamp)


vagrant-boxadd-vmware-iso--%: packer-build-vmware-iso--%.box_vagrant
	## $@ ## add new base box to Vagrant
	@vagrant box add --force $(BUILD_DIR)/$(PACKER_URI_OUTFILE_PFX)$(@:vagrant-boxadd-%=%)$(PACKER_URI_OUTFILE_SFX)_vagrant --name $(word 2,$(subst --,$(space),$(@:vagrant-boxadd-%=%))) --provider vmware_desktop #--box-version $(timestamp)


vagrant-boxadd-%: packer-build-%.box_vagrant
	## $@ ## add new base box to Vagrant
	@vagrant box add --force $(BUILD_DIR)/$(PACKER_URI_OUTFILE_PFX)$(@:vagrant-boxadd-%=%)$(PACKER_URI_OUTFILE_SFX)_vagrant --name $(word 2,$(subst --,$(space),$(subst .box_vagrant,,$(@:vagrant-boxadd-%=%)))) --provider $(word 1,$(subst --,$(space),$(@:vagrant-boxadd-%=%))) #--box-version $(timestamp)


vagrant-boxdel-qemu--%:
	## $@ ## check for and remove existing a/o prior boxes of provider 'vmware_desktop'
	@vagrant box remove -f $(@:vagrant-boxdel-qemu--%=%) --provider=libvirt


vagrant-boxdel-vmware-iso--%:
	## $@ ## check for and remove existing a/o prior boxes of provider 'vmware_desktop'
	@vagrant box remove -f $(@:vagrant-boxdel-vmware-iso--%=%) --provider=vmware_desktop


vagrant-boxdel-virtualbox-iso--%:
	## $@ ## check for and remove existing a/o prior boxes of provider 'virtualbox'
	@vagrant box remove -f $(@:vagrant-boxdel-virtualbox-iso--%=%) --provider=virtualbox


vagrant-boxchk-qemu--%:
	## $@ ##
	@vagrant box list --box-info 2>/dev/null | grep -qs -e 'libvirt' -e '$(subst vagrant-boxchk-qemu--,,$@)' 


vagrant-boxchk-vmware-iso--%:
	## $@ ##  
	@vagrant box list --box-info 2>/dev/null | grep -qs -e 'vmware-iso' -e '$(subst vagrant-boxchk-vmware-iso--,,$@)' 

vagrant-boxchk-virtualbox-iso--%:
	## $@ ##
	@vagrant box list --box-info 2>/dev/null | grep -qs -e 'virtualbox-iso' -e '$(subst vagrant-boxchk-virtualbox-iso--,,$@)' 

vagrant-boxlst:
	@vagrant box list --box-info | awk '{print($$1, substr($$2,2, length(substr($$2,2)) -1))}'

packer-artifact--vmware-iso--%: packer-artifact--vmware-iso--%.box_vagrant
packer-artifact--vmware-iso--%.box_vagrant: $(BUILD_DIR)/packer-artifact--vmware-iso--%.box_vagrant
$(BUILD_DIR)/packer-artifact--vmware-iso--%.box_vagrant:
	## $@ ##
