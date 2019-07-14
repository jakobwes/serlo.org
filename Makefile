#
# Makefile for local development for the serlo KPI project.
#

### Environment ###

# the environment type. use minikube for development
env_name ?=
# path to the serlo infrastructure repository
infrastructure_repository ?= ../infrastructure

# location of the current serlo database dump
export dump_location ?= gs://serlo_dev_terraform/sql-dumps/dump-2019-05-13.zip

.PHONY: _help
# print help as the default target. 
# since hte actual help recipe is quite long, it is moved
# to the bottom of this makefile.
_help: help

ifeq ($(env_name),minikube)
export env_folder = minikube
export terraform_auto_approve=-auto-approve
include mk/minikube.mk
else
export env_folder = live/$(env_name)
include mk/gcloud.mk
#no auto approve in gcloud dev environment
export terraform_auto_approve=
endif

include mk/help.mk
include mk/terraform.mk
include mk/test.mk
include mk/deploy.mk
include mk/tools.mk
include mk/build.mk
include mk/project.mk

# forbid parallel building of prerequisites
.NOTPARALLEL:

# COLORS
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
BLUE   := $(shell tput -Txterm setaf 4)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)
DIM  := $(shell tput -Txterm dim)
