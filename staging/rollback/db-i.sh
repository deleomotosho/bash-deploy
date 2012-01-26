#!/usr/bin/env bash
# about ::
# the master form for deploys and rollbacks.
# there is the part  that sits on one server (staging?)
# and the one on the server that needs to be deployed to (production?)

# Copyright (c) 2012 Dele Omotosho
# GPLv3 : http://www.gnu.org/licenses/gpl-3.0.html


source ../staging.conf

# Run things on the otherserver...
$SSH -l $USER $HOST exec $DLY_PATH/rollback/db-ii.sh
echo "Done :)"









