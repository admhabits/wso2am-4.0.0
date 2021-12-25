# ------------------------------------------------------------------------
#
# Copyright 2017 WSO2, Inc. (http://wso2.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License
#
# ------------------------------------------------------------------------

# set base Docker image to JDK Ubuntu 20.04 Docker image
FROM ubuntu:20.04
LABEL maintainer="WSO2 Docker Maintainers <dev@wso2.org>" \
      com.wso2.docker.source="https://github.com/wso2/docker-apim/releases/tag/v3.2.0.3"

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
ARG USER=wso2carbon
ARG USER_ROOT=alam
ARG USER_ROOT_PASS=P@ssw0rd1234
ARG USER_ID=802
ARG USER_GROUP=wso2
ARG USER_GROUP_ID=802
ARG USER_HOME=/home/${USER}
ARG MY_EMAIL_GIT=admhabits@gmail.com
ARG ACCESS_TOKEN=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


# Membuat argumen untuk instalasi produk WSO2
ARG REMOTE_NAME=apim
ARG REMOTE_BRANCH=server
ARG WSO2_SERVER_NAME=wso2am
ARG WSO2_SERVER_VERSION=4.0.0
ARG WSO2_SERVER_REPOSITORY=product-apim

ARG WSO2_SERVER=${WSO2_SERVER_NAME}-${WSO2_SERVER_VERSION}
ARG WSO2_SERVER_HOME=${USER_HOME}/${WSO2_SERVER}

ARG WSO2_SERVER_GITHUB_HOME=${USER_HOME}/${WSO2_SERVER_NAME}-${WSO2_SERVER}
ARG WSO2_SERVER_REMOTE_HOME=${USER_HOME}/${REMOTE_NAME}

ARG WSO2_GITHUB_REMOTE_LINK=https://${ACCESS_TOKEN}@github.com/admhabits/${REMOTE_NAME}.git
ARG WSO2_GITHUB_SOURCE_CODE=https://github.com/admhabits/wso2am/archive/refs/tags/wso2am-4.0.0.zip
ARG WSO2_SERVER_OFFICIAL_LINK=https://github.com/wso2/${WSO2_SERVER_REPOSITORY}/releases/download/v${WSO2_SERVER_VERSION}/${WSO2_SERVER}.zip

# Membuat argumen untuk MOTD
ARG MOTD="\n\
Welcome to WSO2 Docker resources.\n\
------------------------------------ \n\
This Docker container comprises of a WSO2 product, running with its latest GA release \n\
which is under the Apache License, Version 2.0. \n\
Read more about Apache License, Version 2.0 here @ http://www.apache.org/licenses/LICENSE-2.0.\n"

# Buat pengguna dan grup non-root dan atur pesan masuk MOTD
RUN adduser ${USER_ROOT} --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password \
    && echo "${USER_ROOT}:password" | sudo chpasswd \
    && echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER \
    && chmod 0440 /etc/sudoers.d/$USER

RUN whoami

RUN groupadd --system -g ${USER_GROUP_ID} ${USER_GROUP} \
    && useradd --system --create-home --home-dir ${USER_HOME} --no-log-init -g ${USER_GROUP_ID} -u ${USER_ID} ${USER} \
    && echo '[ ! -z "${TERM}" -a -r /etc/motd ] && cat /etc/motd' >> /etc/bash.bashrc; echo "${MOTD}" > /etc/motd

# salin skrip init ke home
COPY --chown=wso2carbon:wso2 docker-entrypoint.sh ${USER_HOME}/
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
        vim \
        git \
        nodejs \
        npm 

# Tambahkan distribusi produk WSO2 ke direktori home pengguna

# === DOWNLOAD RESOURCE DARI GITHUB OFFICIAL ===
# RUN \
#     wget -O ${WSO2_SERVER}.zip "${WSO2_SERVER_OFFICIAL_LINK}" \
#     && unzip -d ${USER_HOME} ${WSO2_SERVER}.zip \
#     && chown ${USER}:${USER_GROUP} -R ${WSO2_SERVER_HOME} \
#     && mkdir ${USER_HOME}/${USER_GROUP}-tmp \
#     && bash -c 'mkdir -p ${USER_HOME}/solr/{indexed-data,database}' \
#     && chown ${USER}:${USER_GROUP} -R ${USER_HOME}/solr \
#     && cp -r ${WSO2_SERVER_HOME}/repository/deployment/server/synapse-configs ${USER_HOME}/${USER_GROUP}-tmp \
#     && cp -r ${WSO2_SERVER_HOME}/repository/deployment/server/executionplans ${USER_HOME}/${USER_GROUP}-tmp \
#     && rm -f ${WSO2_SERVER}.zip

