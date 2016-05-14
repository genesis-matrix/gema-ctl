#!/bin/false

## Test -
module_keys += test

test-packer-builds-for-vagrant: $(foreach VAR,$(shell make packer-list-images |xargs -n1 | grep -v '##' | grep '.box_vagrant'),packer-build-$(VAR))
	## $@ ## test all packer builds targeting: vagrant

test-vagrant-boxes:
	## $@ ##
	@vagrant box list 2>/dev/null | while read -a line ;do export vmname="$${line[0]}" ; export provider=$$(echo $${line[1]} | sed -ne 's/[(,]//gp') ; [[ "$${provider}" == "vmware_desktop" ]] && provider="vmware_fusion" ; echo "#\t-- \002${@}#$${vmname}\017 -- \tvm='$${vmname}'\tprovider='$${provider}'" ; pushd $$(mktemp -d) && vagrant init -m "$${vmname}" "$${vmname}" && vagrant up --provider="$${provider}" --provision && vagrant ssh -c 'cd /vagrant ; exit $$?' && vagrant destroy -f && echo "#\t-- ${@}#$${vmname}: \002OK\017" || echo "#\t-- ${@}#$${vmname}: \002FAIL\017" ; vagrant destroy -f ; popd ;done
