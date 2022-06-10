@ECHO OFF
docker run --rm --volume="%cd%":"/data" -t rmormont/thesis-tex-compile:1.1 python3 /scripts/compile.py %* 