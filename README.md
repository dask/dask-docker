# Dask docker images

[![Docker build](https://github.com/dask/dask-docker/actions/workflows/build.yml/badge.svg)](https://github.com/dask/dask-docker/actions/workflows/build.yml)

| Image  | Description | Versions |
| ------------- | ------------- | ------------- |
| `daskdev/dask`  | Base image to use for Dask scheduler and workers  |   [![][daskdev-dask-py38-release] ![][daskdev-dask-release] ![][daskdev-dask-latest] <br /> ![][daskdev-dask-py39-release]](https://hub.docker.com/r/daskdev/dask/tags)  |
| `daskdev/dask-notebook`  | Jupyter Notebook image to use as helper entrypoint  | [![][daskdev-dask-notebook-py38-release] ![][daskdev-dask-notebook-release] ![][daskdev-dask-notebook-latest] <br /> ![][daskdev-dask-notebook-py39-release]](https://hub.docker.com/r/daskdev/dask-notebook/tags) |

[daskdev-dask-latest]: https://img.shields.io/badge/daskdev%2Fdask-latest-blue
[daskdev-dask-release]: https://img.shields.io/badge/daskdev%2Fdask-2021.11.1-blue
[daskdev-dask-py38-release]: https://img.shields.io/badge/daskdev%2Fdask-2021.11.1--py3.8-blue
[daskdev-dask-py39-release]: https://img.shields.io/badge/daskdev%2Fdask-2021.11.1--py3.9-blue
[daskdev-dask-notebook-latest]: https://img.shields.io/badge/daskdev%2Fdask--notebook-latest-blue
[daskdev-dask-notebook-release]: https://img.shields.io/badge/daskdev%2Fdask--notebook-2021.11.1-blue
[daskdev-dask-notebook-py38-release]: https://img.shields.io/badge/daskdev%2Fdask--notebook-2021.11.1--py3.8-blue
[daskdev-dask-notebook-py39-release]: https://img.shields.io/badge/daskdev%2Fdask--notebook-2021.11.1--py3.9-blue


## Example

An example `docker-compose.yml` file is included for starting a small cluster.

```bash
docker-compose up
```

Open the notebook using the URL that is printed by the output so it has the token.

On a new notebook run:

```python
from dask.distributed import Client
client = Client()  # The address is automatically set by the DASK_SCHEDULER_ADDRESS environment variable
client.ncores()
```

It should output something like this:

```python
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

```bash
cd build

docker-compose build

# Just build one image e.g. notebook
docker-compose build notebook
```

### Cross building

The images can be cross-built using `docker buildx bake`. However buildx bake does not listen to `depends_on` (since in theory that is only a runtime not a build time constraint https://github.com/docker/buildx/issues/447). To work around this we first need to build the "base-notebook" image.

```bash
cd build

# If you have permission to push to daskdev/
docker buildx bake --progress=plain --set *.platform=linux/arm64,linux/amd64 --push base-notebook
docker buildx bake --progress=plain --set *.platform=linux/arm64,linux/amd64 --push

# If you don'tset DOCKERUSER to your dockerhub username.
export DOCKERUSER=holdenk
docker buildx bake --progress=plain --set *.platform=linux/arm64,linux/amd64 --set base-notebook.tags.image=${DOCKERUSER}/base-notebook:lab-py38 --push base-notebook
docker buildx bake --progress=plain --set *.platform=linux/arm64,linux/amd64 --set scheduler.tags=${DOCKERUSER}/dask --set worker.tags=${DOCKERUSER}/dask --set notebook.tags=${DOCKERUSER}/dask-notebook --set base-notebook.tags=${DOCKERUSER}/base-notebook:lab-py38 --set notebook.args.base=${DOCKERUSER} --push
```

## Releasing

Building and releasing new image versions is done automatically.

- When a new Dask version is released the `watch-conda-forge` action will trigger and open a PR to update the latest release version in this repo.
- If images build successfully that PR will be automatically merged by the `automerge` action.
- When a PR like this is merged which updates the pinned release version a tag is automatically created to match that version by the `autotag` action.
- When tags are created a new image is built and pushed using the `docker/build-push-action` action.
