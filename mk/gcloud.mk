.PHONY: project_create
# create a project minikube cluster and deploy the project resources,
# all in one target.
project_create: project_deploy project_launch	

.PHONY: project_start
# initialize a minikube cluster and deploy this project,
# all in one target.
project_start: 
	$(MAKE) -C $(infrastructure_repository)/live/dev kubectl-use-context
	$(MAKE) project_launch


kubectl_use_context:
	kubectl config use-context gke_serlo-$(env_name)_europe-west3-a_serlo-$(env_name)-cluster


ifneq ($(env_name),minikube)
.PHONY: gcloud_dashboard
# show the gcloud dashboard
gcloud_dashboard:
	xdg-open https://console.cloud.google.com/kubernetes/workload?project=serlo-dev&workload_list_tablesize=50 2>/dev/null >/dev/null &

.PHONY: gcloud_init
# initialize gcloud in case cluster was newly created
gcloud_init:
	gcloud config set project serlo-$(env_name)
	gcloud container clusters get-credentials serlo-dev-cluster

.PHONY: gcloud_run_mysql_cloud_sql_proxy
# run the cloudsql proxy
gcloud_run_mysql_cloud_sql_proxy:
	$(MAKE) -C $(infrastructure_repository)/live/dev run-mysql-cloud-sql-proxy
endif

