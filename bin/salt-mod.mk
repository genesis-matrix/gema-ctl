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


