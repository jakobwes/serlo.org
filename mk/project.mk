.PHONY: project_deploy
# deploy the project to an already running cluster
ifeq ($(env_name),minikube)
project_deploy: docker_minikube_setup terraform_apply project_launch

.PHONY: project_create
# create a project minikube cluster and deploy the project resources,
# all in one target.
project_create: minikube_create project_deploy	

.PHONY: project_start
# initialize a minikube cluster and deploy this project,
# all in one target.
project_start: minikube_start project_launch

project_deploy: terraform_apply project_launch
endif

.PHONY: project_launch
# launch the athene2 web site
project_launch: kubectl_use_context
	until kubectl logs $$(kubectl get pods --namespace athene2 | grep athene2-app | awk '{ print $$1 }' | head -n 1 ) -c athene2-php-container --namespace athene2 | grep -q "GET /index.php. 200" ; do echo wait for athene2-app to be ready ; sleep 10 ; done
	xdg-open $(athene2_host) 2>/dev/null >/dev/null &
