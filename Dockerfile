# Build Stage
FROM aflplusplus/aflplusplus as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y git make cmake build-essential libjansson-dev libmaxminddb-dev wget

WORKDIR /
## Add source code to the build stage.
RUN git clone https://github.com/capuanob/logswan.git
WORKDIR /logswan
RUN git checkout mayhem

## Define corpus
RUN mkdir /corpus
RUN cp /logswan/tests/invalid.log /corpus && cp /logswan/tests/logswan.log /corpus
RUN echo "fuzz this" > /corpus/random

# Set up GEOIP2 Database
WORKDIR /
RUN wget https://download.db-ip.com/free/dbip-country-lite-2022-05.mmdb.gz 
RUN mkdir -p /usr/local/share/dbip
RUN gunzip /dbip-country-lite-2022-05.mmdb.gz && mv /dbip-country-lite-2022-05.mmdb /usr/local/share/dbip/dbip-country-lite.mmdb

## Build
WORKDIR /logswan
RUN mkdir build
WORKDIR build
RUN CC=afl-clang-fast CXX=afl-clang-fast++ cmake ..
RUN CC=afl-clang-fast CXX=afl-clang-fast++ make
RUN mv /logswan/build/logswan /logswan-instrumented

ENTRYPOINT ["afl-fuzz", "-i", "/corpus", "-o", "/out"]
CMD ["/logswan-instrumented", "-g", "@@"]
