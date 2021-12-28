# set base Docker image to JDK Ubuntu 20.04 Docker image
FROM ubuntu:20.04

#Install Open JDK
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN apt-get update \
    && apt-get install -y --no-install-recommends tzdata curl ca-certificates fontconfig locales \ 
        sudo \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.UTF-8

# Atur argumen pembuatan gambar Docker
# Membuat argumen untuk konfigurasi pengguna/grup

ARG EMAIL=admhabits@gmail.com
ARG USERNAME=admhabits

ARG GIT_BRANCH=jaggeryapps
ARG REPOSITORY_NAME=wso2am-4.0.0
ARG TOKEN=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

# Membuat argumen untuk instalasi produk WSO2

ARG USER_HOME=/home/${USERNAME}

ARG WSO2_GITHUB_REMOTE_LINK=https://${TOKEN}@github.com/admhabits/${REPOSITORY_NAME}.git

# Membuat argumen untuk MOTD
ARG MOTD="\n\
Welcome to Jaggeryapps Development.\n\
------------------------------------ \n\
This Docker container comprises of a WSO2 product, running with its latest GA release \n\
which is under the Apache License, Version 2.0. \n\
Read more about Apache License, Version 2.0 here @ http://www.apache.org/licenses/LICENSE-2.0.\n"

# Buat pengguna dan grup non-root dan atur pesan masuk MOTD
RUN echo '[ ! -z "${TERM}" -a -r /etc/motd ] && cat /etc/motd' >> /etc/bash.bashrc; echo "${MOTD}" > /etc/motd
COPY . ${USER_HOME}

# Instal paket yang diperlukan
RUN \
    apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libxml2-utils \
        netcat \
        unzip \
        wget \
        mc \
        git \
        nodejs \
        npm 
RUN \
    sudo whoami \
    \
    && cd ${USER_HOME} \
    && echo "\n\ Masuk direktori git clone : $ cd ${USER_HOME}" \
    && ls -l && echo "\n"\
    \
    && echo "\n\ ===== SETUP GLOBAL GIT =====" \
    && git config --global user.email ${EMAIL} \
    && git config --global user.user ${USERNAME} \
    \
    && git init \
    && git remote add origin ${WSO2_GITHUB_REMOTE_LINK} \
    && git clone ${WSO2_GITHUB_REMOTE_LINK} \
    && echo "\n\ git clone ${WSO2_GITHUB_REMOTE_LINK} " \
    \
    && echo "\n\ ===== Inisialisasi Jaggeryapps WSO2AM =====" \
    && cd ${USER_HOME}/${REPOSITORY_NAME} \
    && git checkout ${GIT_BRANCH} \
    && echo "\n\ ===== npm install && npm run bootstrap =====" \
    && npm install -g lerna && npm install  && npm run bootstrap \
    # && echo "\n\ ===== npm run build:prod =====" \
    # && cd admin && npm run build:prod && cd .. \
    # && cd publisher && npm run build:prod && cd ..\
    # && cd devportal && npm run build:prod && cd ..\
    # && git push origin jaggeryapps \
    && ls && echo "\n"

# expose ports
EXPOSE 8443 3000 9443 9000

RUN cd admin && npm run build:dev
