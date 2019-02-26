FROM continuumio/miniconda3:4.5.11

# Dumb init
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64
RUN chmod +x /usr/local/bin/dumb-init

RUN conda install --yes \
    -c conda-forge \
    python-blosc \
    cytoolz \
    dask==1.1.2 \
    nomkl \
    numpy==1.16.0 \
    pandas==0.24.0 \
    && conda clean -tipsy

COPY prepare.sh /usr/bin/prepare.sh
RUN chmod +x /usr/bin/prepare.sh

RUN mkdir /opt/app

ENTRYPOINT ["/usr/local/bin/dumb-init", "/usr/bin/prepare.sh"]
