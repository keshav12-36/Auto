FROM ubuntu:18.04

RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get update &&  apt-get install -y  curl lsb-release
RUN apt-get update \
    && apt-get -y install \
    --no-install-recommends \
    wget \
    aria2 \
    gettext-base \
    python3 \
    python3-pip \
    make \
    nginx \
    g++ \
    unzip \
    busybox \
    build-essential \
    gnupg2 \
    openssl \
    ffmpeg \
    zip \
    ca-certificates \
    && update-ca-certificates \
    && curl  \
    https://mega.nz/linux/MEGAsync/Debian_9.0/i386/megacmd-Debian_9.0_i386.deb \
    --output /tmp/megacmd.deb \
    && apt install /tmp/megacmd.deb -y --allow-remove-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/megacmd.*
#Rclone
RUN curl https://rclone.org/install.sh | bash  
COPY default.conf.template /etc/nginx/conf.d/default.conf.template
COPY nginx.conf /etc/nginx/nginx.conf
ARG PORT=80
ENV PORT $PORT
  # setup workdir
WORKDIR /var/www/html/bot
COPY . .
RUN npm install
CMD [ "node", "/var/www/html/bot/server.js" ]

