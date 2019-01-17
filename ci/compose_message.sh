#!/bin/bash

#fail early
set -e

ls -l

cd resource-channelstream-repo;

cat .git/commit_message;

pip install tox
tox --skip-missing-interpreters
touch tests_passed
# change rev
