FROM jupyter/minimal-notebook:latest
ENV JUPYTERHUB_VERSION=1.3.0
ENV JUPYTERLAB_VERSION=3.0.10
ENV JUPYTERNBDIME_VERSION=3.0.0b1
ENV JUPYTERCLIENT_VERSION=6.1.11
ENV JUPYTERGIT_VERSION=0.30.0b2
ENV JUPYTERSERVER_VERSION=1.5.3
ENV NB_UMASK=022
ENV NB_USER=ftp
ENV NB_UID=21
ENV NB_GID=21
ENV NB_GROUP=21
ENV PYTHONPATH=/home/pylib
ENV TZ Europe/Paris
USER root
ENV VERSION 2.6.0b0

RUN mkdir /home/$NB_USER && \
    fix-permissions /home/$NB_USER

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --use-deprecated=legacy-resolver --no-cache \
    jupyterhub==$JUPYTERHUB_VERSION \
    jupyterlab==$JUPYTERLAB_VERSION  \
    jupyter_client==$JUPYTERCLIENT_VERSION  \
    jupyter_server_proxy==$JUPYTERSERVER_VERSION \
    jupyterlab-git==$JUPYTERGIT_VERSION \
    nbdime==$JUPYTERNBDIME_VERSION  \
    nbformat \
    nbconvert \
    jupyter-resource-usage \
    ipyparallel \
    ipywidgets \
    ipympl \
    jupyterlab_widgets \
    jupyterlab-quickopen==1.0.0 \
    jupyterlab-execute-time \
    python-language-server \
    elyra-python-editor-extension \
    matplotlib==3.3.4 && \
    jupyter labextension install --no-build \
    jupyterlab-spreadsheet \
    @jupyterlab/server-proxy \
    jupyterlab-plotly

RUN NODE_OPTIONS=--max_old_space_size=6096 jupyter lab build --dev-build=False

# add system packages
RUN apt-get update && \
    apt-get -y install redir

RUN git config --global credential.helper store #Auto save git credentials

RUN sed -i '6 i\export KERNEL_JUPYTER_SERVER_ROOT=${JUPYTER_SERVER_ROOT}' /usr/local/bin/start-notebook.sh
RUN sed -i '6 i\export KERNEL_JUPYTERHUB_USER=${JUPYTERHUB_USER}' /usr/local/bin/start-notebook.sh
RUN sed -i '6 i\export KERNEL_JUPYTERHUB_API_TOKEN=${JUPYTERHUB_API_TOKEN}' /usr/local/bin/start-notebook.sh