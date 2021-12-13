#!/bin/sh
docker run --rm --volume="$PWD":"/data" -t rmormont/compile-tex-thesis:1.0 python3 /scripts/compile.py "$@"