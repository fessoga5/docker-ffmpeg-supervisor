FROM ubuntu:14.04

MAINTAINER fessoga <fessoga5@gmail.com>


RUN apt-get update && apt-get install -y --force-yes curl && \ 
    echo "deb http://ppa.launchpad.net/mc3man/trusty-media/ubuntu trusty main "  >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --force-yes ffmpeg \
    openssh-client \
    openssh-server \
    vim \
    sudo \
    wget \
    supervisor \
    git \
    rsyslog \
    python-yaml && \
    mkdir -p /var/run/sshd && \
    mkdir -p /home/www && \
    chown www-data:www-data -R /home/www && \
    mkdir -p /var/log/supervisor

ADD conf/supervisord.conf /etc/supervisor/supervisord.conf

# Add Scripts
ADD scripts/start.sh /start.sh
RUN chmod 755 /start.sh

# Create user, adding for group. Working for ssh
RUN /usr/sbin/useradd -d /home/ubuntu -s /bin/bash -p $(echo ubuntu | openssl passwd -1 -stdin) ubuntu &&\
/usr/sbin/usermod -a -G sudo ubuntu

# Get timezone
RUN echo "Asia/Irkutsk" | tee /etc/timezone && \
dpkg-reconfigure --frontend noninteractive tzdata

EXPOSE 22

#CMD ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisord.conf"]
CMD ["/start.sh"]
