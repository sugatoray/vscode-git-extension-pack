# source:
#  - https://code.visualstudio.com/api/working-with-extensions/publishing-extension
#  - https://github.com/microsoft/vscode-vsce/issues/11
#  - https://dev.azure.com/sugatoray/_usersSettings/tokens
#  
# manage vscode extensions: 
#  - https://marketplace.visualstudio.com/manage/publishers/sugatoray

.PHONY: help
.PHONY: info.install.just
.PHONY: install.node install.vsce install.ovsx
.PHONY:	vsix.move vsix.clear
.PHONY: pkg.build pkg.publish pkg.release 
.PHONY: vsce.open vsce.token vsce.metadata
.PHONY: py.clear py.genreadme

########################## Extesion Specific Parameters #############################

VSCE_PUBLISHER := sugatoray;
VSCE_NAME := vscode-git-extension-pack;
PYTHON := python3;
# SHELL := "/bin/zsh";

## set SKIP_VSCE to "true" to skip publishing to marketplace.visualstudio.com
SKIP_VSCE := "false"
## set SKIP_OVSX to "true" to skip publishing to open-vsx.org
SKIP_OVSX := "true"

########################## DONOT CHANGE PARAMETERS BELOW ###############################

VSCE_EXTENSION_URL := https://marketplace.visualstudio.com/items?itemName=$(VSCE_PUBLISHER).$(VSCE_NAME)
VSCE_MANAGEMENT_URL := https://marketplace.visualstudio.com/manage/publishers/$(VSCE_PUBLISHER)
VSCE_TOKEN_URL := https://dev.azure.com/$(VSCE_PUBLISHER)/_usersSettings/tokens

####################### PARAMETERS ###########################

help:
	@echo "\n:::Makefile Commands' Help:::\n"
	# Commands:
	#
	# info.install.just :	Info on how to install Just
	#
	# install.node      :	Install Node.js
	# install.vsce      :	Install VSCE
	# install.ovsx      :	Install OVSX
	# install.all       :	Install Node.js, VSCE, and OVSX
	#
	# vsix.move         :	Move the .vsix artifact(s) under .artifacts folder.
	# vsix.clear        :	Clear the .vsix files from .artifacts folder.
	#
	# pkg.build         :	Build the extension (creates a.vsix file).
	# pkg.publish       :	Publish the extension.
	# pkg.release       :	Build and Publish the extension.
	#
	# vsce.open         :	Opens the VS Code Extension Management page for a Publisher.
	# vsce.token        :	Opens the Azure DevOps Page to Manage the Personal Access Token for VSCE.
	# vsce.metadata     :	Fetches extension metadata
	# vsce.extn         :	Opens the Marketplace Extension Page in Browser
	# 
	# py.clear          :	Clear off various python artifacts (files/folders)
	# py.genreadme      :	Generate README.md from package.json
	#
	@echo "\n ...: How To Manage Relevant Environment Variables :... \n"
	# 1. Update export VAR="value" lines in ~/.secrets/manage_secrets.sh file.
	# 2. Add the following line to your ~/.bashrc or ~/.zshrc file:
	#    . ~/.secrets/manage_secrets.sh
	# 3. Open a new shell (bash, zsh, etc.)
	# 

############################## ..: COMMANDS s:.. ################################

info.install.just:
	@echo "\n Info: How to install Just... ⏳\n"
	# Refer to: https://github.com/casey/just#installation
	#
	# - generic:
	#   - homebrew: brew install just
	#   - rust: cargo install just
	#   - conda: conda install -c conda-forge just
	# 
	# - macos:
	#   - macports: port install just
	#   - homebrew: brew install just
	#
	# - linux: 
	#   - debian/ubuntu: sudo apt install just
	#   - fedora: sudo dnf install just
	#   - linuxbrew: brew install just
	#
	# - windows: 
	#   - chocolatey: choco install just
	#   - scoop: scoop install just
	@echo "\n"

install.node:
	@echo "\n Installing Node.js... ⏳\n"
	brew install npm

install.vsce:
	@echo "\n Installing vsce... ⏳\n"
	@# Uninstall existing version of vsce with: npm uninstall -g vsce
	npm install -g @vscode/vsce

install.ovsx:
	@echo "\n Installing ovsx... ⏳\n"
	@# Uninstall existing version of ovsx with: npm uninstall -g ovsx
	npm install -g ovsx

install.all: install.node install.vsce install.ovsx
	@echo "\n✨ Installing node.js, vsce and ovsx... ⏳\n"

