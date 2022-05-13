# Build Stage
FROM aflplusplus/aflplusplus as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y git make cmake build-essential libjansson-dev libmaxminddb-dev wget

# Download GeoIP2 Database
WORKDIR /
RUN wget https://download.db-ip.com/free/dbip-country-lite-2022-05.mmdb.gz 
RUN gunzip /dbip-country-lite-2022-05.mmdb.gz && mv /dbip-country-lite-2022-05.mmdb /usr/local/share/dbip

## Add source code to the build stage.
RUN git clone https://github.com/capuanob/logswan.git
WORKDIR /logswan
RUN git checkout mayhem

## Build
RUN mkdir build
WORKDIR build
RUN CC=afl-clang-fast CXX=afl-clang-fast++ cmake ..
RUN make

# Package Stage
#FROM aflplusplus/aflplusplus
#COPY --from=builder /imageworsener/tests/srcimg /corpus
#COPY --from=builder /imageworsener/imagew /
#ENTRYPOINT ["afl-fuzz", "-i", "/corpus", "-o", "/out"]
#CMD ["/imagew", "-w", "5", "-h", "5", "@@", "-", "-outfmt", "png"]