# === DOWNLOAD RESOURCE RILIS DARI GITHUB ===
# RUN \
#     wget -O ${WSO2_SERVER}.zip "${WSO2_GITHUB_SOURCE_CODE}" \
#     && unzip -d ${USER_HOME} ${WSO2_SERVER}.zip \
#     && chown ${USER}:${USER_GROUP} -R ${WSO2_SERVER_GITHUB_HOME} \
#     && mkdir ${USER_HOME}/${USER_GROUP}-tmp \
#     && bash -c 'mkdir -p ${USER_HOME}/solr/{indexed-data,database}' \
#     && chown ${USER}:${USER_GROUP} -R ${USER_HOME}/solr \
#     && cp -r ${WSO2_SERVER_GITHUB_HOME}/repository/deployment/server/synapse-configs ${USER_HOME}/${USER_GROUP}-tmp \
#     && cp -r ${WSO2_SERVER_GITHUB_HOME}/repository/deployment/server/executionplans ${USER_HOME}/${USER_GROUP}-tmp \
#     && rm -f ${WSO2_SERVER}.zip

# === CLONE RESOURCE BRANCH DARI GITHUB ===
RUN \
    sudo whoami \
    # # Comment line dibawah ini Jika Ingin Clone Server WSO dari repo yang lain
    # && cd ${USER_HOME} && git clone ${WSO2_GITHUB_REMOTE_LINK} && cd .. && cd .. \
    # && echo "\n\ Fetching source dari repository jika ada : $ git clone ${WSO2_GITHUB_REMOTE_LINK}" \
    # && echo "selesai"\
    \
    && wget -O ${WSO2_SERVER}.zip "${WSO2_SERVER_OFFICIAL_LINK}" \
    && unzip -d ${USER_HOME} ${WSO2_SERVER}.zip \
    # \
    # && mv ${USER_HOME}/${WSO2_SERVER} ${USER_HOME}/${REMOTE_NAME}  && rm -rf ${USER_HOME}/${WSO2_SERVER}\
    # && echo "\n\ Renamed direktori : $ mv ${USER_HOME}/${WSO2_SERVER} ${USER_HOME}/${REMOTE_NAME}" \
    \
    && chown ${USER}:${USER_GROUP} -R ${WSO2_SERVER_HOME} \
    && echo "\n\ Semua direktori : $ ls -a" \
    && echo "selesai"\
    \
    && bash -c 'mkdir -p ${USER_HOME}/solr/{indexed-data,database}' \
    && echo "\n\ Buat direktori : $ mkdir -p ${USER_HOME}/solr/{indexed-data,database}" \
    && echo "selesai"\
    \
    && chown ${USER}:${USER_GROUP} -R ${USER_HOME}/solr \
    && echo "\n\ Buat Permission Group : $ chown ${USER}:${USER_GROUP} -R ${USER_HOME}/solr" \
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
    && git config --global user.email ${MY_EMAIL_GIT} \
    && git config --global user.user ${USER} \
    \
    && git init \
    && git remote add origin ${WSO2_GITHUB_REMOTE_LINK} \
    && git add . && git commit -m "setup server branch" && git branch -M ${REMOTE_BRANCH} \
    # && git push origin server \
    # && git checkout ${REMOTE_BRANCH} \
    \
    && echo "\n\ Pindah branch repository ${REMOTE_BRANCH} : $ git checkout ${REMOTE_BRANCH}" \
    && ls && echo "\n"\
    && rm -rf .git && cd .. \
    \
    && echo "\n\ ===== Inisialisasi Jaggeryapps WSO2AM =====" \
    && cd ${WSO2_SERVER_HOME}/repository/deployment/server/jaggeryapps \
    && ls && echo "\n"\
    \
    && echo "\n\ ===== Buat Branch Baru =====" \
    && git init && git add . && git commit -m "buat branch baru untuk pengembangan jaggeryapps" \
    && git branch -M jaggeryapps && git branch \
    # && git push origin jaggeryapps \
    \
    && ls && echo "\n" \
    && cp -r ${WSO2_SERVER_HOME}/repository/deployment/server/synapse-configs ${USER_HOME}/${USER_GROUP}-tmp \
    && cp -r ${WSO2_SERVER_HOME}/repository/deployment/server/executionplans ${USER_HOME}/${USER_GROUP}-tmp 

# atur pengguna dan direktori kerja
USER ${USER_ID}
WORKDIR ${USER_HOME}

# atur variabel lingkungan
# ENV WORKING_DIRECTORY=${USER_HOME} \
#     WSO2_SERVER_HOME=${WSO2_SERVER_HOME}

ENV WORKING_DIRECTORY=${USER_HOME} \
    WSO2_SERVER_HOME=${WSO2_SERVER_HOME}

# expose ports
EXPOSE 9763 9443 9999 11111 8280 8243 5672 9711 9611 9099

# mulai wadah(container) dan mulai server Karbon WSO2
ENTRYPOINT ["/home/wso2carbon/docker-entrypoint.sh"]
