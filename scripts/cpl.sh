#!/bin/sh
docker run --rm --volume="$PWD":"/data" -t rmormont/thesis-tex-compile:1.4 python3 /scripts/compile.py "$@"