FROM continuumio/miniconda3:4.6.14
RUN apt-get update -y
RUN apt-get install -y gcc build-essential

RUN conda install --yes --freeze-installed \
    -c conda-forge \
    python-blosc \
    cytoolz \
    dask==1.2.0 \
    nomkl \
    numpy==1.16.3 \
    pandas==0.24.2 \
    tini==0.18.0 \
    xarray \
    matplotlib \
    s3fs=0.2.1 \
    gcsfs=0.2.2 \
    && conda clean -tipsy \
    && find /opt/conda/ -type f,l -name '*.a' -delete \
    && find /opt/conda/ -type f,l -name '*.pyc' -delete \
    && find /opt/conda/ -type f,l -name '*.js.map' -delete \
    && find /opt/conda/lib/python*/site-packages/bokeh/server/static -type f,l -name '*.js' -not -name '*.min.js' -delete \
    && rm -rf /opt/conda/pkgs

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

COPY prepare.sh /usr/bin/prepare.sh

RUN mkdir /opt/app

ENTRYPOINT ["tini", "-g", "--", "/usr/bin/prepare.sh"]
