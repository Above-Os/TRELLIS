# 使用官方Ubuntu基础镜像
FROM ubuntu:20.04

# 避免交互式提示
ENV DEBIAN_FRONTEND=noninteractive

EXPOSE 7860

COPY . .

# 安装基本依赖
RUN apt-get update && apt-get install -y \
    wget \
    bzip2 \
    ca-certificates \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# 设置Miniconda安装路径
ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH

# 下载并安装Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh \
    && bash ~/miniconda.sh -b -p $CONDA_DIR \
    && rm ~/miniconda.sh

# 初始化conda
RUN conda init bash

# 设置默认环境
ENV CONDA_DEFAULT_ENV trellis


RUN ./setup.sh --new-env --basic --xformers --flash-attn --diffoctreerast --spconv --mipgaussian --kaolin --nvdiffrast

RUN ./setup.sh --demo

RUN python ./download.py

CMD ["python","./app.py"]