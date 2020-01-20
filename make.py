#!/usr/bin/env python
"""Build docker images and binaries."""
import subprocess
import logging
import sys

def main():
    logging.basicConfig(
        format="%(asctime)s.%(msecs)03d | %(levelname)-8s | %(message)s",
        datefmt="%H:%M:%S",
        level=logging.INFO)
    logging.info("application started")

    make_base_image()



def make_base_image():
    version = "3.1"
    unsquashed_command = "cd docker/atom_base && docker build . --force-rm -t atom_base:{}-unsquashed".format(version)
    squashed_command = "cd docker/atom_base && docker build . --rm -t atom_base:{} --squash".format(version)

    if subprocess.call(unsquashed_command, shell=True) != 0:
        logging.error("failed to produce unsquashed atom_base:{} docker image".format(version))
        sys.exit(1)
    else:
        logging.info("atom_base:{}-unsquashed docker image ready".format(version))

    if subprocess.call(squashed_command, shell=True) != 0:
        logging.error("failed to produce squashed atom_base:{} docker image".format(version))
        sys.exit(1)
    else:
        logging.info("atom_base:{} docker image ready".format(version))


# create docker base
# create docker conan base

# create packages

if __name__ == "__main__":
    main()
