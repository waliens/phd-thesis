#!/bin/sh
docker run --rm --volume="$PWD":"/data" -t rmormont/thesis-tex-compile:1.0 python3 /scripts/compile.py "$@"