@ECHO OFF
docker run --volume="%cd%":"/data" -t thtex python3 /scripts/compile.py %* 