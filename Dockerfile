FROM continuumio/miniconda3

# 初始化conda以便于使用conda activate
SHELL ["/bin/bash", "-c"]
RUN conda init bash && \
    echo "source ~/.bashrc" > ~/.profile

# 创建新的环境
RUN conda create -n trellis python=3.10 -y

# 激活环境并安装包
RUN . /root/.bashrc && \
    conda activate trellis && \
    conda install pytorch==2.4.0 torchvision==0.19.0 pytorch-cuda=11.8 -c pytorch -c nvidia -y

# 设置默认环境
ENV CONDA_DEFAULT_ENV=trellis
ENV PATH /opt/conda/envs/trellis/bin:$PATH

# 执行setup和下载脚本
RUN conda run -n trellis /bin/bash -c "./setup.sh --new-env --basic --xformers --flash-attn --diffoctreerast --spconv --mipgaussian --kaolin --nvdiffrast"

RUN conda run -n trellis /bin/bash -c "./setup.sh --demo"

RUN conda run -n trellis python ./download.py

EXPOSE 7860

# 设置入口点
ENTRYPOINT ["conda", "run", "-n", "trellis", "python", "./app.py"]
