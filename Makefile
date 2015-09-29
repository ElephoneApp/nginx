# vim: ts=4 sw=4 noexpandtab
include env_make
# SHELL  := /bin/bash

NS = elephone
VERSION ?= latest

REPO = nginx
NAME = elephone-nginx
INSTANCE = default

.PHONY: build push shell run start stop rm release

build:
	@echo + Building
	-@docker build -t $(NS)/$(REPO):$(VERSION) .

push:
	@echo + Push
	-@docker push $(NS)/$(REPO):$(VERSION)

shell:
	docker exec -it $(NAME)-$(INSTANCE) bash

run: rm
	@echo + Run
	@echo docker run -d --name $(NAME)-$(INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION)
	-@docker run -d --name $(NAME)-$(INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION)

start:
	@echo + Start
	-@docker stop $(NAME)-$(INSTANCE)

stop:
	@echo + Stop
	-@docker stop $(NAME)-$(INSTANCE)

rm: stop
	@echo + Remove
	-@docker rm $(NAME)-$(INSTANCE)

release: build
	@echo + Release
	-@make push -e VERSION=$(VERSION)
