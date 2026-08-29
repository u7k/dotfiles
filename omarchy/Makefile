.PHONY: help bootstrap packages link codex shell verify

help:
	@printf '%s\n' \
	  'make bootstrap  Install packages, link dotfiles, and verify the setup' \
	  'make packages   Install the shared terminal toolset with Omarchy' \
	  'make link       Back up existing targets and create dotfile links' \
	  'make codex      Merge the shared Codex permission defaults' \
	  'make shell      Install Oh My Zsh and make Zsh the default shell' \
	  'make verify     Check shell syntax and Arch package availability'

bootstrap:
	./scripts/bootstrap.sh

packages:
	./scripts/install-packages.sh

link:
	./scripts/link.sh

codex:
	../shared/scripts/install-codex-config.sh

shell:
	./scripts/install-shell-support.sh
	./scripts/set-default-shell.sh

verify:
	./scripts/verify.sh
