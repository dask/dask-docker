FROM condaforge/miniforge3:4.10.3-2

SHELL ["/bin/bash", "-c"]

ENV PATH /opt/conda/bin:$PATH

RUN conda install --yes nomkl cytoolz cmake \
    && conda install --yes mamba \
    && mamba install --yes python==3.8.6 \
    && mamba install --yes \
    cytoolz \
    dask==2021.7.2 \
    lz4 \
    numpy==1.21.1 \
    pandas==1.3.0 \
    tini==0.18.0 \
    && mamba clean -tipsy \
    && find /opt/conda/ -type f,l -name '*.a' -delete \
    && find /opt/conda/ -type f,l -name '*.pyc' -delete \
    && find /opt/conda/ -type f,l -name '*.js.map' -delete \
    && find /opt/conda/lib/python*/site-packages/bokeh/server/static -type f,l -name '*.js' -not -name '*.min.js' -delete \
    && rm -rf /opt/conda/pkgs

COPY prepare.sh /usr/bin/prepare.sh

RUN mkdir /opt/app

ENTRYPOINT ["tini", "-g", "--", "/usr/bin/prepare.sh"]
