#
# Various utilities
#

.PHONY: tools_container_log_%
# show the log for a specific container common implementation
tools_container_log_%:
	kubectl logs $$(kubectl get pods --namespace athene2 | grep $* | awk '{ print $$1 }') --all-containers=true --namespace athene2 --follow

.PHONY: tools_dbsetup_log
# show the athene2 content provider log
tools_dbsetup_log: kubectl_use_context
	kubectl logs $$(kubectl get pods --namespace athene2 | grep dbsetup | awk '{ print $$1 }') --all-containers=true --namespace athene2 --follow

.PHONY: tools_athene2_app_log
# show the httpd log
tools_athene2_app_log: kubectl_use_context
	kubectl logs $$(kubectl get pods --namespace athene2 | grep athene2-app | awk '{ print $$1 }') --all-containers=true --namespace athene2 --follow

.PHONY: tools_editor_log
# show the editor log
tools_editor_log: kubectl_use_context
	kubectl logs $$(kubectl get pods --namespace athene2 | grep ^editor-renderer-app | awk '{ print $$1 }') --namespace athene2 --follow

.PHONY: tools_legacy_editor_log
# show the editor log
tools_legacy_editor_log: kubectl_use_context
	kubectl logs $$(kubectl get pods --namespace athene2 | grep legacy-editor-renderer-app | awk '{ print $$1 }') --namespace athene2 --follow
