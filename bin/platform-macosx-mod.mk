#!/bin/false
#+PURPOSE: facilitate the setup of GeMa Controller on MacOSX



platform-macosx-fix-brew:
	## $@ ## download and install brew
	@echo "http://brew.sh/"

platform-macosx-check-virtualbox:

platform-macosx-check-swpkg:
	## $@ ##
	@which brew 2>/dev/null 1>/dev/null && echo "OK: software packager (brew) installed"

platform-macosx-check-vmware:
	## $@ ##
	@test -d /Applications/VMware\ Fusion.app 2>/dev/null 1>/dev/null && echo "OK: VMware installed"

platform-macosx-check-salt:
	## $@ ##
	@which salt 2>/dev/null 1>/dev/null && which salt-call 2>/dev/null 1>/dev/null && echo "OK: Saltstack installed" $(opt_shell_postfix)

platform-macosx-check-scm:
	## $@ ##
	@which git 2>/dev/null 1>/dev/null && echo "OK: Git installed" $(opt_shell_postfix)

platform-macosx-check-vagrant:
	## $@ ##
	@which vagrant 2>/dev/null 1>/dev/null && echo "OK: Vagrant installed" $(opt_shell_postfix)

platform-macosx-check-wfm:
	## $@ ##

platform-macosx-check-gema:
	## $@ ##


## EOF ##
