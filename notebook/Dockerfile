FROM jupyter/base-notebook:4d7dd95017ed

USER root

RUN apt-get update \
  && apt-get install -yq --no-install-recommends graphviz git vim \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*


USER $NB_USER

RUN conda update conda  \
 && conda install --yes \
    python-blosc \
    cytoolz \
    dask==1.2.0 \
    nomkl \
    numpy==1.16.2 \
    pandas==0.24.2 \
    ipywidgets \
    jupyterlab==0.35.5 \
 && conda clean -tipsy

RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager@0.38.1 dask-labextension@0.3

RUN pip install graphviz          \
                --no-cache-dir    \
                --no-dependencies \
 && pip install dask-labextension==0.3.3 \
                --no-cache-dir


USER root

COPY prepare.sh /usr/bin/prepare.sh
RUN chmod +x /usr/bin/prepare.sh
RUN mkdir /opt/app
COPY examples/ /home/$NB_USER/examples
RUN chown -R $NB_USER /home/$NB_USER/examples


USER $NB_USER

ENTRYPOINT ["tini", "--", "/usr/bin/prepare.sh"]
CMD ["start.sh", "jupyter", "lab"]
