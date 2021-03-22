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

Building and releasing new image versions is done automatically.

- When a new Dask version is released the `watch-conda-forge` action will trigger and open a PR to update the latest release version in this repo.
- If images build successfully that PR will be automatically merged by the `automerge` action.
- When a PR like this is merged which updates the pinned release version a tag is automatically created to match that version by the `autotag` action.
- When tags are created a new image is built and pushed using the `docker/build-push-action` action.
