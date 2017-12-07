FROM quay.io/redsift/sandbox-go:v1.9.2
MAINTAINER Christos Vontas email: christos@redsift.io version: 1.1.0

RUN apt-get update && \
    apt-get install -y libgflags-dev libsnappy-dev zlib1g-dev libbz2-dev libzstd-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

ARG ROCKSDB_VERSION=5.8

ENV ROCKSDB_PATH /usr/lib/rocksdb-${ROCKSDB_VERSION}
ENV CGO_CFLAGS="-I${ROCKSDB_PATH}/include"
ENV CGO_LDFLAGS="-L${ROCKSDB_PATH} -lrocksdb -lstdc++ -lm -lz -lbz2 -lsnappy -lzstd"

RUN cd /tmp && \
  wget https://github.com/facebook/rocksdb/archive/v${ROCKSDB_VERSION}.tar.gz && \
  tar -xzf v${ROCKSDB_VERSION}.tar.gz -C /usr/lib && \
  cd $ROCKSDB_PATH && \
  make static_lib && make install && \
  strip --strip-debug /usr/local/lib/librocksdb.a && \
  rm -rf /tmp/* $ROCKSDB_PATH/librocksdb.a

ENTRYPOINT ["/bin/bash"]
