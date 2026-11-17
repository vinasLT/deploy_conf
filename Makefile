# Usage:
#   make up                    # dev (default), local
#   make deploy ENV=prod       # prod server
#   make deploy ENV=demo       # demo server (uses the Infisical `prod` environment)
#
# Secrets (and CONTAINER_TAG, which selects the image tags) come from Infisical.
# In CI export INFISICAL_TOKEN and INFISICAL_PROJECT_ID; locally the CLI login and
# .infisical.json are used.

ENV ?= dev

ifeq ($(ENV),prod)
  COMPOSE_FILE ?= prod/docker-compose.yml
  INFISICAL_ENV ?= prod
else ifeq ($(ENV),demo)
  COMPOSE_FILE ?= demo/docker-compose.demo.yml
  INFISICAL_ENV ?= prod
else ifeq ($(ENV),dev)
  COMPOSE_FILE ?= dev/docker-compose.dev.yml
  INFISICAL_ENV ?= dev
else
  $(error Unknown ENV '$(ENV)', use dev, demo or prod)
endif

INFISICAL_DOMAIN ?= https://eu.infisical.com
INFISICAL_RUN = infisical run --env=$(INFISICAL_ENV) --domain=$(INFISICAL_DOMAIN) \
	$(if $(INFISICAL_PROJECT_ID),--projectId=$(INFISICAL_PROJECT_ID)) \
	$(if $(INFISICAL_TOKEN),--token=$(INFISICAL_TOKEN)) --
COMPOSE = docker compose -f $(COMPOSE_FILE)

.PHONY: up deploy down logs restart clean-volumes pull help

pull:
	$(INFISICAL_RUN) $(COMPOSE) pull

# In-place update: only changed containers are recreated, services removed from
# compose are stopped by --remove-orphans.
up: pull
	$(INFISICAL_RUN) $(COMPOSE) up -d --remove-orphans

deploy: up

down:
	$(COMPOSE) down --remove-orphans

logs:
	$(COMPOSE) logs -f

restart: down up

clean-volumes:
	$(COMPOSE) down -v

help:
	@echo "Available commands:"
	@echo "  up            - Pull images and start/update containers"
	@echo "  deploy        - Same as up (used by CI)"
	@echo "  down          - Stop and remove containers"
	@echo "  logs          - Follow container logs"
	@echo "  restart       - Stop and start containers"
	@echo "  clean-volumes - Stop containers and remove volumes"
	@echo "  pull          - Pull latest images"
	@echo "  help          - Show this help message"
	@echo ""
	@echo "Variables:"
	@echo "  ENV           - dev (default), demo or prod"
	@echo "  COMPOSE_FILE  - Override the compose file (default depends on ENV)"
	@echo "  INFISICAL_ENV - Override the Infisical environment (dev for dev, prod for demo/prod)"
