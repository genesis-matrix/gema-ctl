#!/bin/false
#+PURPOSE:

module_keys += gema
help-gema: gema-help
gema-help:
	## $@ ##
	#+TODO


gema-chk: platform-chk python-chk gema-chk-prereqs scm-chk vagrant-chk salt-chk packer-chk
	## $@ ##

gema-chk-prereqs: vagrant-chk-prereqs packer-chk-prereqs
	## $@ ##

gema-ready: gema-chk scm-smod-all-current
	## $@ ##

gema-online: gema-ready scm-smod-all-current vagrant-up
	## $@ ## readies and executes $(package_name)

gema-preflightcheck-vm-present-%:
	## $@ ##
	@#+TODO: remove recursive use of make
	@if make vagrant-boxchk-$(patsubst gema-preflightcheck-vm-present-%,%,$@) 2>/dev/null ;then true ;else make packer-list-images | grep -qs -e '$(word 1,$(subst --,$(space),$(patsubst gema-preflightcheck-vm-present-%,%,$@)))' -e '$(word 2,$(subst --,$(space),$(patsubst gema-preflightcheck-vm-present-%,%,$@)))' && make vagrant-boxadd-$(patsubst gema-preflightcheck-vm-present-%,%,$@ || echo "nfo: cant build basebox $(patsubst gema-preflightcheck-vm-present-%,%,$@), skipping") ;fi



## EOF ##
