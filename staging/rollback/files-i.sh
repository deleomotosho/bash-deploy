#!/usr/bin/env bash

# about ::
# the master form for deploys and rollbacks.
# there is the part  that sits on one server (staging?)
# and the one on the server that needs to be deployed to (production?)

# Copyright (c) 2012 Dele Omotosho
# GPLv3 : http://www.gnu.org/licenses/gpl-3.0.html

source ../staging.conf

cd $HTTP_PATH

echo "This are the most recent commits: "
# this shows the last 3 commits
$GIT log -n 5 --pretty=format:'%Cred%h%Creset - %C(yellow)%ae%Creset - %Cgreen%cd%Creset - %s%Creset' --abbrev-commit --date=relative\

echo -n "Which would you like to revert to (enter SHA-1): "  
read GIT_SHA1

if [ -z "$GIT_SHA1" ]; then
  echo "You need to select a commit SHA-1"
  exit 1

else 
echo "Reverting..."
$SSH -l $USER $HOST  "cd '$HOST_HTTP' && '$GIT' reset --hard '$GIT_SHA1'"
fi


