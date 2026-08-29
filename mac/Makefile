.PHONY: help bootstrap packages link codex vscode macos verify

help:
	@printf '%s\n' \
	  'make bootstrap  Install packages, shell support, links, and editor extensions' \
	  'make packages   Install Homebrew packages and applications' \
	  'make link       Back up existing targets and create dotfile links' \
	  'make codex      Merge the shared Codex permission defaults' \
	  'make vscode     Install the recorded VS Code extensions' \
	  'make macos      Apply the documented macOS preferences' \
	  'make verify     Check scripts, links, and likely secrets'

bootstrap:
	./scripts/bootstrap.sh

packages:
	./scripts/install-packages.sh

link:
	./scripts/link.sh

codex:
	../shared/scripts/install-codex-config.sh

vscode:
	./scripts/install-vscode-extensions.sh

macos:
	./macos/defaults.sh

verify:
	./scripts/verify.sh
