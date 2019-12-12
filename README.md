# SQLite example

1. `docker build -f Dockerfile -t gcr.io/libfuzzer-wasm .`

2. `docker run -v $PWD/out:/out -it gcr.io/libfuzzer-wasm # Do this from the root of this repo`

3. `bash /src/compile_sqlite.sh`

4. Start web server to view the output.
   `cd out && python -m SimpleHTTPServer`

5. Open dev tools console and then go to localhost:8000/sqlite.html
