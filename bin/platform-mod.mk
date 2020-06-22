#!/bin/false
#+PURPOSE: check a/o installed the basic project requisites: salt, git, vagrant

#+TODO: detect 'platform' instead of hardcoding, for multi-platform support
ifeq ($(strip $(firstword $(machineinfo_uname))) , Darwin)
platform = macosx
endif

platform-check: platform-chk
platform-chk: $(foreach var,$(module_keys),platform-check-$(var))
	## $@ ##
platform-check-test:
	## $@ ##

platform-check-bash: platform-$(platform)-check-bash
	## $@ ##
platform-check-swpkgs: platform-$(platform)-check-swpkgs
	## $@ ##
platform-check-salt: platform-$(platform)-check-salt
	## $@ ##
platform-check-vagrant: platform-$(platform)-check-vagrant
	## $@ ##
platform-check-wfm: platform-$(platform)-check-wfm
	## $@ ##
platform-check-gema: platform-$(platform)-check-gema
	## $@ ##
platform-check-scm: platform-$(platform)-check-scm
	## $@ ##
platform-check-packer: platform-$(platform)-check-packer
	## $@ ##
