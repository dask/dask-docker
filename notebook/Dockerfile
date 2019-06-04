FROM jupyter/base-notebook

USER root

RUN apt-get update \
  && apt-get install -yq --no-install-recommends graphviz git gcc build-essential \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

USER $NB_USER

RUN conda install --yes --freeze-installed \
    -c conda-forge \
    python-blosc \
    cytoolz \
    dask==1.2.0 \
    nomkl \
    numpy==1.16.2 \
    pandas==0.24.2 \
    ipywidgets \
    && jupyter labextension install @jupyter-widgets/jupyterlab-manager@0.38.1 dask-labextension@0.3 \
    && pip install graphviz dask-labextension==0.3.3 --no-cache-dir --no-dependencies \
    && conda clean -tipsy \
    && jupyter lab clean \
    && jlpm cache clean \
    && npm cache clean --force \
    && find /opt/conda/ -type f,l -name '*.a' -delete \
    && find /opt/conda/ -type f,l -name '*.pyc' -delete \
    && find /opt/conda/ -type f,l -name '*.js.map' -delete \
    && find /opt/conda/lib/python*/site-packages/bokeh/server/static -type f,l -name '*.js' -not -name '*.min.js' -delete \
    && rm -rf /opt/conda/pkgs

USER root

# Create the /opt/app directory, and assert that Jupyter's NB_UID/NB_GID values
# haven't changed. 
RUN mkdir /opt/app \
    && if [ "$NB_UID" != "1000" ] || [ "$NB_GID" != "100" ]; then \
        echo "Jupyter's NB_UID/NB_GID changed, need to update the Dockerfile"; \ 
        exit 1; \
    fi

# Copy over the example as NB_USER. Unfortuantely we can't use $NB_UID/$NB_GID
# in the `--chown` statement, so we need to hardcode these values.
COPY --chown=1000:100 examples/ /home/$NB_USER/examples
COPY prepare.sh /usr/bin/prepare.sh

USER $NB_USER


RUN pip install --ignore-installed pyyaml==5.1

RUN pip install attrs==19.1.0 \
                backports-abc==0.5 \
                boto3==1.9.143 \
                botocore==1.12.143 \
                bottle==0.12.16 \
                certifi==2019.3.9 \
                chardet==3.0.4 \
                click==7.0 \
                cloudpickle==0.8.1 \
                dask==1.2.0 \
                dateparser==0.7.1 \
                distributed==1.27.1 \
                docutils==0.14 \
                enum34==1.1.6 \
                fastparquet==0.3.1 \
                funcsigs==1.0.2 \
                futures==3.1.1 \
                heapdict==1.0.0 \
                honeycomb-beeline==2.5.0 \
                idna==2.8 \
                jmespath==0.9.4 \
                jsonschema==3.0.1 \
                libhoney==1.7.1 \
                llvmlite==0.28.0 \
                msgpack==0.6.1 \
                numba==0.43.1 \
                numpy==1.16.3 \
                pandas==0.24.2 \
                psutil==5.6.2 \
                pyrsistent==0.15.2 \
                python-dateutil==2.8.0 \
                pytz==2019.1 \
                regex==2019.4.14 \
                requests==2.21.0 \
                s3fs==0.2.1 \
                s3transfer==0.2.0 \
                scikit-learn==0.20.3 \
                scipy==1.2.1 \
                singledispatch==3.4.0.3 \
                six==1.12.0 \
                sklearn==0.0 \
                sortedcontainers==2.1.0 \
                statsd==3.3.0 \
                tblib==1.4.0 \
                thrift==0.11.0 \
                toolz==0.9.0 \
                tornado==5.1.1 \
                tzlocal==1.5.1 \
                urllib3==1.24.3 \
                wrapt==1.11.1 \
                zict==0.1.4 --upgrade

ENTRYPOINT ["tini", "--", "/usr/bin/prepare.sh"]
CMD ["start.sh", "jupyter", "lab"]
