#!/bin/bash

set -x

if [ $UID -eq 0 ]; then
    # We start by adding extra apt packages, since pip modules may require system dependencies
    if [ "$EXTRA_APT_PACKAGES" ]; then
        echo "EXTRA_APT_PACKAGES environment variable found.  Installing."
        apt update -y
        apt install -y $EXTRA_APT_PACKAGES
    fi
    # Start the script over again, this time as a non-root user.
    exec sudo -E --user "$NB_USER" PATH="$PATH" "$0" -- "$@"
    exit # Don't continue execution if the exec fails.
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


exec start.sh jupyter lab ${JUPYTERLAB_ARGS}

