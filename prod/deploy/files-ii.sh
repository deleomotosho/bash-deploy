#!/usr/bin/env bash

# about ::
# the master form for deploys and rollbacks.
# there is the part  that sits on one server (staging?)
# and the one on the server that needs to be deployed to (production?)

# Copyright (c) 2012 Dele Omotosho
# GPLv3 : http://www.gnu.org/licenses/gpl-3.0.html


# in alliance with the other servers, this just backs up 
# and update to the most current file per remote...

# @variables == system (aka depends on)
TAR=/bin/tar
GIT=/usr/bin/git
TIMESTAMP=$(date +%a.%F)
GIT_BRN="staging"

# @variables == user, set as desired
BAK_PATH=/path/to/the/backup/folder/on/this/server
HTTP_PATH=/path/to/httpdoc/root #which should be under source control
SITE_NAME="myawesomesite.com" #or a nickname to identify the backup made

echo "Backing up files on server..."
$TAR cPf $BAK_PATH/$SITE_NAME-$TIMESTAMP.tar.gz -z $HTTP_PATH/*
echo "Now migrating files, might take a while..."
cd $HTTP_PATH && $GIT pull origin $GIT_BRN
