FROM alpine:3.20.0

RUN echo 'http://dl-cdn.alpinelinux.org/alpine/v3.16/main' >> /etc/apk/repositories
RUN apk update fetch http://dl-cdn.alpinelinux.org/alpine/v3.16/main/aarch64/APKINDEX.tar.gz http://dl-cdn.alpinelinux.org/alpine/v3.16/main/armhf/APKINDEX.tar.gz http://dl-cdn.alpinelinux.org/alpine/v3.16/main/armv7/APKINDEX.tar.gz http://dl-cdn.alpinelinux.org/alpine/v3.16/main/ppc64le/APKINDEX.tar.gz http://dl-cdn.alpinelinux.org/alpine/v3.16/main/s390x/APKINDEX.tar.gz http://dl-cdn.alpinelinux.org/alpine/v3.16/main/x86/APKINDEX.tar.gz http://dl-cdn.alpinelinux.org/alpine/v3.16/main/x86_64/APKINDEX.tar.gz

RUN apk add --no-cache autoconf automake libtool flex bison gperf gawk m4 make "openssl<1.2.0" "openssl-dev<1.2.0" git build-base

RUN git clone --depth 1 --branch v7.2.6.1 https://github.com/openlink/virtuoso-opensource

WORKDIR virtuoso-opensource

RUN ./autogen.sh

RUN CFLAGS="-O2 -m64" \
    export CFLAGS

RUN ./configure --prefix=/VIRTUOSO/

RUN make
RUN make install

RUN mkdir -p /VIRTUOSO/database

workdir /VIRTUOSO/database

RUN wget https://zenodo.org/records/11562272/files/fedshop_200.db && \
    wget https://raw.githubusercontent.com/GDD-Nantes/fediscount-website/main/fedshop_200.ini

########################################################

###### Install webui

WORKDIR /
RUN git clone --depth 1 https://github.com/GDD-Nantes/fediscount-website && \
    git clone --depth 1 https://github.com/GDD-Nantes/raw-jena && \
    git clone --depth 1 https://github.com/GDD-Nantes/fedup


WORKDIR /raw-jena/raw-jena-ui

RUN apk add --no-cache nodejs npm && npm install && npm install -g vite

WORKDIR /fediscount-website
RUN npm install

####### Install fedup
## TODO: faceted build where maven build a self-contained jar, then run it without
## installed

WORKDIR /fedup

RUN apk add --no-cache maven unzip

RUN mvn install -Dmaven.test.skip=true

RUN wget https://zenodo.org/records/11562272/files/fedshop20-h0.zip && \
    wget https://zenodo.org/records/11562272/files/fedshop100-h0.zip && \
    wget https://zenodo.org/records/11653849/files/fedshop200-h0.zip && \
    unzip fedshop20-h0.zip && \
    unzip fedshop100-h0.zip && \
    unzip fedshop200-h0.zip

###### Run all services on their specific port

WORKDIR /
RUN echo $'#!/bin/sh\n\
cd /VIRTUOSO/database\n\
../bin/virtuoso-t +configfile fedshop_200.ini \n\
cd /fedup \n\
mvn exec:java -Dexec.args="--summaries=/fedup/fedshop100-h0,/fedup/fedshop20-h0,/fedup/fedshop200-h0 --engine=FedX --export" -Dmaven.test.skip=true &\n\
cd /raw-jena/raw-jena-ui/ \n\
vite --host 0.0.0.0 --port 5173 &\n\
cd /fediscount-website/ \n\
vite --host 0.0.0.0 --port 5174 &\n\
wait' > ./start.sh

RUN chmod +x ./start.sh

ENTRYPOINT ["./start.sh"]
