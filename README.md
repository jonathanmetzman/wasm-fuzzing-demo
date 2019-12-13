# Demos From My Talk on Fuzzing Native Code in Web Browsers using WASM.

This repo contains demos and examples from the talk (slides coming soon!) I gave on fuzzing C/C++ programs in-browser with libFuzzer using [WebAssembly](https://webassembly.org/).

It contains [demos of in-browser fuzzing](https://jonathanmetzman.github.io/wasm-fuzzing-demo/index.html)
as well as some tools to help users build libFuzzer targets for WASM themselves.

Note that this is not at all about fuzzing the WASM runtime. It is about fuzzing programs (e.g. SQLite, lzma) running in the WASM VM. Because this is running in the WebAssembly runtime, the demos are actually runnning in your web browser, not on a remote server.

# Fuzzing in WASM

I have made a docker image to make building fuzz targets easier since the version of clang currently (12/14/2019) shipped by emscripten
crashes when libFuzzer's coverage instrumentation is used. The docker image builds clang, downloads/installs emscripten
and then builds libFuzzer (targeting WASM). 
From the image you can build whatever program you want by using the compiler flag `-fsanitize-coverage=inline-8bit-counters` and then linking against libFuzzer. See the docs on [emscripten.org](https://emscripten.org/) for more info on building projects to run in the WASM VM.
Follow the steps in the section to build the SQLite fuzzer. This should be a good starting point for building other projects yourself.


# Building the [SQLite example](https://jonathanmetzman.github.io/wasm-fuzzing-demo/sqlite/sqlite.html)

Run the following commands from the root of this repository.

1. `docker build -f Dockerfile -t gcr.io/libfuzzer-wasm .`

2. `docker run -v $PWD/out:/out -it gcr.io/libfuzzer-wasm`

3. `bash /src/compile_sqlite.sh # Run this inside of the docker image`

4. `exit`

5. Start web server to view the output.
   `cd out && python -m SimpleHTTPServer`

6. Open dev tools console in your browser and then go to localhost:8000/sqlite.html

# FAQ
## Why does the fuzzer I built write output only to the console and not the webpage (as the demos do)?
Writing to the webpage (as I cover in the talk) requries making an invasive change to libFuzzer that also hurts performance
significantly (~10-20X, though I may have implemented it badly). Therefore I didn't include this when I added basic support for emscripten to libFuzzer.
