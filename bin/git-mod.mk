#!/bin/false
#+PURPOSE: Git

module_keys += scm
.PHONY: scm-help scm-clean scm-init scm-repo-sync scm-repo-update scm-repo-status scm-stage scm-pull scm-rebase scm-push scm-commit scm-switch-branch scm-logl scm-logm scm-ls
help-scm: scm-help
scm-help:
	#+TODO: $@

scm-clean: 
	git clean -xdfn
scm-init:
	@git config push.default upstream
	@git config core.editor nano
	@git config merge.renameLimit 0
	@git config diff.renameLimit 0
	@$(project_root)/util/_src_ctrl/git_cfg_user.sh
scm-repo-sync: scm-commit scm-pull scm-push
scm-repo-update:
	@git remote update
	@git remote show -n origin
scm-repo-status: scm-repo-update
	@git branch -vv
scm-stage:
	@git add -i
scm-pull:
	@echo "info: synchronizing with repository branch..."
	@git pull --ff-only origin $(git branch | grep ^* | cut -c3- ) || echo "git :wrn: unable to merge with upstream, consider the cause and try rebase (if appropriate)."
scm-rebase:
	@git rebase
scm-rebase-1:
	@git rebase origin/$(git branch | grep ^* | cut -c3- )
scm-rebase-onto-devnext:
	@git rebase origin/develop-next
scm-push:
	@echo "info: pushing local commits to repository..."
	@git push origin $(git branch | grep ^* | cut -c3- )
scm-commit :
	@git commit --interactive && echo "info: local commit created successfully"
scm-switch-branch:
	@#+WIP
scm-logl:
	@git log --oneline  --graph --decorate --color --date=relative --all
scm-logm:
	@git log --pretty   --graph --decorate --color --date=relative --find-copies-harder --stat HEAD
scm-ls:
	@git status

