#!/bin/bash

#fail early
set -e

ls -l

echo Build failed for commit > TEST_RUN_STATUS
echo XXXXX >> TEST_RUN_STATUS;
# cat .git/commit_message >> TEST_RUN_STATUS;

ls -l
cat TEST_RUN_STATUS;

cd resource-channelstream-repo;

pip install tox
tox --skip-missing-interpreters
cd ..;
touch tests_passed;
echo Build succeeded for commit > TEST_RUN_STATUS
echo XXXXX >> TEST_RUN_STATUS;
# cat .git/commit_message >> TEST_RUN_STATUS;
# change rev
