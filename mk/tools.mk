#
# Various utilities
#

.PHONY: log_container_%
# show the log for a specific container common implementation
log_container_%: kubectl_use_context
	for pod in $$(kubectl get pods --namespace athene2 | grep ^$* | awk '{ print $$1 }') ; do \
		kubectl logs $$pod --all-containers=true --namespace athene2 | sed "s/^/$$pod\ /"; \
	done

.PHONY: log_dbsetup
# show the athene2 content provider log
log_dbsetup: kubectl_use_context
	kubectl logs $$(kubectl get pods --namespace athene2 | grep dbsetup | awk '{ print $$1 }') --namespace athene2 --follow

.PHONY: log_athene2_app
# show the httpd log
log_athene2_app: kubectl_use_context log_container_athene2-app

.PHONY: log_editor
# show the editor log
log_editor: kubectl_use_context log_container_editor-renderer

.PHONY: log_legacy_editor
# show the editor log
log_legacy_editor: kubectl_use_context log_container_varnish

.PHONY: log_varnish
# show the editor log
log_varnish: kubectl_use_context log_container_varnish
