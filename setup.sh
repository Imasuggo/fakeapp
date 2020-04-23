#!/bin/bash

cd `dirname $0`

apt-get install -y apt-get

wget -c https://repo.continuum.io/archive/Anaconda3-2019.10-Linux-x86_64.sh
chmod +x Anaconda3-2019.10-Linux-x86_64.sh
bash Anaconda3-2019.10-Linux-x86_64.sh -b -f -p /usr/local

git clone https://github.com/deepfakes/faceswap.git
conda install -y tk tensorflow-gpu=1.15 python=3.6
pip install -r faceswap/requirements.txt
