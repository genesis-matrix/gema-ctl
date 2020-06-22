#!/bin/false
#,PURPOSE:

module_keys += python
help-python: python-help
python-help:
	## $@ ##
	#,TODO:

fn_pipenv = $(shell cd $(project_root)/bin && python -mpip install pipenv && python -mpipenv $@)



python-chk: python-chk-prereqs python-chk-config python-chk-ready
	## $@ ##

python-chk-prereqs: python-install-pyenv python-pyenv-install-python python-install-pipenv
	## $@ ##
	@which pyenv >/dev/null || (echo "ERR: required program 'pyenv' not found. Please install/add it!" ; exit 3)
	@which python >/dev/null || (echo "ERR: required program 'python' not found. Please install/add it!" ; exit 3)
	@which pipenv >/dev/null || (echo "ERR: required program 'pipenv' not found. Please install/add it!" ; exit 3)

python-chk-config:
	## $@ ##
	#,TODO: check that the python-version is among pyenv's available versions

python-chk-ready: python-chk-config python-pipenv-install
	## $@ ##

python-install-pyenv:
	## $@ ##
	@if ! which pyenv >/dev/null ;then curl https://pyenv.run | bash && for i in 'export PATH="$${HOME}/.pyenv/bin:$$PATH"' 'eval "$$(pyenv init -)"' 'eval "$$(pyenv virtualenv-init -)"' ;do grep -q "$${i}" ~/.bashrc || echo "$${i}" >> ~/.bashrc ;done && exec $${SHELL} || echo "INFO: PYENV was installed. You may need to restart your shell or type 'exec \$${SHELL}' to make use of it." ;fi


python-pyenv-install-python: python-install-pyenv
	## $@ ##
	@pyenv version || pyenv install


python-install-pipenv: python-install-pyenv
	## $@ ##
	@python -mpip install pipenv


python-ready-pipenv: python-pipenv-install
	## $@ ##
	@pipenv install


python-pipenv-install:
	## $@ ##
	@python -mpipenv run pipenv install


python-pipenv-update: python-ready-pipenv
	## $@ ##
	@pipenv update


python-inv: python-invoke
python-invoke:
	## $@ ##
	pipenv shell inv intro


## EOF ##
