# singleuser
🕵️‍♂️ Jupyter-singleuser docker image prebuild, as base for Naas 

# build

`docker build -t jupyternaas/singleuser:latest .`

# dev

`docker run --rm -it -p 8888:8888 -e JUPYTER_ENABLE_LAB=yes jupyternaas/singleuser:latest`
