FROM continuumio/miniconda3:4.5.4

# Dumb init
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64
RUN chmod +x /usr/local/bin/dumb-init

RUN conda update conda 
RUN conda install --yes \
    python-blosc \
    cytoolz \
    dask==0.19.2 \
    nomkl \
    numpy==1.15.1 \
    pandas==0.23.4 \
    && conda clean -tipsy

COPY prepare.sh /usr/bin/prepare.sh
RUN chmod +x /usr/bin/prepare.sh

RUN mkdir /opt/app

ENTRYPOINT ["/usr/local/bin/dumb-init", "/usr/bin/prepare.sh"]
