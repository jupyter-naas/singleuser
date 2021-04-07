FROM jupyter/minimal-notebook:latest
ENV TZ Europe/Paris
USER root
ENV VERSION 2.11.9

COPY requirements.txt requirements.txt
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --no-cache-dir -r requirements.txt && \
    jupyter labextension install --no-build \
    jupyterlab-spreadsheet \
    @jupyterlab/server-proxy \
    jupyterlab-plotly

RUN NODE_OPTIONS=--max_old_space_size=6096 jupyter lab build --dev-build=False

# add system packages
RUN apt-get update && \
    apt-get -yyq install redir libtesseract-dev libcairo2-dev

# add lib for puperteer
RUN apt-get install -yyq libappindicator1 libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6

RUN git config --global credential.helper store #Auto save git credentials

RUN sed -i '6 i\export KERNEL_JUPYTER_SERVER_ROOT=${JUPYTER_SERVER_ROOT}' /usr/local/bin/start-notebook.sh
RUN sed -i '6 i\export KERNEL_JUPYTERHUB_USER=${JUPYTERHUB_USER}' /usr/local/bin/start-notebook.sh
RUN sed -i '6 i\export KERNEL_JUPYTERHUB_API_TOKEN=${JUPYTERHUB_API_TOKEN}' /usr/local/bin/start-notebook.sh
USER $NB_UID