.PHONY: pull
pull: pull-container-helpers
	@docker pull docker.pkg.github.com/grantmacken/alpine-xqerl/xq:$(GHPKG_VER) &> /dev/null
	@docker pull docker.pkg.github.com/grantmacken/alpine-scour/scour:0.0.2 &> /dev/null
	@docker pull docker.pkg.github.com/grantmacken/alpine-zopfli/zopfli:0.0.1 &> /dev/null
	@docker pull docker.pkg.github.com/grantmacken/alpine-cmark-gfm/cmark-gfm:0.29.0 &> /dev/null
	@docker pull docker.pkg.github.com/grantmacken/alpine-htmltidy/htmltidy5:5.7.28 &> /dev/null

.PHONY: pull-container-helpers
pull-container-helpers:
	@docker pull docker.pkg.github.com/grantmacken/alpine-scour/scour:0.0.2 &> /dev/null
	@docker pull docker.pkg.github.com/grantmacken/alpine-zopfli/zopfli:0.0.1 &> /dev/null
	@docker pull docker.pkg.github.com/grantmacken/alpine-cmark-gfm/cmark-gfm:0.29.0 &> /dev/null
	@docker pull docker.pkg.github.com/grantmacken/alpine-htmltidy/htmltidy5:5.7.28 &> /dev/null



MustHaveNetwork = docker network list --format "{{.Name}}" | \
 grep -q $(1) || docker network create $(NETWORK) &>/dev/null

MustHaveVolume = docker volume list --format "{{.Name}}" | \
 grep -q $(1) || docker volume create --driver local --name $(1) &>/dev/null
#
# volume mounts
MountCode := type=volume,target=$(XQERL_HOME)/code,source=xqerl-compiled-code
MountData := type=volume,target=$(XQERL_HOME)/data,source=xqerl-database
MountAssets := type=volume,target=$(XQERL_HOME)/priv/static/assets,source=static-assets

.PHONY: up
up: clean
	@echo '| $(@): $(XQERL_IMAGE) |'
	@if ! docker container inspect -f '{{.State.Running}}' $(RUN_NAME) &>/dev/null
	then 
	@$(call MustHaveNetwork,$(NETWORK))
	@$(call MustHaveVolume,xqerl-compiled-code)
	@$(call MustHaveVolume,xqerl-database)
	@$(call MustHaveVolume,static-assets)
	docker run --rm \
	--name  $(RUN_NAME) \
	--env "TZ=$(TZ)" \
	--env "NAME=$(NAME)" \
	--hostname $(HOST_NAME) \
	--network $(NETWORK) \
	--mount $(MountCode) \
	--mount $(MountData) \
  --mount $(MountAssets) \
	--publish $(HOST_PORT):8081 \
	--detach \
	$(XQERL_IMAGE)	
	fi
	@while ! docker exec xq xqerl eval 'application:ensure_all_started(xqerl).' | grep -oP 'ok' &>/dev/null
	do
	echo ' ... '
	sleep 1 
	done
	@echo -n ' - $(RUN_NAME) running: ' 
	docker container inspect -f '{{.State.Running}}' $(RUN_NAME)
	@echo -n ' - xqerl application all started: '
	docker exec xq xqerl eval 'application:ensure_all_started(xqerl).' | grep -oP 'ok'
	echo ' - docker network available [ $(NETWORK) ]'
	echo ' - docker volume available [ xqerl-compiled-code ]'
	echo ' - docker volume available [ xqerl-database ]'
	echo ' - docker volume available [ static-assets ]'
	@$(MAKE) --silent escripts
	@$(MAKE) --silent main-modules

.PHONY: down
down:
	@echo '| $(@): $(XQERL_IMAGE) |'
	@if docker container inspect -f '{{.State.Running}}' $(RUN_NAME) &>/dev/null
	then
	docker stop $(RUN_NAME)
	fi
	echo ' ok: $(RUN_NAME) stopped '
	@rm -f $(Escripts)

