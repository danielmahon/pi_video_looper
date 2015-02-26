FROM resin/rpi-raspbian:jessie

RUN apt-get update && apt-get -y install wget build-essential python-dev python-pip python-pygame supervisor git \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/adafruit/omxplayer/releases/download/2%2F10%2F2015/omxplayer-dist.tgz
RUN tar xvfz omxplayer-dist.tgz -C /

#RUN git clone https://github.com/adafruit/pi_hello_video.git
#WORKDIR pi_hello_video
#RUN ./rebuild.sh
#WORKDIR hello_video
#RUN make install
#WORKDIR /
#RUN rm -rf pi_hello_video

COPY . /app

WORKDIR /app
RUN python setup.py install --force
COPY video_looper.ini /boot/video_looper.ini

COPY video_looper.conf /etc/supervisor/conf.d/

CMD ["/usr/bin/supervisord", "-c /etc/supervisor/conf.d/video_looper.conf"]
