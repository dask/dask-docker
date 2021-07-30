# Dask docker images

[![Build Status](https://travis-ci.com/dask/dask-docker.svg?branch=main)](https://travis-ci.com/dask/dask-docker)

Docker images for dask-distributed.

1. Base image to use for dask scheduler and workers
2. Jupyter Notebook image to use as helper entrypoint

This images are built primarily for the [Dask Helm Chart](https://github.com/dask/helm-chart)
but they should work for more use cases.

## How to use / test

A helper docker-compose file is provided to test functionality.

```
docker-compose up
```

Open the notebook using the URL that is printed by the output so it has the token.

On a new notebook run:

```python
from dask.distributed import Client
client = Client('scheduler:8786')
client.ncores()
```

It should output something like this:

```
{'tcp://172.23.0.4:41269': 4}
```

### Cross building

The images can be cross-built using docker buildx bake. However buildx bake does not listen to `depends_on` (since in theory that is only a runtime not a build time constraint https://github.com/docker/buildx/issues/447). To work around this we first need to build the "base-notebook" image.

```
# If you have permission to push to daskdev/
docker buildx bake --progress=plain --set *.platform=linux/arm64,linux/amd64 --push base-notebook
docker buildx bake --progress=plain --set *.platform=linux/arm64,linux/amd64 --push
# If you don'tset DOCKERUSER to your dockerhub username.
export DOCKERUSER=holdenk
docker buildx bake --progress=plain --set *.platform=linux/arm64,linux/amd64 --set base-notebook.tags.image=${DOCKERUSER}/base-notebook:lab-py38 --push base-notebook
docker buildx bake --progress=plain --set *.platform=linux/arm64,linux/amd64 --set scheduler.tags=${DOCKERUSER}/dask --set worker.tags=${DOCKERUSER}/dask --set notebook.tags=${DOCKERUSER}/dask-notebook --set base-notebook.tags=${DOCKERUSER}/base-notebook:lab-py38 --set notebook.args.base=${DOCKERUSER} --push
```

## Environment Variables

The following environment variables are supported for both the base and notebook images:

* `$EXTRA_APT_PACKAGES` - Space separated list of additional system packages to install with apt.
* `$EXTRA_CONDA_PACKAGES` - Space separated list of additional packages to install with conda.
* `$EXTRA_PIP_PACKAGES` - Space separated list of additional python packages to install with pip.

The notebook image supports the following additional environment variables:

* `$JUPYTERLAB_ARGS` - Extra [arguments](https://jupyter-notebook.readthedocs.io/en/stable/config.html) to pass to the `jupyter lab` command.


## Building images

Docker compose provides an easy way to building all the images with the right context

```
docker-compose build

# Just build one image e.g. notebook
docker-compose build notebook
```

## Releasing

Building and releasing new image versions is done automatically via Travis CI. When new commits are
pushed to the ``main`` branch images are built with the `dev` tag and pushed to Docker Hub.

When a new version of Dask is released a PR should be raised to bump the versions in
the `Dockerfile`s and then once that has been merged a new tag matching the Dask version
should be pushed. Travis will then build the images and push them with version tags and update
`latest` too.

```console
$ git commit --allow-empty -m "bump version to x.x.x"
$ git tag -a x.x.x -m 'Version x.x.x'
$ git push upstream main --tags
```
