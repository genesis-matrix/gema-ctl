#!/bin/false
## Makefile


#
## default rule
#

intro :
	## $@ ##
	@echo "project_name is $(package_name)"
	@echo "project_root is $(project_root)"
	@echo "for further info try =make help="

help :
	## $@ ##
	@echo "make online -- readies and executes $(package_name)"
	@echo "additional documentation is available in the ./ReadMe.org file"
	@echo "\tor for example: make help-x -- where x is any of: $(module_keys)"
	@echo "\tor for a list of commands: make help-commands"


help-todo-crit:
	## $@ ##
	@echo "\t__urgent:" && grep -rIn '#+XXX:' $(srcdir) $(sysconfdir)  $(opt_shell_postfix) | nl 
help-todo-high:
	## $@ ##
	@echo "\t__needed:" && grep -rIn '#+FIXME:' $(srcdir) $(sysconfdir)  $(opt_shell_postfix) | nl
help-todo: help-todo-crit help-todo-high
	## $@ ##
	@echo "\t__optimal:" && grep -rIn '#+TODO:' $(srcdir) $(sysconfdir)  $(opt_shell_postfix) | nl
help-todo-low:
	## $@ ##
	@echo "\t__considerations:" && grep -rIin -e '#+Q:' -e '#+WARN:' -e '#+INFO:' -e '#+NB:' $(srcdir) $(sysconfdir)  $(opt_shell_postfix) | nl


help-commands:
	## $@ ##
	@find $(project_root)/bin/*-mod.mk -exec sed -ne '/^[a-zA-Z0-9%$$_-]*:.*/N;s/^\([a-zA-Z0-9%$$_-]*\):.*## $$@ ##\(.*\)/\1 ... \2/p' {} \;

help-platform:
	## $@ ##
	@echo "\tmachineinfo_uname == $(machineinfo_uname)"
	@echo "\tmachineinfo_lsbrelease == $(machineinfo_lsbrelease)"

pause:
	## $@ ##
	@sleep 3

pause%:
	## $@ ##
	@sleep $(@:pause%=%)

## helper variables
empty :=
space := $(empty) $(empty)
comma := ,
lparen := $(empty)($(empty)
rparen := $(empty))$(empty)


## Essential Basics
package_name := gema-ctl
package_key := gema
project_root := $(shell pwd)
uri_logfile ?= $(project_root)/tmp/log
opt_shell_postfix ?= 2>/dev/null


## Platform Info
machineinfo_uname := $(shell uname -a)
machineinfo_lsbrelease := $(shell which lsb_release >/dev/null 2>/dev/null && lsb_release -a 2>/dev/null)


#
## Build Paths
#+nb: "?=" variables can be overrided from enviroment as needed
TMP_DIR ?= $(project_root)/tmp
TMP_DIR_LIST := $(TMP_DIR) $(TMP_DIR)/log
BUILD_DIR ?= $(TMP_DIR)/build
OBJ_DIR ?= $(BUILD_DIR)/obj
LIB_DIR ?= $(BUILD_DIR)/lib
DBG_DIR ?= $(BUILD_DIR)/dbg
DEP_DIR ?= $(BUILD_DIR)/dep
BIN_DIR ?= $(BUILD_DIR)/bin
BUILD_DIR_LIST := $(BUILD_DIR) $(OBJ_DIR) $(LIB_DIR) $(DBG_DIR) $(DEP_DIR) $(BIN_DIR)
## Release Paths
prefix ?= $(INSTALL_DIR)
exec_prefix ?= $(prefix)
bindir ?= $(exec_prefix)/bin
libdir ?= $(exec_prefix)/lib
libexecdir ?= $(exec_prefix)/libexec/$(package_name)
includedir ?= $(prefix)/include
sysconfdir ?= $(prefix)/etc
datarootdir ?= $(prefix)/share
datadir ?= $(datarootdir)/dat/$(package_name)
docdir ?= $(datarootdir)/doc/$(package_name)
#srcdir := $(project_root)/src
srcdir := $(project_root)/srv
RELEASE_DIR_LIST := $(prefix) $(exec_prefix) $(bindir) $(libdir) $(libexecdir) $(includedir) $(sysconfdir) $(datarootdir) $(datadir) $(docdir)
DIR_LIST := $(TMP_DIR_LIST) $(BUILD_DIR_LIST) $(INSTALL_DIR) $(RELEASE_DIR_LIST)


#
## config variables
timestamp := $(shell date -u "+%Y%m%dT%H%M%S")

#
## repo-level operations
#

online: $(package_key)-online
chkdirs:
	## $@ ##
	mkdir -p $(project_root)/tmp/{build,cache,output,scratch}


#
## Modular Makefile Auxiliary Info
#

## pull in Makefile functional modules
-include ./bin/*-mod.mk
-include ./srv/salt/pillar/base.*/MISC/GNUMAKE/*-mod.mk
