# Dask docker images

[![Build Status](https://travis-ci.com/dask/dask-docker.svg?branch=master)](https://travis-ci.com/dask/dask-docker)

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

## Building images

Docker compose provides an easy way to building all the images with the right context

```
docker-compose build

# Just build one image e.g. notebook
docker-compose build notebook
```

## Releasing

Building and releasing new image versions is done automatically via Travis CI. When new commits are
pushed to the master branch images are built with the `dev` tag and pushed to Docker Hub.

When a new version of Dask is released a PR should be raised to bump the versions in
the `Dockerfile`s and then once that has been merged a new tag matching the Dask version
should be pushed. Travis will then build the images and push them with version tags and update
`latest` too.

```console
$ git commit --allow-empty -a -m "bump version to x.x.x"
$ git tag -a x.x.x -m 'Version x.x.x'
$ git push upstream master --tags
```
