#!/bin/bash

cd `dirname $0`

# install anaconda
wget -c https://repo.continuum.io/archive/Anaconda3-2019.10-Linux-x86_64.sh
chmod +x Anaconda3-2019.10-Linux-x86_64.sh
bash Anaconda3-2019.10-Linux-x86_64.sh -b -f -p /usr/local > /dev/null

# install faceswap
git clone https://github.com/deepfakes/faceswap.git > /dev/null
conda install -y tk tensorflow-gpu=1.15 > /dev/null
pip install -r faceswap/requirements.txt > /dev/null
