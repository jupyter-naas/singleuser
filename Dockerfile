FROM jupyter/minimal-notebook:latest
ENV TZ Europe/Paris
USER root
ENV VERSION 2.6.0b0

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --no-cache \
    jupyterhub==1.3.0 \
    jupyterlab==3.0.12  \
    jupyter_client==6.1.11 \
    jupyter-server-proxy==3.0.2 \
    jupyterlab-git==0.30.0b2 \
    nbdime==3.0.0b1  \
    xeus-python==0.12.1 \
    nbformat==5.1.2 \
    nbconvert==6.0.7 \
    flake8==3.8.4 \
    jupyter-resource-usage==0.5.1 \
    ipyparallel==6.3.0 \
    jupyterlab-spellchecker==0.5.1 \
    # jupyter-archive==3.0.0 \
    jupyterlab-tour==3.0.0 \
    ipywidgets==7.6.3 \
    ipympl==0.6.3 \
    jupyterlab_widgets==1.0.0 \
    jupyterlab-quickopen==1.0.0 \
    jupyterlab-execute-time==2.0.2 \
    python-language-server==0.36.2 \
    jupyterlab-lsp==3.4.1 \
    matplotlib==3.4.0 && \
    jupyter labextension install --no-build \
    jupyterlab-spreadsheet \
    @jupyterlab/server-proxy \
    jupyterlab-plotly

RUN NODE_OPTIONS=--max_old_space_size=6096 jupyter lab build --dev-build=False

# add system packages
RUN apt-get update && \
    apt-get -y install redir libtesseract-dev libcairo2-dev

# add lib for puperteer
RUN apt-get install -yyq libappindicator1 libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6

RUN git config --global credential.helper store #Auto save git credentials

RUN sed -i '6 i\export KERNEL_JUPYTER_SERVER_ROOT=${JUPYTER_SERVER_ROOT}' /usr/local/bin/start-notebook.sh
RUN sed -i '6 i\export KERNEL_JUPYTERHUB_USER=${JUPYTERHUB_USER}' /usr/local/bin/start-notebook.sh
RUN sed -i '6 i\export KERNEL_JUPYTERHUB_API_TOKEN=${JUPYTERHUB_API_TOKEN}' /usr/local/bin/start-notebook.sh