FROM node:22-alpine3.19@sha256:9459e243f620fff19380c51497493e91db1454f5a30847efe5bc5e50920748d5

ARG UID=1000
ARG GID=1000
ARG BINARYEN_VERSION=116

RUN mkdir -p metadata
RUN mkdir -p metadata/otherpackages
COPY Dockerfile metadata/Dockerfile
COPY CommitHash metadata/CommitHash
COPY RepoInfo metadata/RepoInfo

RUN apk add -U clang lld wasi-sdk |tee /metadata/OSPackagesInstalled

RUN mkdir /home/node/build
WORKDIR /home/node/build

RUN echo "BINARYEN:$BINARYEN_VERSION:https://github.com/WebAssembly/binaryen/releases/download/version_$BINARYEN_VERSION/binaryen-version_$BINARYEN_VERSION-x86_64-linux.tar.gz" > /metadata/OtherPackagesInstalled
RUN wget https://github.com/WebAssembly/binaryen/releases/download/version_$BINARYEN_VERSION/binaryen-version_$BINARYEN_VERSION-x86_64-linux.tar.gz && \
    tar -zxvf binaryen-version_$BINARYEN_VERSION-x86_64-linux.tar.gz binaryen-version_$BINARYEN_VERSION/bin/wasm-opt && \
    mv binaryen-version_$BINARYEN_VERSION/bin/wasm-opt ./ && \
    mv binaryen-version_$BINARYEN_VERSION-x86_64-linux.tar.gz /metadata/otherpackages && \
    rm -rf binaryen-version_$BINARYEN_VERSION && \
    chmod +x ./wasm-opt

USER node
