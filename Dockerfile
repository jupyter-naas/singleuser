FROM jupyter/minimal-notebook:latest
ENV JUPYTERHUB_VERSION=1.3.0
ENV JUPYTERLAB_VERSION=2.2.9
ENV JUPYTERNBDIME_VERSION=2.1.0
ENV JUPYTERCLIENT_VERSION=6.1.7
ENV JUPYTERGIT_VERSION=0.23.3
ENV NB_UMASK=022
ENV NB_USER=ftp
ENV NB_UID=21
ENV NB_GID=21
ENV NB_GROUP=21
ENV PYTHONPATH=/home/pylib
ENV TZ Europe/Paris
USER root
ENV VERSION 2.0.1

RUN mkdir /home/$NB_USER && \
    fix-permissions /home/$NB_USER

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --no-cache \
    jupyterhub==$JUPYTERHUB_VERSION \
    jupyterlab==$JUPYTERLAB_VERSION  \
    jupyter_client==$JUPYTERCLIENT_VERSION  \
    jupyterlab-git==$JUPYTERGIT_VERSION \
    nbdime==$JUPYTERNBDIME_VERSION  \
    nbformat \
    nbconvert \
    nbresuse \
    ipyparallel \
    ipywidgets \
    ipympl==0.5.8 \
    jupyterlab-quickopen==0.5 \
    jupyter-server-proxy \
    jupyter-launcher-shortcuts \
    matplotlib==3.3.1 && \
    jupyter labextension install --no-build \
    @parente/jupyterlab-quickopen@0.5 \
    @wallneradam/custom_css \
    spreadsheet-editor \
    jupyterlab-launcher-shortcuts \
    jupyterlab-execute-time \
    @elyra/python-editor-extension \
    @jupyterlab/server-proxy \
    @jupyterlab/toc \
    jupyter-matplotlib@0.7.4 \
    @jupyter-widgets/jupyterlab-manager@2.0 \
    jupyterlab-plotly

    # @parente/jupyterlab-quickopen@0.5 \ # >= 1.0.0 requires JupyterLab 3.x
    # spreadsheet-editor \ # open issue on v3
    # jupyterlab-launcher-shortcuts \ # need to work on it
    # jupyterlab-execute-time \ # updated for v3
    # @elyra/python-editor-extension \ # >= 2.0.0 requires JupyterLab 3.x
    # @jupyterlab/server-proxy \ # updated for v3
    # @jupyterlab/toc \ # have been added to core jupyter 3  remove it 
    # jupyter-matplotlib@0.7.4 \ # work but still a bit buggy
    # @jupyter-widgets/jupyterlab-manager@2.0 \ change to pip install jupyterlab_widgets
    # jupyterlab-plotly

RUN NODE_OPTIONS=--max_old_space_size=6096 jupyter lab build --name="Naas" --dev-build=False

# add system packages
RUN apt-get update && \
    apt-get -y install redir wkhtmltopdf tzdata tesseract-ocr libtesseract-dev libcairo2-dev

RUN git config --global credential.helper store #Auto save git credentials

RUN sed -i '6 i\export KERNEL_JUPYTER_SERVER_ROOT=${JUPYTER_SERVER_ROOT}' /usr/local/bin/start-notebook.sh
RUN sed -i '6 i\export KERNEL_JUPYTERHUB_USER=${JUPYTERHUB_USER}' /usr/local/bin/start-notebook.sh
RUN sed -i '6 i\export KERNEL_JUPYTERHUB_API_TOKEN=${JUPYTERHUB_API_TOKEN}' /usr/local/bin/start-notebook.sh