@ECHO OFF
docker run --rm --volume="%cd%":"/data" -t thtex python3 /scripts/compile.py %* 