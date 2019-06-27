#
# Makefile for local development for the serlo KPI project.
#

### Environment ###

# the environment type. use minikube for development
env_name ?=
# path to the serlo infrastructure repository
infrastructure_repository ?= ../infrastructure


.PHONY: _help
# print help as the default target. 
# since hte actual help recipe is quite long, it is moved
# to the bottom of this makefile.
_help: help

ifeq ($(env_name),minikube)
include mk/minikube.mk
export terraform_auto_approve=-auto-approve
else
include mk/gcloud.mk
#no auto approve in gcloud dev environment
export terraform_auto_approve=
endif

include mk/help.mk
include mk/test.mk
include mk/deploy.mk
include mk/tools.mk
include mk/build.mk

# forbid parallel building of prerequisites
.NOTPARALLEL:


.PHONY: project_deploy
# deploy the project to an already running cluster
project_deploy: build terraform_apply provide_athene2_content


.PHONY: project_launch
# launch the athene2 web site
project_launch: kubectl_use_context
	until kubectl logs $$(kubectl get pods --namespace athene2 | grep athene2-app | awk '{ print $$1 }' | head -n 1 ) -c athene2-php-container --namespace athene2 | grep -q "GET /index.php. 200" ; do echo wait for athene2-app to be ready ; sleep 10 ; done
	xdg-open $(athene2_host) 2>/dev/null >/dev/null &

# COLORS
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
BLUE   := $(shell tput -Txterm setaf 4)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)
DIM  := $(shell tput -Txterm dim)
