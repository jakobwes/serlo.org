#
# Various utilities
#

.PHONY: tools_container_log_%
# show the log for a specific container common implementation
tools_container_log_%:
	for pod in $$(kubectl get pods --namespace athene2 | grep ^$* | awk '{ print $$1 }') ; do \
		kubectl logs $$pod --all-containers=true --namespace athene2 | sed "s/^/$$pod/"; \
	done

.PHONY: tools_dbsetup_log
# show the athene2 content provider log
tools_dbsetup_log: kubectl_use_context
	kubectl logs $$(kubectl get pods --namespace athene2 | grep dbsetup | awk '{ print $$1 }') --all-containers=true --namespace athene2 --follow

.PHONY: tools_athene2_app_log
# show the httpd log
tools_athene2_app_log: kubectl_use_context tools_container_log_athene2-app

.PHONY: tools_editor_log
# show the editor log
tools_editor_log: kubectl_use_context tools_container_log_editor-renderer

.PHONY: tools_legacy_editor_log
# show the editor log
tools_legacy_editor_log: kubectl_use_context tools_container_log_legacy-editor-renderer
