#!/bin/false

## Salt -
module_keys += salt
export vm_salt_master   := salt-master-d1
export uri_salt_roots   := $(project_root)/srv/salt/fileserver/base.*
export uri_salt_pillar  := $(project_root)/srv/salt/pillar/base.*

##
##

fn_roster_machines = $(shell cat etc/salt/roster | remarshal -if yaml -of json | jq -r 'keys|.[]' | xargs )
fn_roster_images = $(filter-out null,$(sort $(foreach var,$(call fn_roster_machines),$(shell cat etc/salt/roster | remarshal -if yaml -of json | jq -r '."$(var)".minion_opts.grains.basebox_image'))))


salt-chk: salt-chk-prereqs
	## $@ ##

salt-chk-prereqs:
	## $@ ##
	@which remarshal >/dev/null || (echo "ERR: required program 'remarshal' not found. Pleaase install/add it!" ; exit 3)
	@which salt-call >/dev/null || (echo "ERR: recommended program 'salt-call' not found. Pleaase install/add it!")

salt-list-machines:
	## $@ ##
	@echo $(call fn_roster_machines)
	@echo

salt-list-images:
	## $@ ##
	@echo $(call fn_roster_images,$(call fn_roster_machines))
	@echo

salt-list-states:
	## $@ ##
	@find $(project_root)/srv/salt/fileserver/base.*/state -type f -iname '*.sls' | sed -ne 's/.*\/srv\/salt\/fileserver\/base\.\/\(.*\)\.sls/\1/;s/\//\./gp'

salt-report-failed-states:
	## $@ ##
	@for i in $$(make salt-list-states | grep 'state.' | grep -v '##') ;do sudo salt-call --retcode-passthrough state.apply $${i} mock=Test &>/dev/null || (echo -e "\n\n##$${i}##" | tee -a tmp/failed-states.rpt ; sudo salt-call state.apply $${i} mock=Test | tee -a tmp/failed-states.rpt ) ;done

salt-highstate-apply:
	## $@ ##
	-@vagrant ssh salt-master-d1 -c 'sudo salt -C "* and not salt-master-d1" state.apply --force-color '

salt-highstate-apply-on-%:
	## $@ ##
	-@vagrant ssh salt-master-d1 -c 'sudo salt -C "$(@:salt-highstate-apply-on-%=%)" state.apply --force-color '

salt-highstate-show-on-%:
	## $@ ##
	@vagrant ssh salt-master-d1 -c 'sudo salt -C "$(@:salt-highstate-show-on-%=%)" state.show_highstate --force-color '

salt-highstate-list-on-%:
	## $@ ##
	@vagrant ssh salt-master-d1 -c 'sudo salt -C "$(@:salt-highstate-list-on-%=%)" state.show_top --force-color '


salt-pillar-items-on-%:
	### $@ ##
	@vagrant ssh salt-master-d1 -c 'sudo salt -C "$(@:salt-pillar-get-on-%=%)" pillar.items --force-color '

salt-pillar-debug-on-%:
	### $@ ##
	@vagrant ssh salt-master-d1 -c 'sudo salt-run pillar.show_pillar "$(@:salt-pillar-debug-on-%=%)" -l debug --force-color '
