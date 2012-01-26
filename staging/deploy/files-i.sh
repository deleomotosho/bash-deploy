#!/usr/bin/env bash

# about ::
# the master form for deploys and rollbacks.
# there is the part  that sits on one server (staging?)
# and the one on the server that needs to be deployed to (production?)

# Copyright (c) 2012 Dele Omotosho
# GPLv3 : http://www.gnu.org/licenses/gpl-3.0.html


# deploy files primarily using Git

source ../staging.conf

# naviaget to  the web root dir
cd  $HTTP_PATH

if [ -n "$(git status --porcelain)" ]; then # sweet suggestion from @eckes on http://bit.ly/xDVUfK
  echo "The following changes where made: "
  $GIT status --short
  echo " "
  echo "We currently at: "
  echo "---------" 
  $GIT describe --abbrev=0 --tags
  echo "---------" 
  echo -n "What is this release TAG (don't add "v"): "
  read GIT_TAG
  echo -n "COMMIT message: "
  read GIT_COMMIT
  echo -n "Release NOTES: "
  read GIT_NOTES
  
  $GIT . && $GIT commit -am $GIT_COMMIT
  $GIT tag v$GIT_TAG
  $GIT notes add -m $GIT_NOTES
  echo  "Do you want to email the diffs (y or leave blank for no)"
  read EMAIL_DIFF

  if [ "$EMAIL_DIFF" == "y" ]; then
     $GIT diff | mail -s "Diff of recent migration $GIT_HASH"  $ADMIN_EMAIL
     echo "Diff of the most recent commit (" $GIT_HASH ") Sent to " $ADMIN_EMAIL
  else
     echo  "Ok, no emailing boss..."
  fi

  # push to remote specific branch
  # this can in fact be the production branch and use a hook on that server to pull off the rest
  # but this doesn't do that [by default]....  
  $GIT push origin $GIT_BRN

  # ... we call a remote script to do some clean up job, 
  # like, create a backup before a pull
  $SSH -l $USER $HOST exec $DLY_PATH/deploy/files-ii.sh
  echo "Done..."

else
  echo "No newer files to migrate"
  echo "Moving on ..."
fi





