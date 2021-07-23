FROM condaforge/miniforge3:latest

SHELL ["/bin/bash", "-c"]

ENV PATH /opt/conda/bin:$PATH

RUN conda install --yes nomkl cytoolz cmake tini
RUN conda install --yes mamba


RUN apt-get update --force-yes  -y --fix-missing && \
    apt-get install --force-yes  -y wget bzip2 ca-certificates libglib2.0-0 libxext6 libsm6 libxrender1 git mercurial subversion && \
    apt-get install --force-yes -y build-essential cmake libcurl4 libcurl4-openssl-dev libblosc-dev libblosc1 python3-blosc python3-dev && \
    apt-get upgrade --force-yes -y && \
    apt-get clean

RUN mamba install --yes python==3.8.6 \
    && mamba install --yes \
    cytoolz \
    dask==2021.7.0 \
    lz4 \
    numpy==1.21.1 \
    pandas==1.3.0 \
    tini==0.18.0 \
    scikit-build \
    python-blosc=1.9.2 \
    pyzmq \
    && mamba install --yes s3fs gcsfs dropboxdrivefs requests dropbox paramiko adlfs pygit2 pyarrow\
    && mamba install --yes bokeh \
    && (mamba install --yes aiohttp==3.7.1 || pip install aiohttp==3.7.1 ) \
    && (mamba install --yes jupyter-server-proxy || pip install jupyter-server-proxy) \
    && (mamba install --yes llvmlite numba ) \
    && (mamba install --yes fastparquet || pip install fastparquet) \
    && find /opt/conda/ -type f,l -name '*.a' -delete \
    && find /opt/conda/ -type f,l -name '*.pyc' -delete \
    && find /opt/conda/ -type f,l -name '*.js.map' -delete \
    && find /opt/conda/lib/python*/site-packages/bokeh/server/static -type f,l -name '*.js' -not -name '*.min.js' -delete \
    && rm -rf /opt/conda/pkgs

# pyzmq is installed explicitly so we don't have to build it from src since jupyter-server-proxy needs it, but jupyter-server-proxy won't install from conda directly

COPY prepare.sh /usr/bin/prepare.sh

RUN mkdir /opt/app

ENTRYPOINT ["tini", "-g", "--", "/usr/bin/prepare.sh"]
