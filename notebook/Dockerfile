FROM jupyter/base-notebook

RUN conda install --yes -c conda-forge \
    dask distributed numpy pandas numba nomkl fastparquet zict blosc \
    cytoolz ipywidgets \
    && conda clean -tipsy
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager

USER root
COPY prepare.sh /usr/bin/prepare.sh
RUN chmod +x /usr/bin/prepare.sh
RUN mkdir /opt/app
USER $NB_USER

CMD ["bash", "-c", "/usr/bin/prepare.sh && start.sh jupyter lab"]
