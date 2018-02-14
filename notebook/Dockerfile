FROM jupyter/base-notebook

USER root
RUN apt-get update \
  && apt-get install -yq --no-install-recommends graphviz git vim \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
USER $NB_USER

RUN conda update conda && conda install "conda=4.4.7"
RUN conda install --yes \
    python-blosc \
    cytoolz \
    dask==0.17.0  \
    distributed==1.21.0 \
    nomkl \
    numpy==1.14.0 \
    pandas==0.22.0 \
    ipywidgets \
    jupyterlab \
    && conda clean -tipsy
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager
RUN pip install graphviz \
                git+https://github.com/dask/distributed.git@bc436e242884a1d4cf3a85ce6d5d378b5663122d \
                --no-cache-dir \
                --no-dependencies

USER root
COPY prepare.sh /usr/bin/prepare.sh
RUN chmod +x /usr/bin/prepare.sh
RUN mkdir /opt/app
COPY examples/ /home/$NB_USER/examples
RUN chown -R $NB_USER /home/$NB_USER/examples
USER $NB_USER

ENTRYPOINT ["tini", "--", "/usr/bin/prepare.sh"]
CMD ["start.sh jupyter lab"]
