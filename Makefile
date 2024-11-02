
build-docker:
	docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
	docker buildx create --name dask-builder || true
	docker buildx bake --file bakefile.hcl --builder=dask-builder dask

print-docker:
	docker buildx bake --file bakefile.hcl dask --print