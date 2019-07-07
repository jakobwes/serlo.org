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
