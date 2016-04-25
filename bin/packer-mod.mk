##
## Packer - create manipulable VM base images from templates a/ scripts

export uri_configs   := $(project_root)/etc/packer/cfgs
export uri_assets    := $(project_root)/etc/packer/assets
export uri_scripts   := $(project_root)/usr/packer/bin

export PACKER_URI_OUTFILE_PFX ?=    packer-artifact--
export PACKER_URI_OUTFILE_SFX ?=    .box


sfx_template := .template
sfx_variable := .vars


PACKER_TEMPLATES = $(foreach var,$(patsubst %$(sfx_template),%,$(subst /,-,$(patsubst $(uri_configs)/%,%,$(shell find $(uri_configs) -iname "*$(sfx_template)")))),$(uri_configs)/$(var))
PACKER_VARIABLES = $(patsubst %$(sfx_variable),%,$(subst /,-,$(patsubst $(uri_configs)/%,%,$(shell find $(uri_configs) -iname "*$(sfx_variable)"))))

# default/example build config variables
#+ORIG:removal-candidate:export PACKER_VIRTTYPE ?= virtualbox-iso
#+ORIG:removal-candidate:export PACKER_MIRROR_ROOTURL ?=
#+ORIG:removal-candidate:export PACKER_MIRROR_ROOTURL ?=  http://mirrors.kernel.org/centos
#+ORIG:removal-candidate:export PACKER_MIRROR_RELAPATH ?= /6/isos/x86_64/
#+ORIG:removal-candidate:export PACKER_IMAGE_OSNAME ?=    CentOS
#+ORIG:removal-candidate:export PACKER_IMAGE_OSRELEASE ?= 6.7
#+ORIG:removal-candidate:export PACKER_IMAGE_OSARCH ?=    x86_64
#+ORIG:removal-candidate:export PACKER_MIRROR_SUFFIX ?=   -bin-DVD1.iso
#+ORIG:removal-candidate:export PACKER_ISO_CHECKSUM ?= 7bb8c1c23a4fdef93e6f0a6347d570e5764d0b38
#+ORIG:removal-candidate:export PACKER_ISO_CHECKSUM_TYPE ?= sha1
#+ORIG:removal-candidate:export PACKER_URI_OUTDIR ?= $(BUILD_DIR)
#+ORIG:removal-candidate:export PACKER_URI_OUTFILE_PFX ?=    packer-artifact--
#+ORIG:removal-candidate:export PACKER_URI_OUTFILE_SFX ?=    .box
#+ORIG:removal-candidate:export PACKER_MEMORY ?=        512
#+ORIG:removal-candidate:export PACKER_VCPUS ?=         1


#
## build config functions
fn_buildinfo_from_uri = $(shell echo "$(notdir $@)" | sed -ne 's/$(PACKER_URI_OUTFILE_PFX)\(.*\)--\(.*\)$(PACKER_URI_OUTFILE_SFX)_\(.*\)/\1 \2 \3/p')
fn_build_label = $(word 2,$(call fn_buildinfo_from_uri,$1))
fn_build_virttype = $(word 1,$(call fn_buildinfo_from_uri,$1))
fn_build_consumer = $(word 3,$(call fn_buildinfo_from_uri,$1))
fn_var_basename = $(patsubst $(PACKER_URI_OUTFILE_PFX)%,%,$(patsubst %$(sfx_variable),%,$(notdir $(1))))
fn_osname_from_var = $(word 2,$(subst -,$(space),$(call fn_var_basename,$(1))))
fn_osrelease_from_var = $(word 3,$(subst -,$(space),$(call fn_var_basename,$(1))))
fn_osarch_from_var = $(word 4,$(subst -,$(space),$(call fn_var_basename,$(1))))
fn_hypervisor_from_var = $(word 1,$(subst -,$(space),$(call fn_var_basename,$(1))))
fn_template_from_var = $(uri_configs)/$(call fn_hypervisor_from_var,$(1))-$(call fn_osname_from_var,$(1))$(sfx_template)
fn_vars_from_uri = $(uri_configs)/$(call fn_build_consumer,$@)--$(call fn_build_virttype,$@)--$(call fn_build_label,$@)$(sfx_variable)
fn_tmpl_from_uri = $(uri_configs)/$(call fn_build_consumer,$@)--$(call fn_build_label,$@)$(sfx_template)
fn_tmpl_from_varfile = $(shell jq -r '.uri_template' $(call fn_vars_from_uri,$@))
fn_template_uri = $(if $(shell which jq),$(call fn_tmpl_from_varfile,$@),$(call fn_tmpl_from_uri,$@))


