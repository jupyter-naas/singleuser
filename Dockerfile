FROM jupyter/minimal-notebook:latest
ENV TZ Europe/Paris
USER root
ENV VERSION 2.6.0b0

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --use-feature=fast-deps --no-cache \
    jupyterhub==1.3.0 \
    jupyterlab==3.0.10  \
    jupyter_client==6.1.11 \
    jupyter_server_proxy==1.5.3 \
    jupyterlab-git==0.30.0b2 \
    nbdime==3.0.0b1  \
    nbformat==5.1.2 \
    nbconvert==6.0.7 \
    jupyter-resource-usage==0.5.1 \
    ipyparallel==6.3.0 \
    ipywidgets==7.6.3 \
    ipympl==0.6.3 \
    jupyterlab_widgets==1.0.0 \
    jupyterlab-quickopen==1.0.0 \
    jupyterlab-execute-time==2.0.2 \
    python-language-server==0.36.2 \
    elyra-python-editor-extension==2.0.1 \
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