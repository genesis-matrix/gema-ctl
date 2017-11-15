#!/bin/false
#+PURPOSE: 

module_keys += gema
help-gema: gema-help
gema-help:
	## $@ ## 
	#+TODO

gema-setup:
	## $@ ## 
	@which vagrant >/dev/null
	@which jq >/dev/null
	@which remarshal >/dev/null

gema-online: gema-setup vagrant-up
	## $@ ## readies and executes $(package_name)

gema-online-macosx:
	## $@ ##

gema-preflightcheck-vm-present-%:
	## $@ ## 
	@if make vagrant-boxchk-$(patsubst gema-preflightcheck-vm-present-%,%,$@) 2>/dev/null ;then true ;else make packer-list-images | grep -qs -e '$(word 1,$(subst --,$(space),$(patsubst gema-preflightcheck-vm-present-%,%,$@)))' -e '$(word 2,$(subst --,$(space),$(patsubst gema-preflightcheck-vm-present-%,%,$@)))' && make vagrant-boxadd-$(patsubst gema-preflightcheck-vm-present-%,%,$@) ;fi

