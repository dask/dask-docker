FROM continuumio/miniconda3:4.3.14

# Dumb init
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64
RUN chmod +x /usr/local/bin/dumb-init

RUN conda create -n dask --yes -c conda-forge \
    blosc \
    cytoolz \
    dask \
    distributed \
    fastparquet \
    nomkl \
    numpy \
    pandas \
    zict \
    && conda clean -tipsy
ENV PATH=/opt/conda/envs/dask/bin:$PATH

COPY prepare.sh /usr/bin/prepare.sh
RUN chmod +x /usr/bin/prepare.sh

RUN mkdir /opt/app

RUN apt-get install git

ENTRYPOINT ["/usr/local/bin/dumb-init", "/usr/bin/prepare.sh"]
