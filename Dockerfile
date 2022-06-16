FROM quay.io/redsift/sandbox-go:v1.18.3
MAINTAINER Christos Vontas email: christos@redsift.io version: 1.1.0

RUN apt-get update && \
    apt-get install -y libgflags-dev libsnappy-dev zlib1g-dev libbz2-dev libzstd-dev openssh-client git curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

ARG ROCKSDB_VERSION=5.18.3

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

RUN curl -sSL "https://github.com/gotestyourself/gotestsum/releases/download/v0.6.0/gotestsum_0.6.0_linux_amd64.tar.gz" | tar -xz -C /usr/local/bin gotestsum

RUN go clean -modcache

ENTRYPOINT ["/bin/bash"]
