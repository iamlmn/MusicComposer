FROM ubuntu:xenial

# Metadata
LABEL container.base.image="ubuntu xenial"
LABEL software.name="AI MUSIC"
LABEL software.description="An LSTM Recurrent neural network to generate midi music files"
LABEL tags="LSTM"

RUN apt-get update
RUN apt-get install -y locales python3-pip python3-dev python3-virtualenv fabric \
      libpq-dev libjpeg-dev libxml2-dev libxslt-dev libfreetype6-dev libffi-dev \
      git curl wget
# Without LC_ALL setting httpretty installation fails
# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
# Needed for pytest when run tests with docker exec -it
ENV TERM xterm
WORKDIR /home/music-composer/

COPY requirements.txt /home/music-composer/requirements.txt
RUN pip3 install -r requirements.txt

# Copy MIDI Files
COPY midi_songs/ /home/music-composer/midi_songs/
COPY data/ /home/music-composer/data/


# Copy modelling  & Prediction python files
COPY lstm.py /home/music-composer/lstm.py
COPY predict.py /home/music-composer/predict.py

# Set Python3 as default python version
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1