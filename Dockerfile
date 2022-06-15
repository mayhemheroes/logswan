# Build Stage
FROM fuzzers/aflplusplus:3.12c as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y  make cmake build-essential libjansson-dev libmaxminddb-dev wget

WORKDIR /
## Add source code to the build stage.
ADD . /logswan
WORKDIR /logswan


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

## Define testsuite
RUN mkdir /testsuite
RUN cp /logswan/tests/invalid.log /testsuite && cp /logswan/tests/logswan.log /testsuite
RUN echo "fuzz this" > /testsuite/random

## Prepare all library dependencies for copy
RUN mkdir /deps
RUN cp `ldd /logswan/build/logswan | grep so | sed -e '/^[^\t]/ d' | sed -e 's/\t//' | sed -e 's/.*=..//' | sed -e 's/ (0.*)//' | sort | uniq` /deps 2>/dev/null || :
RUN cp `ldd /usr/local/bin/afl-fuzz | grep so | sed -e '/^[^\t]/ d' | sed -e 's/\t//' | sed -e 's/.*=..//' | sed -e 's/ (0.*)//' | sort | uniq` /deps 2>/dev/null || :

## Package Stage

FROM --platform=linux/amd64 ubuntu:22.04
COPY --from=builder /usr/local/share/dbip /usr/local/share/dbip
COPY --from=builder /usr/local/bin/afl-fuzz /afl-fuzz
COPY --from=builder /logswan/build/logswan /logswan-instrumented
COPY --from=builder /deps /usr/lib
COPY --from=builder /testsuite /testsuite

ENV AFL_SKIP_CPUFREQ=1

ENTRYPOINT ["/afl-fuzz", "-i", "/testsuite", "-o", "/out"]
CMD ["/logswan-instrumented", "-g", "@@"]
