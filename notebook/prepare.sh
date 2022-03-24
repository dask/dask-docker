#!/bin/bash

set -x

# We start by adding extra apt packages, since pip modules may require system dependencies
if [ "$EXTRA_APT_PACKAGES" ]; then
    echo "EXTRA_APT_PACKAGES environment variable found.  Installing."
    sudo apt-get update -y
    sudo apt-get install -y $EXTRA_APT_PACKAGES
fi

if [ -e "/opt/app/environment.yml" ]; then
    echo "environment.yml found. Installing packages"
    /opt/conda/bin/conda env update -f /opt/app/environment.yml
else
    echo "no environment.yml"
fi

if [ "$EXTRA_CONDA_PACKAGES" ]; then
    echo "EXTRA_CONDA_PACKAGES environment variable found.  Installing."
    /opt/conda/bin/conda install -y $EXTRA_CONDA_PACKAGES
fi

if [ "$EXTRA_PIP_PACKAGES" ]; then
    echo "EXTRA_PIP_PACKAGES environment variable found.  Installing".
    /opt/conda/bin/pip install $EXTRA_PIP_PACKAGES
fi


# Execute the jupyterlab as specified.
exec start.sh jupyter lab --NotebookApp.base_url="${NB_PREFIX:-/}" ${JUPYTERLAB_ARGS}
