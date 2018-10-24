FROM ubuntu:16.04
MAINTAINER BirdZhang 0312birdzhang@gmail.com
RUN apt update && \
    apt install -y inotify-tools createrepo nginx python3-pip wget cron && \
    apt autoremove && apt clean && \
    rm -rf /var/lib/apt/lists/*
ADD start.sh /data/
ADD get_publishers.py /data/
ADD default /etc/nginx/sites-available/
EXPOSE 80
CMD ["bash","/data/start.sh"]
