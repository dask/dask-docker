ARG base

FROM $base/docker-stacks-foundation:lab

ARG release
ARG python

USER root

ENV PYTHON_VERSION=${python}
ENV DASK_VERSION=${release}

RUN echo "jovyan ALL = NOPASSWD : /usr/bin/apt-get , /usr/bin/apt" >> /etc/sudoers

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

RUN mamba install -y \
    python=${PYTHON_VERSION} \
    nomkl \
    cytoolz \
    dask==${DASK_VERSION} \
    lz4 \
    numpy \
    pandas \
    ipywidgets \
    cachey \
    streamz \
    jupyterlab \
    "dask-labextension>=5" \
    && mamba clean -tipy \
    && jupyter lab clean \
    && find /opt/conda/ -type f,l -name '*.a' -delete \
    && find /opt/conda/ -type f,l -name '*.pyc' -delete \
    && find /opt/conda/ -type f,l -name '*.js.map' -delete \
    && (find /opt/conda/lib/python*/site-packages/bokeh/server/static -type f,l -name '*.js' -not -name '*.min.js' -delete || echo "no bokeh static files to cleanup") \
    && rm -rf /opt/conda/pkgs

EXPOSE 8888

# jupyter server config pulled from upstream `base-notebook`
ADD https://raw.githubusercontent.com/jupyter/docker-stacks/main/images/base-notebook/jupyter_server_config.py /etc/jupyter/jupyter_server_config.py

USER root

# legacy jupyter notebook server support pulled from upstream `base-notebook`
RUN sed -re "s/c.ServerApp/c.NotebookApp/g" \
    /etc/jupyter/jupyter_server_config.py > /etc/jupyter/jupyter_notebook_config.py && \
    fix-permissions /etc/jupyter/

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

# HEALTHCHECK pulled from upstream `base-notebook`
HEALTHCHECK  --interval=15s --timeout=3s --start-period=5s --retries=3 \
    CMD wget -O- --no-verbose --tries=1 --no-check-certificate \
    http${GEN_CERT:+s}://localhost:8888${JUPYTERHUB_SERVICE_PREFIX:-/}api || exit 1

USER $NB_USER

ENTRYPOINT ["tini", "--", "/usr/bin/prepare.sh"]
CMD ["jupyter", "lab", '--NotebookApp.base_url="${NB_PREFIX:-/}"', '${JUPYTERLAB_ARGS}']
