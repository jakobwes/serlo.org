.PHONY: build
.ONESHELL:
# build docker images for local dependencies in the cluster
build: build_httpd build_php build_editor build_legacy_editor
	@eval $$(minikube docker-env)
	$(MAKE) -C $(infrastructure_repository)/container/dbsetup build_image
	$(MAKE) -C $(infrastructure_repository)/container/dbdump build_image

.PHONY: build_forced
.ONESHELL:
# build docker images for local dependencies in the cluster
build_forced: build_httpd_forced build_php_forced build_editor_forced build_legacy_editor_forced
	@eval $$(minikube docker-env)
	$(MAKE) -C $(infrastructure_repository)/container/dbsetup docker_build
	$(MAKE) -C $(infrastructure_repository)/container/dbdump docker_build

httpd_image=athene2-httpd

.PHONY: build_httpd
# build httpd image only if image is not already available
build_httpd:
	@eval $$(minikube docker-env) && \
		docker images | grep $(httpd_image) && echo "image $(httpd_image) already exists use build_image_forced" || $(MAKE) build_httpd_forced

.PHONY: build_httpd_forced
# build httpd docker image even when image is available
build_httpd_forced:
	@eval $$(minikube docker-env) && \
		cd packages/public/server && docker build -f docker/httpd/Dockerfile -t serlo/$(httpd_image) .

php_image=athene2-php

.PHONY: build_php_image
# build php image only if image is not already available
build_php:
	docker images | grep $(php_image) && echo "image $(php_image) already exists use build_image_forced" || $(MAKE) build_php_forced

.PHONY: build_php_forced
# build php docker image even when image is available
build_php_forced:
	@eval $$(minikube docker-env) && \
		cd packages/public/server && docker build -f docker/php/Dockerfile -t serlo/$(php_image) .

editor_image=athene2-editor-renderer

.PHONY: build_editor
# build editor renderer image only if image is not already available
build_editor:
	docker images | grep $(editor_image) && echo "image $(editor_image) already exists use build_editor_forced" || $(MAKE) build_editor_forced

.PHONY: build_editor_forced
# build editor renderer forced even when image is available 
build_editor_forced:
	# build image with remote docker
	@eval $$(minikube docker-env) && \
		docker build -f packages/public/editor-renderer/Dockerfile -t serlo/$(editor_image) .

legacy_editor_image=athene2-legacy-editor-renderer

.PHONY: build_legacy_editor
# build legacy editor renderer only if image is not already available
build_legacy_editor:
	docker images | grep $(legacy_editor_image) && echo "image $(legacy_editor_image) already exists use build_legacy_editor_forced" || $(MAKE) build_legacy_editor_forced

.PHONY: build_legacy_editor_forced
# build legacy_editor renderer forced even when image is available 
build_legacy_editor_forced:
	# build image with remote docker
	@eval $$(minikube docker-env) && \
		docker build -f packages/public/legacy-editor-renderer/Dockerfile -t serlo/$(legacy_editor_image) .

