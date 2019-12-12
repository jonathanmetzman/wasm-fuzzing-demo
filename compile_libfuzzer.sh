#! /bin/bash

source /src/emsdk/emsdk_env.sh
cd /src/llvm-project/compiler-rt/lib/fuzzer
CXX=emcc bash build.sh

