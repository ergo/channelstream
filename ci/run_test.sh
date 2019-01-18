#!/bin/bash

#fail early
set -e

ls -l

APP_NAME="Channelstream"
NOTIFY_FILE="notify_message/TEST_RUN_STATUS.txt"
COMMIT_FILE="resource-channelstream-repo/.git/commit_message"
REV_ID="Local run"
REV_MESSSAGE="Unknown"


if [ -f $COMMIT_FILE ]; then
   REV_ID=$(cat resource-channelstream-repo/.git/short_ref)
   REV_MESSSAGE=$(cat $COMMIT_FILE)
fi

echo Build *FAILURE*: Project $APP_NAME rev: `$REV_ID` msg: _$REV_MESSSAGE_ > $NOTIFY_FILE

cat $NOTIFY_FILE

cd resource-channelstream-repo;

pip install tox
tox --skip-missing-interpreters
cd ..;

echo Build *SUCCESS*: Project $APP_NAME rev: `$REV_ID` msg: _$REV_MESSSAGE_ > $NOTIFY_FILE
