SHELL := bash
.DEFAULT_GOAL := help

DOCKER ?= docker
COMPOSE_FILE ?= docker-compose.yml
STACK ?= redis

.PHONY: help dev/up dev/down swarm/init swarm/token/worker swarm/token/manager swarm/leave net/create net/delete secret/create stack/up stack/down k3d/create k3d/delete k8s/deploy k8s/destroy

help: ## Affiche l’aide (liste des cibles)
@echo "Cibles disponibles :"
@awk -F:.*## /^[a-zA-Z0-9_/-]+:.*##/

dev/up: ## Build & start hello-grid for local dev
	@docker compose -f $(COMPOSE_FILE) up -d --build

dev/down: ## Stop and remove hello-grid local dev stack
	@docker compose -f $(COMPOSE_FILE) down -v

swarm/init: ## Initialize Docker Swarm if not active (idempotent)
	@state=$$($(DOCKER) info --format '{{.Swarm.LocalNodeState}}' 2>/dev/null) ; \
	if [ "$$state" != "active" ]; then \
		$(DOCKER) swarm init || true ; \
	else \
		echo "Swarm already active"; \
	fi

swarm/token/worker: ## Print worker join token
	@$(DOCKER) swarm join-token worker -q || true

swarm/token/manager: ## Print manager join token
	@$(DOCKER) swarm join-token manager -q || true

swarm/leave: ## Leave swarm (force)
	@$(DOCKER) swarm leave --force || true

net/create: ## Create overlay networks 'grid' and 'edge' (attachable)
	@$(DOCKER) network create -d overlay --attachable grid || true
	@$(DOCKER) network create -d overlay --attachable edge || true

net/delete: ## Remove 'grid' and 'edge' networks
	@$(DOCKER) network rm grid || true
	@$(DOCKER) network rm edge || true

stack/up: ## Deploy a stack from stack/$(STACK).yml (usage: make stack/up STACK=hello-grid)
	@[ -f stack/$(STACK).yml ] || (echo "stack/$(STACK).yml not found" >&2 && exit 1)
	@$(DOCKER) stack deploy -c stack/$(STACK).yml $(STACK)

stack/down: ## Remove a stack (usage: make stack/down STACK=hello-grid)
	@$(DOCKER) stack rm $(STACK)
