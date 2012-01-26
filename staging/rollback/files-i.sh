#!/usr/bin/env bash

# about ::
# the master form for deploys and rollbacks.
# there is the part  that sits on one server (staging?)
# and the one on the server that needs to be deployed to (production?)

# Copyright (c) 2012 Dele Omotosho
# GPLv3 : http://www.gnu.org/licenses/gpl-3.0.html


# @variable ==system
GIT=/usr/bin/git
SSH=/usr/bin/ssh

# @variables ==user, adjust as needed
USER="root"
HOST="8.8.8.8"
DLY_PATH=/path/to/deploy
HTTP_PATH=/var/www/vhosts/my-something-site
HOST_HTTP=/var/www/vhosts/verivo.com/verivo.com/httpdocs

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
$SSH -l $USER $HOST  "cd '$HOST_HTTP' && '$GIT' checkout '$GIT_SHA1'"
fi


