SHELL=/bin/bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
.DEFAULT_GOAL := help
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
include .env
XQERL_IMAGE := docker.pkg.github.com/grantmacken/alpine-xqerl/xq:$(GHPKG_VER)
include inc/*

.PHONY: help
help: ## show this help	
	@cat $(MAKEFILE_LIST) | 
	grep -oP '^[a-zA-Z_-]+:.*?## .*$$' |
	sort |
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: init
init: clean
	pushd $(HOME)/.local/bin &>/dev/null
	@if [[ ! -L xq ]]
	then
	echo ' - create link to bin/xq '
	ln -s $(CURDIR)/bin/xq 
	echo -n 'which xq: '
	which xq
	popd &>/dev/null
	@$(MAKE) --silent pull

.PHONY: clean
clean:
	@rm -f $(Escripts)
	@rm -f $(TmpData)

