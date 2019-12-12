#! /bin/bash

emcc --shell-file /src/shell-for-console.html -s ERROR_ON_UNDEFINED_SYMBOLS=0 -s ALLOW_MEMORY_GROWTH=1 -fsanitize-coverage=inline-8bit-counters /src/sqlite3.c /src/sqlite3-ossfuzz.c /src/llvm-project/compiler-rt/lib/fuzzer/libFuzzer.a -o $OUT/sqlite.html
