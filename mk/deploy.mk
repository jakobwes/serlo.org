#
# Describes deployment to the serlo cluster.
#

# location of the current serlo database dump
export dump_location ?= gs://serlo_dev_terraform/sql-dumps/dump-2019-05-13.zip

resource_dbsetup = module.athene2_dbsetup.kubernetes_deployment.dbsetup-cronjob
resource_dbdump = module.athene2_dbdump.kubernetes_deployment.dbdump-cronjob

# set the appropriate docker environment
ifeq ($(env_name),minikube)
	DOCKER_ENV ?= $(shell minikube docker-env)
	env_folder = minikube/athene2
	athene2_host ?= https://de.serlo.local
else
    	DOCKER_ENV ?= ""
    	env_folder = live/$(env_name)
endif

ifeq ($(env_name),dev)
	athene2_host ?= https://de.serlo-development.dev/mathe
endif

ifeq ($(env_name),staging)
	athene2_host ?= https://de.serlo-staging.dev/mathe
endif

.PHONY: deploy_dbsetup
# force the deployment of the dbsetup cronjob
deploy_dbsetup:
	cd $(infrastructure_repository)/$(env_folder) && terraform taint $(resource_dbsetup) && $(MAKE) terraform_apply

.PHONY: deploy_dbdump
# force the deployment of the dbdump cronjob
deploy_dbdump:
	cd $(infrastructure_repository)/$(env_folder) && terraform taint $(resource_dbdump) && $(MAKE) terraform_apply


.NOTPARALLEL:
