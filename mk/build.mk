sharedimages_repository ?= ../infrastructure-images

.PHONY: build_minikube
.ONESHELL:
# build docker images for local dependencies in the cluster
build_minikube:
	@eval $$(minikube docker-env)
	$(MAKE) build_httpd_minikube build_php_minikube build_editor_minikube build_legacy_editor_minikube
	$(MAKE) -C $(sharedimages_repository)/container/dbsetup docker_build_minikube
	$(MAKE) -C $(sharedimages_repository)/container/dbdump docker_build_minikube
	$(MAKE) -C $(sharedimages_repository)/container/varnish docker_build_minikube

.PHONY: build
.ONESHELL:
# build docker images
build: build_httpd build_php build_editor build_legacy_editor
	$(MAKE) -C $(sharedimages_repository)/container/dbsetup docker_build
	$(MAKE) -C $(sharedimages_repository)/container/dbdump docker_build
	$(MAKE) -C $(sharedimages_repository)/container/varnish docker_build

httpd_image=athene2-httpd

.PHONY: build_httpd_minikube
# build httpd image only if image is not already available
build_httpd_minikube:
	@eval $$(minikube docker-env) && \
		docker images | grep $(httpd_image) && echo "image $(httpd_image) already exists use build_httpd" || $(MAKE) build_httpd

.PHONY: build_httpd
# build httpd docker image even when image is available
build_httpd:
	cd packages/public/server && docker build -f docker/httpd/Dockerfile -t serlo/$(httpd_image) .

php_image=athene2-php

.PHONY: build_php_minikube
# build php image only if image is not already available
build_php_minikube:
	@eval $$(minikube docker-env) && \
	docker images | grep $(php_image) && echo "image $(php_image) already exists use build_php" || $(MAKE) build_php

.PHONY: build_php
# build php docker image even when image is available
build_php:
	cd packages/public/server && docker build -f docker/php/Dockerfile -t serlo/$(php_image) .

editor_image=editor-renderer

.PHONY: build_editor_minikube
# build editor renderer image only if image is not already available
build_editor_minikube:
	@eval $$(minikube docker-env) && \
	docker images | grep $(editor_image) && echo "image $(editor_image) already exists use build_editor" || $(MAKE) build_editor

.PHONY: build_editor
# build editor renderer forced even when image is available 
build_editor:
	docker build -f packages/public/editor-renderer/Dockerfile -t serlo/$(editor_image) .

legacy_editor_image=legacy-editor-renderer

.PHONY: build_legacy_editor_minikube
# build legacy editor renderer only if image is not already available
build_legacy_editor_minikube:
	@eval $$(minikube docker-env) && \
	docker images | grep $(legacy_editor_image) && echo "image $(legacy_editor_image) already exists use build_legacy_editor" || $(MAKE) build_legacy_editor

.PHONY: build_legacy_editor
# build legacy_editor renderer forced even when image is available 
build_legacy_editor:
	docker build -f packages/public/legacy-editor-renderer/Dockerfile -t serlo/$(legacy_editor_image) .

