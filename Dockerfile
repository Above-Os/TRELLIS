FROM nvidia/cuda:11.8.0-devel-ubuntu20.04 as builder

# 安装miniconda
ENV CONDA_DIR /opt/conda
RUN apt-get update && apt-get install -y wget && \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    bash ~/miniconda.sh -b -p $CONDA_DIR && \
    rm ~/miniconda.sh

# 设置环境变量
ENV PATH=$CONDA_DIR/bin:$PATH
ENV CUDA_HOME=/usr/local/cuda
ENV PATH=${CUDA_HOME}/bin:${PATH}
ENV LD_LIBRARY_PATH=${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}

# 创建新的环境并安装包
RUN conda create -n trellis python=3.10 -y && \
    conda run -n trellis conda install pytorch==2.4.0 torchvision==0.19.0 pytorch-cuda=12.1 -c pytorch -c nvidia -y

# 安装构建工具
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /app

# 复制文件
COPY . .

# 设置默认环境
ENV CONDA_DEFAULT_ENV=trellis
ENV PATH /opt/conda/envs/trellis/bin:$PATH

# 确保脚本可执行
RUN chmod +x setup.sh

# 执行setup和下载脚本
RUN conda run -n trellis /bin/bash -c "./setup.sh --new-env --basic --xformers --flash-attn --diffoctreerast --spconv --mipgaussian --kaolin --nvdiffrast"

RUN conda run -n trellis /bin/bash -c "./setup.sh --demo"

#RUN conda run -n trellis python ./download.py

EXPOSE 7860

# 设置入口点
ENTRYPOINT ["conda", "run", "-n", "trellis", "python", "./app.py"]