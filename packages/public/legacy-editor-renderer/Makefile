image=athene2-legacy-editor-renderer

.PHONY: build_image
build_image:
	docker images | grep $(image) && echo "image $(image) already exists use build_image_forced" || $(MAKE) docker_build

.PHONY: docker_build
# build docker container
docker_build:
	cd ../../.. && docker build -f packages/public/legacy-editor-renderer/Dockerfile -t serlo/$(image) .
