#!/bin/bash

#fail early
set -e

ls -l

echo Build failed for commit > TEST_RUN_STATUS.txt
echo XXXXX >> TEST_RUN_STATUS.txt;
# cat .git/commit_message >> TEST_RUN_STATUS.txt;

ls -l
cat TEST_RUN_STATUS.txt;

cd resource-channelstream-repo;

pip install tox
tox --skip-missing-interpreters
cd ..;
touch tests_passed;
echo Build succeeded for commit > TEST_RUN_STATUS.txt
echo XXXXX >> TEST_RUN_STATUS;
# cat .git/commit_message >> TEST_RUN_STATUS.txt;
# change rev
