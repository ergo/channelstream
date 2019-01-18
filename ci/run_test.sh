#!/bin/bash

#fail early
set -e

ls -l

NOTIFY_FILE="notify_message/TEST_RUN_STATUS.txt"
COMMIT_FILE=".git/commit_message"

echo Build failed for commit > $NOTIFY_FILE
if [ -f $COMMIT_FILE ]; then
   cat $COMMIT_FILE >> $NOTIFY_FILE;
else
   echo Unknown >> $NOTIFY_FILE;
fi

ls -l
cat $NOTIFY_FILE;

cd resource-channelstream-repo;

pip install tox
tox --skip-missing-interpreters
cd ..;
touch tests_passed;
echo Build succeeded for commit > $NOTIFY_FILE
if [ -f $COMMIT_FILE ]; then
   cat $COMMIT_FILE >> $NOTIFY_FILE;
else
   echo Unknown >> $NOTIFY_FILE;
fi
