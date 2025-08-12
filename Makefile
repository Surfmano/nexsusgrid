SHELL := bash
.DEFAULT_GOAL := help

DOCKER ?= docker
COMPOSE_FILE ?= docker-compose.yml
STACK ?= redis

.PHONY: help dev/up dev/down swarm/init net/create net/delete secret/create stack/up stack/down k3d/create k3d/delete k8s/deploy k8s/destroy

help: ## Affiche l’aide (liste des cibles)
@echo "Cibles disponibles :"
@awk -F:.*## /^[a-zA-Z0-9_/-]+:.*##/

dev/up: ## Build & start hello-grid for local dev
	@docker compose -f $(COMPOSE_FILE) up -d --build

dev/down: ## Stop and remove hello-grid local dev stack
	@docker compose -f $(COMPOSE_FILE) down -v
