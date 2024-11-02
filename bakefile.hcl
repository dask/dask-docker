variable "GH_REGISTRY" {
    #default = "ghcr.io/dask"
    default = "ghcr.io/ryanolee"
}

variable "DOCKER_HUB_REGISTRY" {
    #default = "daskdev"
}

variable "RELEASE" {
    default = "2024.9.1"
}

variable "STABLE" {
    default = "true"
}

variable "DEFAULT_PY_VERSION" {
    default = "3.10"
}

function "tags" {
    params = [
        image,
        label
    ]
    result = [
        "${GH_REGISTRY}/${image}:${label}",
        #"${DOCKER_HUB_REGISTRY}/${image}:${label}"
    ]
}

function "tag_stable" {
    params = [
        image,
        release,
        py_version
    ]
    result = concat(
        tags(image, "${release}-py${py_version}"),
        tags(image, "latest-py${py_version}"),
        equal(py_version, DEFAULT_PY_VERSION) ? tags(image, "latest") : [],
        equal(py_version, DEFAULT_PY_VERSION) ? tags(image, release) : []
    )
}

function "tag_dev" {
    params = [
        image,
        py_version
    ]
    result = concat(
        tags(image, "dev-py${py_version}"),
        equal(py_version, DEFAULT_PY_VERSION) ? tags(image, "dev") : []
    )
}

function "tag" {
    params = [
        image,
        release,
        py_version
    ]
    result = equal(STABLE, "true") ? tag_stable(image, release, py_version) : tag_dev(image, py_version)
}

group "dask" {
    targets = ["base", "notebook"]
}

target "base" {
    context = "./base"
    dockerfile = "Dockerfile"
    platforms = ["linux/amd64", "linux/arm64"]
    matrix = {
        py_version = ["3.10", "3.11", "3.12"]
    }
    args = {
        python = py_version
        release = RELEASE
    }
    
    name = "dask-${replace(py_version, ".", "")}"
    tags = tag(
        "dask",
        RELEASE,
        py_version
    )
}

target "notebook-base" {
    context = "https://github.com/jupyter/docker-stacks.git#main:images/docker-stacks-foundation"
    dockerfile = "Dockerfile"
    platforms = ["linux/amd64", "linux/arm64"]
    matrix = {
        py_version = ["3.12"]
    }
    args = {
        PYTHON_VERSION = py_version
    }
    name = "notebook-base-${replace(py_version, ".", "")}"
}

# Pre 311 builds do not work due to https://github.com/jupyter/docker-stacks/issues/2146#issuecomment-2382315848
# patch works for now. This can be collapsed into "notebook-base" once a fix has been released
target "notebook-base-pre-311" {
    context = "https://github.com/jupyter/docker-stacks.git#5365b9f79fa4ffbb20f10133cc6ac5bec5046302:images/docker-stacks-foundation"
    dockerfile = "Dockerfile"
    platforms = ["linux/amd64", "linux/arm64"]
    matrix = {
        py_version = ["3.10", "3.11"]
    }
    args = {
        PYTHON_VERSION = py_version
    }
    name = "notebook-base-${replace(py_version, ".", "")}"
}

target "notebook" {
    context = "./notebook"
    dockerfile = "Dockerfile"
    platforms = ["linux/amd64", "linux/arm64"]
    matrix = {
        py_version = ["3.12", "3.11", "3.10"]
    }
    args = {
        python = py_version
        release = RELEASE
        base = "baseapp"
    }

    contexts = {
        baseapp = "target:notebook-base-${replace(py_version, ".", "")}"
    }

    name = "dask-notebook-${replace(py_version, ".", "")}"
    tags = tag(
        "dask-notebook",
        RELEASE,
        py_version
    )
}
