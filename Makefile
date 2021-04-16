SHELL=/bin/bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
include .env
XQERL_IMAGE := docker.pkg.github.com/grantmacken/alpine-xqerl/xq:$(GHPKG_VER)

include inc/*

.PHONY: init
init: down clean
	@if [[ ! "$(PATH)" == *$(HOME)/.local/bin* ]]
	then
	echo ' - create home bin' # not sure if make can do this
	$(shell export PATH="$(PATH):$(HOME)/.local/bin")
	fi
	pushd $(HOME)/.local/bin &>/dev/null
	@if [[ -L xq ]]
	then
	echo ' - destroy existing link'
	rm xq
	fi
	echo ' - create link to bin/xq '
	ln -s $(CURDIR)/bin/xq 
	echo -n 'which xq: '
	which xq
	popd &>/dev/null
	@$(MAKE) --silent pull

.PHONY: clean
clean:
	@rm -f $(Escripts)

