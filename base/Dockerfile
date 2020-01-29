FROM continuumio/miniconda3:4.7.12

RUN conda install --yes \
    -c conda-forge \
    python-blosc \
    cytoolz \
    dask[complete] \
    lz4 \
    nomkl \
    numpy==1.17.3 \
    pandas==0.25.2 \
    tini==0.18.0 \
    Flask == 0.12 \
    cython \
    simplejson == 3.16.0 \
    pandas == 0.24.2 \
    numpy == 1.17.3 \
    datetime \
    statsmodels == 0.9.0 \
    scipy == 1.2.0 \
    pyramid == 1.5.7 \
    python-dateutil == 2.7.5 \
    requests == 2.21.0 \
    glob2 == 0.6 \
    pathlib == 0.6 \
    arch == 4.8.1 \
    pyramid.arima == 0.9.0 \
    passlib == 1.7.1 \
    isoweek == 1.3.3 \
    joblib == 0.13.2 \
    scikit-learn == 0.22 \
    dask-ml == 1.2.0 \
    distributed == 2.9.3 \
    fsspec == 0.6.2 \
    && conda clean -tipsy \
    && find /opt/conda/ -type f,l -name '*.a' -delete \
    && find /opt/conda/ -type f,l -name '*.pyc' -delete \
    && find /opt/conda/ -type f,l -name '*.js.map' -delete \
    && find /opt/conda/lib/python*/site-packages/bokeh/server/static -type f,l -name '*.js' -not -name '*.min.js' -delete \
    && rm -rf /opt/conda/pkgs

COPY prepare.sh /usr/bin/prepare.sh

RUN mkdir /opt/app

ENTRYPOINT ["tini", "-g", "--", "/usr/bin/prepare.sh"]
