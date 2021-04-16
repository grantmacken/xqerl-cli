SHELL=/bin/bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
include .env
XQERL_IMAGE := docker.pkg.github.com/grantmacken/alpine-xqerl/xq:$(GHPKG_VER)
.DEFAULT_GOAL := help

include inc/*

.PHONY: help
help: ## show this help	
	@cat $(MAKEFILE_LIST) | 
	grep -oP '^[a-zA-Z_-]+:.*?## .*$$' |
	sort |
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

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

