FROM resin/rpi-raspbian:jessie

RUN apt-get update && apt-get -y install \
  wget \
  build-essential \
  python-dev \
  python-pip \
  python-pygame \
  supervisor \
  openssh-server \
  git \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/sshd /var/log/supervisor

RUN wget https://github.com/adafruit/omxplayer/releases/download/2%2F10%2F2015/omxplayer-dist.tgz
RUN tar xvfz omxplayer-dist.tgz -C /

# Setup SSH
RUN echo 'root:raspberry' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

COPY video_looper.ini /boot/video_looper.ini

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY . /app

WORKDIR /app
RUN python setup.py install --force
WORKDIR /

EXPOSE 22

CMD ["/usr/bin/supervisord"]
