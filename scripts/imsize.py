import math
import os
import re
import numpy as np
from argparse import ArgumentParser
from pathlib import Path

from imageio import imsave
from skimage import transform
from skimage.io import imread


def get_size(s):
    match = re.match(r"^([0-9]+)\s*([GgMmKk]?[bB])?$", s.strip())
    if match is None:
        raise ValueError("cannot parse size string '{}'".format(s))

    size = int(match.group(1))
    unit = "B" if match.group(2) is None else match.group(2)

    modifier = 1  # size multiplier to get a quantity in bytes

    if len(unit) == 2:
        modifier *= {
            'k': 1000,
            'm': 10 ** 6,
            'g': 10 ** 9
        }[unit[0].lower()]

    if unit[-1] == "b":
        modifier //= 8

    return size * modifier


def main(argv):
    argparse = ArgumentParser()
    argparse.add_argument("path")
    argparse.add_argument("-s", "--size", "--maxsize", dest="maxsize")
    args, _ = argparse.parse_known_args(argv)

    if os.path.isdir(args.path):
        filepaths = [os.path.join(args.path, f) for f in os.listdir(args.path)]
    else:
        filepaths = [args.path]

    maxsize = get_size(args.maxsize)

    for filepath in filepaths:
        fpath = Path(filepath)
        if fpath.suffix not in {".png", ".jpeg", ".jpg"} or fpath.stat().st_size <= maxsize:
            continue
        image = imread(filepath)
        scale = math.sqrt(maxsize / image.nbytes)
        downscaled = transform.rescale(image, scale, order=1, preserve_range=True, multichannel=image.ndim >= 2)
        newfilename = fpath.stem + "_down" + fpath.suffix
        print("> image '{}' > '{}': {} > {}".format(fpath.name, newfilename, image.shape, downscaled.shape))
        imsave(os.path.join(fpath.parent, newfilename), downscaled.astype(np.uint8))


if __name__ == "__main__":
    import sys

    main(sys.argv[1:])
