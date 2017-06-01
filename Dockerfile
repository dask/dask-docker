FROM continuumio/miniconda:4.3.11

# Dumb init
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64
RUN chmod +x /usr/local/bin/dumb-init

RUN conda install -y -c conda-forge dask distributed numpy scipy pandas scikit-learn statsmodels numba nomkl fastparquet s3fs zict bcolz blosc cytoolz \
    && conda clean -tipsy

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
