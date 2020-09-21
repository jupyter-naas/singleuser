ARG DOCKER_NOTEBOOK_IMAGE
FROM $DOCKER_NOTEBOOK_IMAGE
ARG JUPYTERHUB_VERSION
ARG JUPYTERLAB_VERSION
ARG JUPYTERNBDIME_VERSION
ARG JUPYTERCLIENT_VERSION
ARG JUPYTERGIT_VERSION
ENV NB_UMASK=022
ENV NB_USER=ftp
ENV NB_UID=21
ENV NB_GID=21
ENV NB_GROUP=21
ENV PYTHONPATH=/home/pylib
ENV TZ Europe/Paris
USER root

RUN mkdir /home/$NB_USER && \
    mkdir /home/$NB_USER/ftp && \
    fix-permissions /home/$NB_USER

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
    ipympl \
    jupyter-server-proxy \
    jupyter-launcher-shortcuts \
    naas \
    naas-drivers \
    matplotlib && \
    jupyter labextension install --no-build \
    @elyra/python-editor-extension \
    jupyterlab-launcher-shortcuts \
    @jupyterlab/server-proxy \
    @jupyterlab/toc \
    jupyter-matplotlib \
    @jupyter-widgets/jupyterlab-manager \
    jupyterlab-plotly && \
    jupyter lab build

COPY jupyter_notebook_config.py /etc/jupyter/
COPY naas_logo.jpg /etc/jupyter/naas_logo.jpg

# add brain system 
RUN chmod -R +x /home/secret/ && \
    apt-get update && \
    apt-get -y install tzdata tesseract-ocr libtesseract-dev