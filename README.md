# Dask docker images

[![Docker build](https://github.com/dask/dask-docker/actions/workflows/build.yml/badge.svg)](https://github.com/dask/dask-docker/actions/workflows/build.yml)

| Image  | Description | Versions |
| ------------- | ------------- | ------------- |
| `ghcr.io/dask/dask`  | Base image to use for Dask scheduler and workers  |   [![][daskdev-dask-py310-release] ![][daskdev-dask-release] ![][daskdev-dask-latest] <br /> ![][daskdev-dask-py39-release] <br /> ![][daskdev-dask-py311-release]](https://github.com/dask/dask-docker/pkgs/container/dask)  |
| `ghcr.io/dask/dask-notebook`  | Jupyter Notebook image to use as helper entrypoint  | [![][daskdev-dask-notebook-py310-release] ![][daskdev-dask-notebook-release] ![][daskdev-dask-notebook-latest] <br /> ![][daskdev-dask-notebook-py39-release] <br /> ![][daskdev-dask-notebook-py311-release]](https://github.com/dask/dask-docker/pkgs/container/dask-notebook) |

[daskdev-dask-latest]: https://img.shields.io/badge/ghcr.io%2Fdask%2Fdask-latest-blue
[daskdev-dask-release]: https://img.shields.io/badge/ghcr.io%2Fdask%2Fdask-2024.9.1-blue
[daskdev-dask-py310-release]: https://img.shields.io/badge/ghcr.io%2Fdask%2Fdask-2024.9.1--py3.10-blue
[daskdev-dask-py311-release]: https://img.shields.io/badge/ghcr.io%2Fdask%2Fdask-2024.9.1--py3.11-blue
[daskdev-dask-notebook-latest]: https://img.shields.io/badge/ghcr.io%2Fdask%2Fdask--notebook-latest-blue
[daskdev-dask-notebook-release]: https://img.shields.io/badge/ghcr.io%2Fdask%2Fdask--notebook-2024.9.1-blue
[daskdev-dask-notebook-py310-release]: https://img.shields.io/badge/ghcr.io%2Fdask%2Fdask--notebook-2024.9.1--py3.10-blue
[daskdev-dask-notebook-py311-release]: https://img.shields.io/badge/ghcr.io%2Fdask%2Fdask--notebook-2024.9.1--py3.11-blue


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
This variable can also be used to specify custom conda channels; for example, to install the latest Dask conda nightly packages:

```bash
docker run -e EXTRA_CONDA_PACKAGES="-c dask/label/dev dask" daskdev/dask:latest
```

* `$EXTRA_PIP_PACKAGES` - Space separated list of additional python packages to install with pip.
* `$USE_MAMBA` - Boolean controlling whether to use conda or mamba to install `$EXTRA_CONDA_PACKAGES`.

The notebook image supports the following additional environment variables:

* `$JUPYTERLAB_ARGS` - Extra [arguments](https://jupyter-notebook.readthedocs.io/en/stable/config.html) to pass to the `jupyter lab` command.


## Building images

Docker compose provides an easy way to building all the images with the right context

```bash
cd build

# Use legacy builder as buildkit still doesn't support subdirectories when building from git repos
export DOCKER_BUILDKIT=0
export COMPOSE_DOCKER_CLI_BUILD=0

docker-compose build

# Just build one image e.g. notebook
docker-compose build notebook
```

### Cross building

The images can be cross-built using `docker buildx bake`. However buildx bake does not listen to `depends_on` (since in theory that is only a runtime not a build time constraint https://github.com/docker/buildx/issues/447). To work around this we first need to build the "docker-stacks-foundation" image.

```bash
cd build

# If you have permission to push to daskdev/
docker buildx bake --progress=plain --set *.platform=linux/arm64,linux/amd64 --push docker-stacks-foundation
docker buildx bake --progress=plain --set *.platform=linux/arm64,linux/amd64 --push

# If you don'tset DOCKERUSER to your dockerhub username.
export DOCKERUSER=holdenk
docker buildx bake --progress=plain --set *.platform=linux/arm64,linux/amd64 --set docker-stacks-foundation.tags.image=${DOCKERUSER}/docker-stacks-foundation:lab-py38 --push docker-stacks-foundation
docker buildx bake --progress=plain --set *.platform=linux/arm64,linux/amd64 --set scheduler.tags=${DOCKERUSER}/dask --set worker.tags=${DOCKERUSER}/dask --set notebook.tags=${DOCKERUSER}/dask-notebook --set docker-stacks-foundation.tags=${DOCKERUSER}/docker-stacks-foundation:lab-py38 --set notebook.args.base=${DOCKERUSER} --push
```

## Releasing

Building and releasing new image versions is done automatically.

- When a new Dask version is released the `watch-conda-forge` action will trigger and open a PR to update the latest release version in this repo.
- If images build successfully that PR will be automatically merged by the `automerge` action.
- When a PR like this is merged which updates the pinned release version a tag is automatically created to match that version by the `autotag` action.
- When tags are created a new image is built and pushed using the `docker/build-push-action` action.
