FROM continuumio/miniconda3:4.3.14

# Dumb init
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64
RUN chmod +x /usr/local/bin/dumb-init

RUN conda update conda && conda install "conda=4.4.7"
RUN conda create -n dask --yes \
    python-blosc \
    cytoolz \
    dask==0.17.0  \
    distributed==1.21.0 \
    nomkl \
    numpy==1.14.0 \
    pandas==0.22.0 \
    && conda clean -tipsy

RUN pip install git+https://github.com/dask/distributed.git@bc436e242884a1d4cf3a85ce6d5d378b5663122d \
                --no-cache-dir \
                --no-dependencies

ENV PATH=/opt/conda/envs/dask/bin:$PATH

COPY prepare.sh /usr/bin/prepare.sh
RUN chmod +x /usr/bin/prepare.sh

RUN mkdir /opt/app

ENTRYPOINT ["/usr/local/bin/dumb-init", "/usr/bin/prepare.sh"]
