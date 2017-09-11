FROM quay.io/redsift/sandbox-go:v1.9
MAINTAINER Christos Vontas email: christos@redsift.io version: 1.0.0

RUN apt-get update && \
    apt-get install -y libgflags-dev libsnappy-dev liblz4-dev libbz2-dev zlib1g-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

ENV ROCKSDB_VERSION 5.7.3

RUN cd /tmp && \
  wget https://github.com/facebook/rocksdb/archive/v${ROCKSDB_VERSION}.tar.gz && \
  tar -xzf v${ROCKSDB_VERSION}.tar.gz && \
  cd rocksdb-${ROCKSDB_VERSION} && \
  make static_lib && make install && rm -rf /tmp/*

ENTRYPOINT ["/bin/bash"]
