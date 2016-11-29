#!/bin/false

## Salt - 
module_keys += salt
export uri_salt_roots   := $(project_root)/srv/roots


##
##

fn_roster_machines = $(shell cat etc/salt/roster | remarshal -if yaml -of json | jq -r 'keys|.[]' | xargs )
fn_roster_images = $(filter-out null,$(sort $(foreach var,$(call fn_roster_machines),$(shell cat etc/salt/roster | remarshal -if yaml -of json | jq -r '."$(var)".minion_opts.grains.basebox_image'))))


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
	@find $(project_root)/srv/roots/base/state -type f -iname '*.sls' | sed -ne 's/.*\/srv\/roots\/base\/\(.*\)\.sls/\1/;s/\//\./gp'

salt-report-failed-states:
	## $@ ##
	@for i in $$(make salt-list-states | grep 'state.' | grep -v '##') ;do sudo salt-call --retcode-passthrough state.apply $${i} mock=Test &>/dev/null || (echo -e "\n\n##$${i}##" | tee -a tmp/failed-states.rpt ; sudo salt-call state.apply $${i} mock=Test | tee -a tmp/failed-states.rpt ) ;done



