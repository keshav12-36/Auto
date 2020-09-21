FROM node:alpine

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN apk add --update --no-cache \
  c-ares \
  crypto++ \
  nginx \
  python3 \
  python3-pip \
  build-base \
  curl \
  wget \
  aria2 \
  go \
  git \
  libcurl \
  libtool \
  libuv \
  pcre \
  pcre-dev \
  readline \
  sqlite \
  sqlite-dev \
  zlib
RUN apk add --no-cache --virtual .build-deps \
  autoconf \
  automake \
  c-ares-dev \
  crypto++-dev \
  curl \
  curl-dev \
  cvs \
  file \
  g++ \
  gcc \
  git \
  libc-dev \
  libffi-dev \
  libressl2.7-libcrypto \
  libressl-dev \
  libsodium \
  libsodium-dev \
  libuv-dev \
  make \
  openssl \
  openssl-dev \
  readline-dev \
  zlib-dev \
  \
  && cd /opt \
  && cvs -z3 -d:pserver:anonymous@freeimage.cvs.sourceforge.net:/cvsroot/freeimage co -P FreeImage \
  && cd FreeImage \
  && make -j $(nproc) \
  && make install \
  \
  && git clone https://github.com/meganz/MEGAcmd.git /opt/MEGAcmd \
  && cd /opt/MEGAcmd \
  && git submodule update --init --recursive \
  && sh autogen.sh \
  && ./configure \
  && make -j $(nproc) \
  && make install \
  \
  && cd /opt/FreeImage \
  && make clean \
  && cd / \
  && rm -rf /opt/FreeImage \
  \
  && apk del .build-deps
  
COPY default.conf.template /etc/nginx/conf.d/default.conf.template
COPY nginx.conf /etc/nginx/nginx.conf

  # setup workdir
WORKDIR /var/www/html/bot
COPY . .
RUN npm install
RUN rm -rf /var/www/html/bot/{default.conf.template,package-lock.json,package.json,config.json,nginx.conf,lib,heroku.yml,README.md,LICENSE}
CMD /bin/bash -c "envsubst '\$PORT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf" && nginx -g 'daemon off;' && bash start.sh

