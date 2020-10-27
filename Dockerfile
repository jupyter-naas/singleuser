FROM jupyter/minimal-notebook:latest
ENV JUPYTERHUB_VERSION=1.1.0
ENV JUPYTERLAB_VERSION=2.2.8
ENV JUPYTERNBDIME_VERSION=2.0.0
ENV JUPYTERCLIENT_VERSION=6.1.6
ENV JUPYTERGIT_VERSION=0.20.0
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

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --use-feature=2020-resolver --no-cache \
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
    # jupyter-launcher-shortcuts \
    matplotlib && \
    jupyter labextension install --no-build \
    # jupyterlab-launcher-shortcuts \
    @elyra/python-editor-extension \
    @jupyterlab/server-proxy \
    @jupyterlab/toc \
    jupyter-matplotlib \
    @jupyter-widgets/jupyterlab-manager \
    jupyterlab-plotly && \
    jupyter lab build --name="Naas"

COPY jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py
COPY overrides.json /etc/jupyter/overrides.json
COPY naas_logo.svg /etc/jupyter/naas_logo.svg
COPY naas_fav.svg /etc/jupyter/naas_fav.svg
COPY custom.css /etc/jupyter/custom.css
COPY variables.css /etc/jupyter/variables.css
COPY naas_logo_n.ico /opt/conda/lib/python3.8/site-packages/notebook/static/favicon.ico
COPY naas_logo_n.ico /opt/conda/lib/python3.8/site-packages/notebook/static/base/images/favicon.ico
RUN cat /etc/jupyter/variables.css >> /opt/conda/share/jupyter/lab/themes/@jupyterlab/theme-light-extension/index.css
# add system packages
RUN apt-get update && \
    apt-get -y install redir tzdata tesseract-ocr libtesseract-dev libcairo2-dev
