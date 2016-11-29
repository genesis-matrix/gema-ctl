#!/bin/false
#+PURPOSE: 

module_keys += genesis
help-genesis: genesis-help
genesis-help:
	## $@ ## 
	#+TODO

genesis-setup:
	## $@ ## 
	@which vagrant >/dev/null
	@which jq >/dev/null
	@which remarshal >/dev/null

genesis-online: genesis-setup vagrant-up
	## $@ ## readies and executes $(package_name)

genesis-online-macosx:
	## $@ ##

genesis-preflightcheck-vm-present-%:
	## $@ ## 
	@if make vagrant-boxchk-$(patsubst genesis-preflightcheck-vm-present-%,%,$@) 2>/dev/null ;then true ;else make packer-list-images | grep -qs -e '$(word 1,$(subst --,$(space),$(patsubst genesis-preflightcheck-vm-present-%,%,$@)))' -e '$(word 2,$(subst --,$(space),$(patsubst genesis-preflightcheck-vm-present-%,%,$@)))' && make vagrant-boxadd-$(patsubst genesis-preflightcheck-vm-present-%,%,$@) ;fi