vsix.move:
	@echo "\n Moving .vsix files to .artifacts folder... ⏳\n"
	mv *.vsix ./.artifacts/

vsix.clear:
	@echo "\n Moving .vsix files to .artifacts folder... ⏳\n"
	rm ./.artifacts/*.vsix

pkg.build:
	@echo "\n🔥⚙️ Packaging... ⏳\n"
	vsce package

pkg.publish:
	@echo "\n📘📄 Publishing... ⏳\n"
	# Publish to VS Code Marketplace: using vsce [SKIP_VSCE: $(SKIP_VSCE)]
	@if [[ "$(SKIP_VSCE)" == "false" ]]; then \
		echo "Publishing to VSCE..."; \
		# vsce publish -p ${VSCE_PAT}; \
	fi;
	# Publish to open-vsx.org: using ovsx [SKIP_OVSX: $(SKIP_OVSX)]
	@if [[ "$(SKIP_OVSX)" == "false" ]]; then \
		echo "Publishing to OVSX..."; \
		# ovsx publish -p ${OVSX_PAT}; \
	fi;

pkg.release: pkg.build vsix.move pkg.publish vsix.move vsix.clear
	@echo "\n✨ Releasing... ⏳\n"

vsce.open:
	@echo "\n✨ Open VS Code Extension Manager in Browser... ⏳\n"
	$(PYTHON) -c "import webbrowser; webbrowser.open('$(VSCE_MANAGEMENT_URL)')"

vsce.token:
	@echo "\n✨ Open VS Code Extension Token Manager in Browser... ⏳\n"
	$(PYTHON) -c "import webbrowser; webbrowser.open('$(VSCE_TOKEN_URL)')"

vsce.metadata:
	@echo "\n✨ Show VS Code Extension Metadata... ⏳\n"
	vsce show $(VSCE_PUBLISHER).$(VSCE_NAME)

vsce.extn:
	@echo "\n✨ Open VS Code Extension Marketplace in Browser... ⏳\n"
	$(PYTHON) -c "import webbrowser; webbrowser.open('$(VSCE_MANAGEMENT_URL)')"

## Clear repository of python artifacts

.PHONY: py.clear
py.clear: # Clear off various python artifacts (files/folders)
	@echo "\n✨ Clear artifact files... ⏳\n"
	@echo "\n🟢 Clear .ipynb_checkpoints files"
	@# same as:
	@# find **/.ipynb_checkpoints type -f -delete
	@# source:
	@# - https://askubuntu.com/a/842170/853549
	rm -rf ./.ipynb_checkpoints ./**/.ipynb_checkpoints
	
	@echo "\n🟢 Clear __pycache__ folders"
	@# same as:
	@# find **/__pycache__ -delete
	rm -rf ./__pycache__ \
		./**/__pycache__ \
		./**/**/__pycache__

.PHONY: py.genreadme
py.genreadme:
	@echo "\n✨ Generate README.md from package.json... ⏳\n"
	$(PYTHON) ./composer/compose.py

#########################################################

.PHONY: test.envar
test.envar:
	@echo "\nTesting Environment Variables... \n"
	echo "$(HOME)"

## behold a recipe
# .PHONY: test-fun
# test.fun:
#     echo "hi" > tmp.txt
#     cat tmp.txt
#     rm tmp.txt

.PHONY: test-conditions
test-conditions:
	# echo "start"
	# echo "SKIP_VSCE: ..$(SKIP_VSCE).."
	# echo "SKIP_OVSX: ..$(SKIP_OVSX).."
	# echo "HOME: ..${HOME}.."
	echo "SKIP_VSCE: ..$(SKIP_VSCE).." && \
	echo "SKIP_OVSX: ..$(SKIP_OVSX)..";
	# SHELL is $(SHELL)
	@zsh -c 'echo "SHELL is $(zsh -c 'ps -c $$ | tail -1 | column -t -s " " | cut -d " " -f7')"';
	@if [[ "$(SKIP_VSCE)" == "false" ]]; then \
		zsh -c 'echo -e "publish vsce" ${HOME} ${VSCE_PAT}'; \
	fi;
	@if [[ "$(SKIP_OVSX)" != "false" ]]; then \
		echo -e "publish ovsx ${HOME} ${OVSX_PAT}"; \
	fi;
	@if [[ "$(SKIP_VSCE)" == "false" ]]; then \
		echo "publish vsce"; \
	fi;
	#(MAKE) test.envar # call another makefile target

.PHONY: test.target1
test.target1:
    @ echo "This is target1"

.PHONY: test.target2
test.target2:
    #(MAKE) test.target1
    @ echo "This is target2"
