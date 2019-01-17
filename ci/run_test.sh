#!/bin/bash

#fail early
set -e

ls -l

cd channelstream_test;
pip install tox
tox
