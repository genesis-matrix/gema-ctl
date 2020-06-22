#!/bin/false

## Test -
module_keys += test

test: test-suite--default
	## $@ ##

#test-packer-builds-for-vagrant: $(foreach VAR,$(shell make packer-list-images |xargs -n1 | grep -v '##' | grep '.box_vagrant'),packer-build-$(VAR))
#	## $@ ## test all packer builds targeting: vagrant

test-vagrant-boxes:
	## $@ ##
	@vagrant box list 2>/dev/null | while read -a line ;do export vmname="$${line[0]}" ; export provider=$$(echo $${line[1]} | sed -ne 's/[(,]//gp') ; [[ "$${provider}" == "vmware_desktop" ]] && provider="vmware_fusion" ; echo "#\t-- \002${@}#$${vmname}\017 -- \tvm='$${vmname}'\tprovider='$${provider}'" ; pushd $$(mktemp -d) && vagrant init -m "$${vmname}" "$${vmname}" && vagrant up --provider="$${provider}" --provision && vagrant ssh -c 'cd /vagrant ; exit $$?' && vagrant destroy -f && echo "#\t-- ${@}#$${vmname}: \002OK\017" || echo "#\t-- ${@}#$${vmname}: \002FAIL\017" ; vagrant destroy -f ; popd ;done

test-suite--default:
	## $@ ##
	vagrant status
	vagrant up
	vagrant provision
	vagrant status


test-ready-precommit: python-ready-pipenv
	## $@ ##
	@pipenv run pre-commit install


test-precommit-install-foreach-submodule:
	## $@ ##
	@pipenv run git submodule foreach pre-commit install


test-precommit-run-all: test-ready-precommit
	## $@ ##
	@pipenv run pre-commit run --all-files


test-precommit-run-all-foreach-submodule:
	## $@ ##
	@pipenv run git submodule foreach pre-commit run --all-files


## EOF
