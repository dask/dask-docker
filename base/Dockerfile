FROM continuumio/miniconda3:4.3.14

# Dumb init
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64
RUN chmod +x /usr/local/bin/dumb-init

RUN conda update conda && conda install "conda=4.4.7"
RUN conda install --yes \
    python-blosc \
    cytoolz \
    dask==0.17.2  \
    distributed==1.21.4 \
    nomkl \
    numpy==1.14.1 \
    pandas==0.22.0 \
    && conda clean -tipsy

COPY prepare.sh /usr/bin/prepare.sh
RUN chmod +x /usr/bin/prepare.sh

RUN mkdir /opt/app

ENTRYPOINT ["/usr/local/bin/dumb-init", "/usr/bin/prepare.sh"]
