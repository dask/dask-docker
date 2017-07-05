#!/bin/bash

set -e
set -x

if [ -e "/opt/app/environment.yml" ]; then
    echo "environment.yml found. Installing packages"
    /opt/conda/bin/conda env update -n dask -f /opt/app/environment.yml
else
    echo "no environment.yml"
fi
