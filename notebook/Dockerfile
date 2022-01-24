ARG base

FROM $base/base-notebook:lab

ARG release
ARG python

USER root

ENV PYTHON_VERSION=${python}
ENV DASK_VERSION=${release}

RUN apt-get update \
    && apt-get install -yq --no-install-recommends curl graphviz git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# We don't use TARGETARCH so as to support non-buildkit builds
RUN MAGICARCH=$(dpkg --print-architecture) && \
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/${MAGICARCH}/kubectl" && \
    mkdir -p /usr/local/bin && \
    mv ./kubectl /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    kubectl version --client

USER $NB_USER

RUN conda install mamba -n base -c conda-forge --yes
RUN mamba install --yes python=${PYTHON_VERSION} nomkl \
    && mamba install --yes \
    python-blosc \
    cytoolz \
    dask==${DASK_VERSION} \
    lz4 \
    numpy==1.21.1 \
    pandas==1.3.0 \
    ipywidgets \
    cachey \
    streamz \
    dask-labextension>=5 \
    && pip install dask-kubernetes \
    && mamba clean -tipsy \
    && jupyter lab clean \
    && jlpm cache clean \
    && npm cache clean --force \
    && find /opt/conda/ -type f,l -name '*.a' -delete \
    && find /opt/conda/ -type f,l -name '*.pyc' -delete \
    && find /opt/conda/ -type f,l -name '*.js.map' -delete \
    && (find /opt/conda/lib/python*/site-packages/bokeh/server/static -type f,l -name '*.js' -not -name '*.min.js' -delete || echo "no bokeh static files to cleanup") \
    && rm -rf /opt/conda/pkgs

USER root

# Create the /opt/app directory, and assert that Jupyter's NB_UID/NB_GID values
# haven't changed.
RUN mkdir /opt/app \
    && if [ "$NB_UID" != "1000" ] || [ "$NB_GID" != "100" ]; then \
    echo "Jupyter's NB_UID/NB_GID changed, need to update the Dockerfile"; \
    exit 1; \
    fi

# Copy over the example as NB_USER. Unfortuantely we can't use $NB_UID/$NB_GID
# in the `--chown` statement, so we need to hardcode these values.
COPY --chown=1000:100 examples/ /home/$NB_USER/examples
COPY prepare.sh /usr/bin/prepare.sh

ENTRYPOINT ["tini", "--", "/usr/bin/prepare.sh"]
