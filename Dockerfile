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
    mkdir /home/$NB_USER/ftp && \
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
    ipympl \
    jupyter-server-proxy \
    jupyter-launcher-shortcuts \
    matplotlib && \
    jupyter labextension install --no-build \
    jupyterlab-launcher-shortcuts \
    jupyterlab-execute-time \
    @elyra/python-editor-extension \
    @jupyterlab/server-proxy \
    @jupyterlab/toc \
    jupyter-matplotlib \
    @jupyter-widgets/jupyterlab-manager \
    jupyterlab-plotly

RUN NODE_OPTIONS=--max_old_space_size=6596 jupyter lab build --name="Naas" --dev-build=False --minimize=False

# add system packages
RUN apt-get update && \
    apt-get -y install redir tzdata tesseract-ocr libtesseract-dev libcairo2-dev

COPY jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py
COPY naas_logo.svg /etc/jupyter/naas_logo.svg
COPY naas_fav.svg /etc/jupyter/naas_fav.svg
COPY custom.css /etc/jupyter/custom.css
COPY overrides.json opt/conda/share/jupyter/lab/settings/overrides.json
COPY naas_logo_n.ico /opt/conda/lib/python3.8/site-packages/notebook/static/favicon.ico
COPY naas_logo_n.ico /opt/conda/lib/python3.8/site-packages/notebook/static/base/images/favicon.ico
RUN cat /etc/jupyter/custom.css >> /opt/conda/share/jupyter/lab/themes/@jupyterlab/theme-light-extension/index.css

RUN sed -i '6 i\export KERNEL_JUPYTER_SERVER_ROOT=${JUPYTER_SERVER_ROOT}' /usr/local/bin/start-notebook.sh
RUN sed -i '6 i\export KERNEL_JUPYTERHUB_USER=${JUPYTERHUB_USER}' /usr/local/bin/start-notebook.sh
RUN sed -i '6 i\export KERNEL_JUPYTERHUB_API_TOKEN=${JUPYTERHUB_API_TOKEN}' /usr/local/bin/start-notebook.sh