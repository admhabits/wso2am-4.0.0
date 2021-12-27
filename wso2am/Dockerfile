# set base Docker image to JDK Ubuntu 20.04 Docker image
FROM ubuntu:20.04

#Install Open JDK
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN apt-get update \
    && apt-get install -y --no-install-recommends tzdata curl ca-certificates fontconfig locales \ 
        sudo \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.UTF-8

ENV JAVA_VERSION jdk-11.0.13+8

RUN set -eux; \
    ARCH="$(dpkg --print-architecture)"; \
    case "${ARCH}" in \
       amd64|x86_64) \
         ESUM='3b1c0c34be4c894e64135a454f2d5aaa4bd10aea04ec2fa0c0efe6bb26528e30'; \
         BINARY_URL='https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.13%2B8/OpenJDK11U-jdk_x64_linux_hotspot_11.0.13_8.tar.gz'; \
         ;; \
       *) \
         echo "Unsupported arch: ${ARCH}"; \
         exit 1; \
         ;; \
    esac; \
    curl -LfsSo /tmp/openjdk.tar.gz ${BINARY_URL}; \
    echo "${ESUM} */tmp/openjdk.tar.gz" | sha256sum -c -; \
    mkdir -p /opt/java/openjdk; \
    cd /opt/java/openjdk; \
    tar -xf /tmp/openjdk.tar.gz --strip-components=1; \
    rm -rf /tmp/openjdk.tar.gz;

ENV JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/java/openjdk/bin:$PATH"

# Atur argumen pembuatan gambar Docker
# Membuat argumen untuk konfigurasi pengguna/grup

ARG EMAIL=admhabits@gmail.com
ARG USERNAME=admhabits

ARG USER_GROUP=wso2

ARG GIT_BRANCH=b06f03311373af344db4a61e035bb9fddf935c91
ARG REPOSITORY_NAME=wso2am-4.0.0
ARG TOKEN=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

# Membuat argumen untuk instalasi produk WSO2

ARG USER_HOME=/home/${USERNAME}
ARG WSO2_SERVER_HOME=${USER_HOME}/wso2am

ARG WSO2_GITHUB_REMOTE_LINK=https://${TOKEN}@github.com/admhabits/${REPOSITORY_NAME}.git

# Membuat argumen untuk MOTD
ARG MOTD="\n\
Welcome to WSO2 Docker resources.\n\
------------------------------------ \n\
This Docker container comprises of a WSO2 product, running with its latest GA release \n\
which is under the Apache License, Version 2.0. \n\
Read more about Apache License, Version 2.0 here @ http://www.apache.org/licenses/LICENSE-2.0.\n"

# Buat pengguna dan grup non-root dan atur pesan masuk MOTD
RUN echo '[ ! -z "${TERM}" -a -r /etc/motd ] && cat /etc/motd' >> /etc/bash.bashrc; echo "${MOTD}" > /etc/motd
COPY . ${WSO2_SERVER_HOME}

# Instal paket yang diperlukan
RUN \
    apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libxml2-utils \
        netcat \
        unzip \
        wget \
        mc \
        nano \
        git \
        nodejs \
        npm 
RUN \
    sudo whoami \
    \
    && bash -c 'mkdir -p ${USER_HOME}/solr/{indexed-data,database}' \
    && echo "\n\ Buat direktori : $ mkdir -p ${USER_HOME}/solr/{indexed-data,database}" \
    && echo "selesai"\
    \
    && mkdir ${USER_HOME}/${USER_GROUP}-tmp \
    && echo "\n\ Buat direktori: $ mkdir ${USER_HOME}/${USER_GROUP}-tmp " \
    && echo "selesai"\
    \
    && cd ${WSO2_SERVER_HOME} \
    && echo "\n\ Masuk direktori git clone : $ cd ${WSO2_SERVER_HOME}" \
    && ls -l && echo "\n"\
    \
    && echo "\n\ ===== SETUP GLOBAL GIT =====" \
    && git config --global user.email ${EMAIL} \
    && git config --global user.user ${USERNAME} \
    \
    && git init \
    && git remote add origin ${WSO2_GITHUB_REMOTE_LINK} \
    && echo "\n\ git remote add origin ${WSO2_GITHUB_REMOTE_LINK} " \
    \
    && echo "\n\ ===== Inisialisasi Jaggeryapps WSO2AM =====" \
    && cd ${WSO2_SERVER_HOME}/repository/deployment/server/jaggeryapps \
    && ls && echo "\n"\
    \
    && ls && echo "\n" \
    && cp -r ${WSO2_SERVER_HOME}/repository/deployment/server/synapse-configs ${USER_HOME}/${USER_GROUP}-tmp \
    && cp -r ${WSO2_SERVER_HOME}/repository/deployment/server/executionplans ${USER_HOME}/${USER_GROUP}-tmp 

# atur pengguna dan direktori kerja
USER ${USER_ID}
WORKDIR ${USER_HOME}

ENV WORKING_DIRECTORY=${USER_HOME} \
    WSO2_SERVER_HOME=${WSO2_SERVER_HOME}

# expose ports
EXPOSE 9763 9443 9999 11111 8280 8243 5672 9711 9611 9099

# mulai wadah(container) dan mulai server Karbon WSO2
ENTRYPOINT ["/home/admhabits/wso2am/docker-entrypoint.sh"]
