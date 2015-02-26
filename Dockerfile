FROM resin/rpi-raspbian:jessie

RUN apt-get update && apt-get -y install \
  wget \
  build-essential \
  python-dev python-pip python-pygame \
  supervisor \
  openssh-server \
  git \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/sshd /var/log/supervisor

RUN wget https://github.com/adafruit/omxplayer/releases/download/2%2F10%2F2015/omxplayer-dist.tgz
RUN tar xvfz omxplayer-dist.tgz -C /

COPY . /app
WORKDIR /app

RUN python setup.py install --force

COPY video_looper.ini /boot/video_looper.ini

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 22

CMD ["/usr/bin/supervisord"]
