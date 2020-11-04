#!/bin/bash

set -ex
export arch=$(uname -m)
if [ "$arch" == "aarm64" ]; then
  arch="arm64";
fi
wget --quiet https://github.com/conda-forge/miniforge/releases/download/4.8.5-1/Miniforge3-4.8.5-1-Linux-${arch}.sh -O ~/miniforge.sh
chmod a+x ~/miniforge.sh
~/miniforge.sh -b -p /opt/conda
/opt/conda/bin/conda clean -tipsy
ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh
echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc
echo "conda activate base" >> ~/.bashrc
source ~/.bashrc
find /opt/conda/ -follow -type f -name '*.a' -delete
find /opt/conda/ -follow -type f -name '*.js.map' -delete
/opt/conda/bin/conda clean -afy
/opt/conda/bin/conda install --yes nomkl cytoolz cmake tini
/opt/conda/bin/conda init bash
/opt/conda/bin/conda install --yes mamba
