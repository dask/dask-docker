FROM jupyter/base-notebook

RUN conda create -n dask --yes -c conda-forge \
    dask distributed numpy scipy pandas numba nomkl fastparquet s3fs zict bcolz blosc cytoolz \
    'notebook=5.0.*' \
    'jupyterhub=0.7.*' \
    'jupyterlab=0.24.*' \
    && conda clean -tipsy
ENV PATH=/opt/conda/envs/dask/bin:$PATH

USER root
COPY ./base/prepare.sh /usr/bin/prepare.sh
RUN chmod +x /usr/bin/prepare.sh
RUN mkdir /opt/app
USER $NB_USER

CMD ["bash", "-c", "/usr/bin/prepare.sh && start-notebook.sh"]
