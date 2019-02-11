FROM jupyter/base-notebook:a95cb64dfe10

#Set the working directory
WORKDIR /home/jovyan/

# Modules
COPY requirements.txt /home/jovyan/requirements.txt
RUN pip install -r /home/jovyan/requirements.txt

# Allow user to write to directory and add files
USER root
ENV SRC_DIR /src
RUN mkdir $SRC_DIR
COPY . .
COPY . /src
RUN chown -R $NB_USER /home/jovyan \
    && chmod -R 774 /home/jovyan
RUN chown -R $NB_USER:users $SRC_DIR && chown -R $NB_USER:users /home/$NB_USER
USER $NB_USER

# Expose the notebook port
EXPOSE 8888

# Start the notebook server
CMD jupyter notebook --no-browser --port 8888 --ip=0.0.0.0 --NotebookApp.token='' --NotebookApp.disable_check_xsrf=True --NotebookApp.iopub_data_rate_limit=1.0e10
