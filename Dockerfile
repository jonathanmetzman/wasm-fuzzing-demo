FROM ubuntu:16.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y libc6-dev binutils libgcc-5-dev && \
    apt-get autoremove -y

ENV SRC /src
ENV OUT /out
ENV WORK /work
RUN mkdir $SRC $OUT $WORK

COPY checkout_build_install_llvm.sh /root/
RUN /root/checkout_build_install_llvm.sh

RUN git clone https://github.com/emscripten-core/emsdk.git /src/emsdk
WORKDIR /src/emsdk
RUN apt-get install -y python
RUN ./emsdk install latest
RUN ./emsdk activate latest
RUN printf "LLVM_ROOT = '/work/build/bin'\nBINARYEN_ROOT = '/src/emsdk/upstream'\nEMSCRIPTEN_ROOT = '/src/emsdk/upstream/emscripten'\nNODE_JS = '/src/emsdk/node/12.9.1_64bit/bin/node'\nTEMP_DIR = '/tmp'\nCOMPILER_ENGINE = NODE_JS\nJS_ENGINES = [NODE_JS]" > /src/.emscripten-llvm-override

# Activate the emsdk and don't let it overwrite the .emscripten file we need to
# point to our LLVM build.
RUN echo "/src/emsdk/emsdk activate && source /src/emsdk/emsdk_env.sh &> /dev/null && cp /src/.emscripten-llvm-override /root/.emscripten" >> /root/.bashrc
# RUN echo "PATH=$PATH:/src/emsdk:/src/emsdk/upstream/emscripten:/src/emsdk/node/12.9.1_64bit/bin" >> /root/.bashrc

WORKDIR /src/llvm-project/compiler-rt/lib/fuzzer
COPY compile_libfuzzer.sh /src
RUN /src/compile_libfuzzer.sh

COPY sqlite3.c /src
COPY sqlite3-ossfuzz.c /src
COPY sqlite3.h /src
COPY compile_sqlite.sh /src
COPY shell-for-console.html /src/shell-for-console.html

WORKDIR /src

ENTRYPOINT /bin/bash