# phd-thesis


## How to compile ?

Build the docker image once (you need docker installed):

```
cd ./scripts
docker build -t thtex .
```

Run the compile script:

```
cd ../tex
docker run --volume=CWD:"/data" -t thtex python3 /scripts/compile.py
```

In order to compile a chapter independently, you can provide additional argument to the compile line.
The parameters should be either the chapter number or the chapter short name (see `scripts/compile.py` file).