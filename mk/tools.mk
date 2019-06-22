#
# Various utilities
#

.PHONY: tools_container_log_%
# show the log for a specific container common implementation
tools_container_log_%:
	kubectl logs $$(kubectl get pods --namespace athene2 | grep $* | awk '{ print $$1 }') --all-containers=true --namespace athene2 --follow

.PHONY: tools_dbsetup_log
# show the athene2 content provider log
tools_dbsetup_log: kubectl_use_context tools_container_log_dbsetup
	kubectl logs $$(kubectl get pods --namespace kpi | grep dbsetup | awk '{ print $$1 }') --all-containers=true --namespace kpi --follow

.PHONY: tools_athene2_app_log
# show the httpd log
tools_athene2_app_log: 
	kubectl logs $$(kubectl get pods --namespace athene2 | grep athene2-app | awk '{ print $$1 }') --all-containers=true --namespace athene2 --follow
