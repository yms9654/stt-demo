#FROM pytorch/pytorch:1.6.0-cuda10.1-cudnn7-devel
#FROM mcr.microsoft.com/azureml/pytorch-1.6-ubuntu18.04-py37-cpu-inference:latest
FROM wav2letter/wav2letter:cpu-latest

WORKDIR /app

RUN apt-get update && \
    apt-get install -y apt-utils \
    wget \
    git \
    gcc \
    build-essential \
    cmake \
    libpq-dev \
    libsndfile-dev \
    libboost-system-dev \
    libboost-thread-dev \
    libboost-program-options-dev \
    libboost-test-dev \
    libeigen3-dev \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libsndfile1-dev \
    libopenblas-dev \
    libfftw3-dev \
    libgflags-dev \
    libgoogle-glog-dev \
    libgl1-mesa-glx \
    libomp-dev

# Install miniconda
ENV CONDA_DIR /opt/conda

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py37_4.11.0-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH

# 1. upgrade pip
RUN pip install --upgrade pip

# 2. install python-mecab-ko
RUN pip install python-mecab-ko==1.0.9

RUN conda install pytorch==1.6.0 torchvision torchaudio cpuonly -c pytorch

# 3. install pororo
RUN pip install pororo

# 4. install brainspeech
RUN pip install soundfile \
    torchaudio==0.6.0 \
    pydub

RUN conda install -y -c conda-forge librosa

# 5. install etc modules
RUN pip install librosa \
    kollocate \
    koparadigm \
    g2pk \
    fugashi \
    ipadic \
    romkan \
    g2pM \
    jieba \
    opencv-python \
    scikit-image \
    editdistance==0.5.3 \
    epitran==1.2 \
    fastdtw==0.3.4 \
    future \
    Pillow==7.2.0 \
    pinyin==0.4.0 \
    scikit-learn \
    scipy \
    SoundFile==0.10.2 \
    ko_pron
RUN conda install -y numba

WORKDIR /app/external_lib

RUN git clone https://github.com/kpu/kenlm.git
WORKDIR /app/external_lib/kenlm/build
RUN cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_POSITION_INDEPENDENT_CODE=ON
RUN make
ENV KENLM_ROOT_DIR="/app/external_lib/kenlm/"

WORKDIR /app/external_lib
RUN git clone -b v0.2 https://github.com/facebookresearch/wav2letter.git
WORKDIR /app/external_lib/wav2letter/bindings/python
ENV USE_CUDA=0
RUN pip install -e .

# install for voila
RUN pip install voila ipywidgets==7.5.1 ipywebrtc
RUN conda install -y -c conda-forge xeus-python==0.13.3

WORKDIR /app/scripts