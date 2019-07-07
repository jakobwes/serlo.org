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
log_dbsetup: log__container_dbsetup

.PHONY: log_dbsetup
# show the athene2 content provider log
log_dbdump: log_container_dbdump

.PHONY: log_athene2_app
# show the httpd log
log_athene2_app: log_container_athene2-app

.PHONY: log_editor
# show the editor log
log_editor: log_container_editor-renderer

.PHONY: log_legacy_editor
# show the legacy editor log
log_legacy_editor: log_container_varnish

.PHONY: log_varnish
# show the varnish log
log_varnish: log_container_varnish