#
##
cmd_packer_pre := export CHECKPOINT_DISABLE=1 PACKER_LOG=t PACKER_CACHE_DIR=$(project_root)/tmp/cache ;
shell_post := &>$(uri_log)
opt_packer := -var='http_directory=$(uri_assets)' -var='output_directory=$(project_root)/tmp/build' -var='uri_scripts=$(uri_scripts)' 


#
##
module_keys += packer
.PHONY: packer-help packer-clean packer-build-% packer-info-% 
packer-help:
	## $@ ##
	# - for a list of available images: make packer-list-builds
	# - (ex.) create a specific build artifact: make $(pwd)/tmp/build/packer-artifact--vmware-iso--CentOS-6.7-x86_64.box_vagrant
	# - (ex.) generic build entrypoint command: make packer-build-vmware-iso--CentOS-6.7-x86_64.box_vagrant 
	# - (ex.) vagrant build and register: make vagrant-boxadd-vmware-iso--CentOS-6.7-x86_64


$(BUILD_DIR)/$(PACKER_URI_OUTFILE_PFX)%$(PACKER_URI_OUTFILE_SFX)_vagrant: chkdirs
	## $@ ##
	$(cmd_packer_pre) packer build -only='$(call fn_build_virttype,$@)' -var-file=$(call fn_vars_from_uri,$@) $(opt_packer)  -var='uri_outfile=$(@)' $(call fn_template_uri,$@)
	@echo

$(BUILD_DIR)/$(PACKER_URI_OUTFILE_PFX)%$(PACKER_URI_OUTFILE_SFX)_exsi5: chkdirs
	## $@ ##
	$(cmd_packer_pre) packer build -only='$(call fn_build_virttype,$@)' -var-file=$(call fn_vars_from_uri,$@) $(opt_packer)  -var='uri_outfile=$(@)' $(call fn_template_uri,$@)
	@echo

$(BUILD_DIR)/$(PACKER_URI_OUTFILE_PFX)%$(PACKER_URI_OUTFILE_SFX)_digitalocean: chkdirs
	## $@ ## https://www.packer.io/docs/builders/digitalocean.html
	$(cmd_packer_pre) packer build -only='$(call fn_build_virttype,$@)' -var-file=$(call fn_vars_from_uri,$@) $(opt_packer)  -var='uri_outfile=$(@)' $(call fn_template_uri,$@)
	@echo


packer-info-%:
	## $@ ##
	packer inspect $(uri_configs)/$(@:packer-info-%=%)$(sfx_template)


packer-list-images:
	## $@ ## list of build-able packer images. To build append the build name after: 'make packer-build-'. Note the type designators, such as: 'vagrant', and 'vmware-iso'. 
	@echo "builds:  $(foreach var,$(PACKER_VARIABLES),$(space)$(space)$(call fn_var_basename,$(var)))"
	@echo

packer-clean:
	## $@ ##
	@find $(project_root) -type f -iname 'packer-artifact-*' -delete
	@rm -rf $(project_root)/output-vmware-iso $(project_root)/output-virtualbox-iso $(project_root)/packer_cache


packer-build-%.box_vagrant: chkdirs $(BUILD_DIR)/$(PACKER_URI_OUTFILE_PFX)%$(PACKER_URI_OUTFILE_SFX)_vagrant
	## $@ ## 

packer-build-%.box_esxi5: chkdirs $(BUILD_DIR)/$(PACKER_URI_OUTFILE_PFX)%$(PACKER_URI_OUTFILE_SFX)_esxi5
	## $@ ##

packer-build-%.box_digitalocean: chkdirs $(BUILD_DIR)/$(PACKER_URI_OUTFILE_PFX)%$(PACKER_URI_OUTFILE_SFX)_digitalocean
	## $@ ## consumer--provider--label

packer-info-%:
	## $@ ##
	packer inspect $(uri_configs)/$(@:packer-info-%=%)$(sfx_template)

