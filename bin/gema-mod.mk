#!/bin/false
#+PURPOSE: 

module_keys += gema
help-gema: gema-help
gema-help:
	## $@ ## 
	#+TODO


gema-chk: platform-chk python-chk gema-chk-prereqs scm-chk vagrant-chk salt-chk packer-chk
	## $@ ##

gema-chk-prereqs: vagrant-chk-prereqs packer-chk-prereqs
	## $@ ## 

gema-ready: gema-chk scm-smod-all-current
	## $@ ##

gema-online: gema-ready scm-smod-all-current vagrant-up
	## $@ ## readies and executes $(package_name)

gema-preflightcheck-vm-present-%:
	## $@ ##
	@#+TODO: remove recursive use of make
	@if make vagrant-boxchk-$(patsubst gema-preflightcheck-vm-present-%,%,$@) 2>/dev/null ;then true ;else make packer-list-images | grep -qs -e '$(word 1,$(subst --,$(space),$(patsubst gema-preflightcheck-vm-present-%,%,$@)))' -e '$(word 2,$(subst --,$(space),$(patsubst gema-preflightcheck-vm-present-%,%,$@)))' && make vagrant-boxadd-$(patsubst gema-preflightcheck-vm-present-%,%,$@ || echo "nfo: cant build basebox $(patsubst gema-preflightcheck-vm-present-%,%,$@), skipping") ;fi

<<<<<<< HEAD
gema-preflightcheck-vm-present-%:
	## $@ ## 
	-@if make vagrant-boxchk-$(patsubst gema-preflightcheck-vm-present-%,%,$@) 2>/dev/null ;then true ;else make packer-list-images | grep -qs -e '$(word 1,$(subst --,$(space),$(patsubst gema-preflightcheck-vm-present-%,%,$@)))' -e '$(word 2,$(subst --,$(space),$(patsubst gema-preflightcheck-vm-present-%,%,$@)))' && make vagrant-boxadd-$(patsubst gema-preflightcheck-vm-present-%,%,$@) || echo "  #NFO# unable to build the named image, moving on.." ;fi
	-@#NOTE: some vagrant boxes use a slash in the name, 'centos/7', which is not accepted by make as part of a valid target name, (ref: https://stackoverflow.com/questions/21182990/makefile-is-it-possible-to-have-stem-with-slash)

gema-pipenv-setup:
	## $@ ##
	@#NOTE: the 'python3 -mpipenv <pipenv_cmd_or_arg>' construct is really handy for getting access to a pipenv environment even when the pipenv command isn't in the path. Peculularly while this will enter (creating where needed) an environment, it wont install pipenv in that environment. It's not a big deal, just something to know to check for - just install pipenv in pipenv, (typically in the Pipfile).f
	@#NOTE: I'd put some effort into making sure that the right version of pipenv was launched, but realize now that doesn't matter. As long as I can launch pipenv as a module directive, (in any version), then I can specify the version I want as an argument. Any installed python version can be specified in the Pipenv to be used in the virtual environment in this way, thank goodness. 'python -mpipenv install pipenv --three'
	@#NOTE: In fact, as hoped, as long as the python version is specified in the Pipfile the environment will be created with that version even when invoked from a different version so the version arguments are really not needed. This _could_ be the nicest thing about pipenv.
	# ... verify that python is available and declare the version used, but fail if python is unavailable (python is soft requirement) 
	@which python >&2
	# ... verify that pip is available for use and if it isn't then install it
	@which pip &>/dev/null || (curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python get-pip.py --user)
	# ... verify that pipenv is available for use and if it isn't then install it 
	@which pipenv  &>/dev/null || pip install --user pipenv
	# ... use pipenv to setup/create the working virtual environment
	-@python -mpipenv lock --dev
	-@python -mpipenv sync --dev

gema-pipenv: gema-pipenv-setup
	## $@ ##
	@python -mpipenv shell

gema-pipenv-invoke-%: gema-pipenv-setup
	## $@ ##
	# ... running invoke task "$(patsubst gema-invoke-%,%,$@)" in pipenv virtual environment
	@pipenv run invoke $(patsubst gema-pipenv-run-%,%,$@)



## EOF
=======

## EOF ##
>>>>>>> gema-ctl.14west/new-master
