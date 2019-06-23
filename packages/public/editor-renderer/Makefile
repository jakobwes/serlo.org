image=athene2-editor-renderer

.PHONY: build_image
build_image:
	docker images | grep $(image) && echo "image $(image) already exists use build_image_forced" || $(MAKE) docker_build

.PHONY: docker_build
# build docker container
docker_build:
	# build dependencies with local docker
	@eval $$(minikube docker-env -u) && \
		cd ../../.. && \
		docker run --rm -v $$(pwd):/home/circleci/src -w /home/circleci/src circleci/node:10 sh -c 'sudo yarn --frozen-lockfile'
	# build image with remote docker
	@eval $$(minikube docker-env) && \
		cd ../../.. && \
		docker build -f packages/public/editor-renderer/Dockerfile --no-cache -t serlo/$(image) .
