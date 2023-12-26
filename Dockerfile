FROM docker:20.10.16-git
LABEL used-for="ci"
ARG NPM_MIRROR=//registry.npmmirror.com
ARG NPM_REGISTRY=https:${NPM_MIRROR}
RUN git config --global user.email "ci@your-company.com" && git config --global user.name "ci-user"

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
RUN apk add --update --no-cache gcc g++ make python3 openssh-client \
 libgcc libstdc++ wget tar xz bash

# node
ARG NODE_VERSION=18.19.0
RUN wget https://unofficial-builds.nodejs.org/download/release/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64-musl.tar.xz \
  && tar -xJf node-v$NODE_VERSION-linux-x64-musl.tar.xz -C /usr --strip-components=1 --no-same-owner \
  && rm -rf node-v$NODE_VERSION-linux-x64-musl.tar.xz

# npm config
RUN npm config set registry ${NPM_REGISTRY} \
  && npm i yarn -g \
  && npm cache clean --force \
  && yarn config set registry ${NPM_REGISTRY}