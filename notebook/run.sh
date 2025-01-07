#!/bin/bash

jupyter lab --NotebookApp.base_url="${NB_PREFIX:-/}" --NotebookApp.allow_origin="*" ${JUPYTERLAB_ARGS}
