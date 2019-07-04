#
# Describes deployment to the serlo cluster.
#

# location of the current serlo database dump
export dump_location ?= gs://serlo_dev_terraform/sql-dumps/dump-2019-05-13.zip

resource_dbsetup = module.athene2_dbsetup.kubernetes_deployment.dbsetup-cronjob

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

.PHONY: terraform_init
# initialize terraform in the infrastructure repository
terraform_init:
	$(MAKE) -C $(infrastructure_repository)/$(env_folder) terraform_init

.PHONY: terraform_plan
# plan the terraform provisioning in the cluster
terraform_plan: 
	$(MAKE) -C $(infrastructure_repository)/$(env_folder) terraform_plan

.PHONY: terraform_apply
# apply the terraform provisoining in the cluster
terraform_apply:
	if [[ "$$env_name" == "minikube" ]] ; then $(MAKE) build_images; fi
	$(MAKE) -C $(infrastructure_repository)/$(env_folder) terraform_apply

# download the database dump
tmp/dump.zip:
	mkdir -p tmp
	echo "downloading latest mysql dump from gcloud"
	gsutil cp $(dump_location) $@

# unzip database dump
tmp/dump.sql: tmp/dump.zip
	rm -f tmp/dump.sql
	unzip $< -d tmp

.PHONY: provide_athene2_content
# upload the current database dump to the content provider container
provide_athene2_content: tmp/dump.sql
	bash scripts/setup-athene2-db.sh


.PHONY: deploy_dbsetup
# force the deployment of the dbsetup cronjob
deploy_dbsetup:
	cd $(infrastructure_repository)/$(env_folder) && terraform taint $(resource_dbsetup) && $(MAKE) terraform_apply


.NOTPARALLEL:
