#!/bin/bash

set -x

# We start by adding extra apt packages, since pip modules may require system dependencies
if [ "$EXTRA_APT_PACKAGES" ]; then
    echo "EXTRA_APT_PACKAGES environment variable found.  Installing."
    sudo apt-get update -y
    sudo apt-get install -y $EXTRA_APT_PACKAGES
fi

if [ "$USE_MAMBA" == "true" ]; then
    echo "USE_MAMBA enabled. Using mamba for all conda operations"
    CONDA_BIN="/opt/conda/bin/mamba"
else
    CONDA_BIN="/opt/conda/bin/conda"
fi

if [ -e "/opt/app/environment.yml" ]; then
    echo "environment.yml found. Installing packages"
    $CONDA_BIN env update -f /opt/app/environment.yml
else
    echo "no environment.yml"
fi

if [ "$EXTRA_CONDA_PACKAGES" ]; then
    echo "EXTRA_CONDA_PACKAGES environment variable found.  Installing."
    $CONDA_BIN install -y $EXTRA_CONDA_PACKAGES
fi

if [ "$EXTRA_PIP_PACKAGES" ]; then
    echo "EXTRA_PIP_PACKAGES environment variable found.  Installing".
    /opt/conda/bin/pip install $EXTRA_PIP_PACKAGES
fi
