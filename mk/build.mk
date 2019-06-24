.PHONY: build_images
.ONESHELL:
# build docker images for local dependencies in the cluster
build_images: build_httpd_image build_php_image build_yarn build_editor_image build_legacy_editor_image
	#build shared image for dbsetup
	$(MAKE) -C $(infrastructure_repository)/container/dbsetup build_image

.PHONY: build_images_forced
.ONESHELL:
# build docker images for local dependencies in the cluster
build_images_forced: build_httpd_image_forced build_php_image_forced build_yarn build_editor_image_forced build_legacy_editor_image_forced
	#build shared image for dbsetup
	$(MAKE) -C $(infrastructure_repository)/container/dbsetup docker_build

httpd_image=athene2-httpd

.PHONY: build_httpd_image
# build httpd image only if image is not already available
build_httpd_image:
	@eval $$(minikube docker-env) && \
		docker images | grep ^$(httpd_image) && echo "image $(httpd_image) already exists use build_image_forced" || $(MAKE) build_httpd_image_forced

.PHONY: build_httpd_image_forced
# build httpd docker image even when image is available
build_httpd_image_forced:
	@eval $$(minikube docker-env) && \
		cd packages/public/server && docker build -f docker/httpd/Dockerfile -t serlo/$(httpd_image) .

php_image=athene2-php

.PHONY: build_php_image
# build php image only if image is not already available
build_php_image:
	docker images | grep ^$(php_image) && echo "image $(php_image) already exists use build_image_forced" || $(MAKE) build_php_image_forced

.PHONY: build_php_image_forced
# build php docker image even when image is available
build_php_image_forced:
	@eval $$(minikube docker-env) && \
		cd packages/public/server && docker build -f docker/php/Dockerfile -t serlo/$(php_image) .

.PHONY: build_yarn
# build serlo.org javascript dependencies
build_yarn:
	# build dependencies with local docker
	@eval $$(minikube docker-env -u) && \
		docker run --rm -v $$(pwd):/tmp/src -w /tmp/src nikolaik/python-nodejs sh -c 'yarn --frozen-lockfile'
		#docker run --rm -v $$(pwd):/home/circleci/src -w /home/circleci/src circleci/node:10 sh -c 'sudo yarn --frozen-lockfile'

editor_image=athene2-editor-renderer

.PHONY: build_editor
# build editor renderer image only if image is not already available
build_editor_image:
	docker images | grep ^$(editor_image) && echo "image $(editor_image) already exists use build_image_forced" || $(MAKE) build_editor_forced

.PHONY: build_editor_forced
# build editor renderer forced even when image is available 
build_editor_image_forced:
	# build image with remote docker
	@eval $$(minikube docker-env) && \
		docker build -f packages/public/editor-renderer/Dockerfile -t serlo/$(editor_image) .


legacy_editor_image=athene2-editor-renderer

.PHONY: build_legacy_editor
# build legacy editor renderer only if image is not already available
build_legacy_editor_image:
	docker images | grep ^$(legacy_editor_image) && echo "image $(legacy_editor_image) already exists use build_image_forced" || $(MAKE) build_editor_forced

.PHONY: build_legacy_editor_forced
# build legacy_editor renderer forced even when image is available 
build_legacy_editor_image_forced:
	# build image with remote docker
	@eval $$(minikube docker-env) && \
		docker build -f packages/public/legacy-editor-renderer/Dockerfile -t serlo/$(legacy_editor_image) .

