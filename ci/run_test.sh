#!/bin/bash

#fail early
set -e

ls -l

cd resource-channelstream-repo;
pip install tox
tox --skip-missing-interpreters
