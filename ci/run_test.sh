#!/bin/bash

#fail early
set -e

ls -l

echo Build failed for commit > TEST_RUN_STATUS.txt
if [ -f .git/commit_message ]; then
   cat .git/commit_message >> TEST_RUN_STATUS.txt;
else
   echo Unknown >> TEST_RUN_STATUS.txt;
fi

ls -l
cat TEST_RUN_STATUS.txt;

cd resource-channelstream-repo;

pip install tox
tox --skip-missing-interpreters
cd ..;
touch tests_passed;
echo Build succeeded for commit > TEST_RUN_STATUS.txt
if [ -f .git/commit_message ]; then
   cat .git/commit_message >> TEST_RUN_STATUS.txt;
else
   echo Unknown >> TEST_RUN_STATUS.txt;
fi
