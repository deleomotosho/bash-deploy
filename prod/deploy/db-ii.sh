#!/usr/bin/env bash

# about ::
# the master form for deploys and rollbacks.
# there is the part  that sits on one server (staging?)
# and the one on the server that needs to be deployed to (production?)

# Copyright (c) 2012 Dele Omotosho
# GPLv3 : http://www.gnu.org/licenses/gpl-3.0.html

# backs up database and migrates to the most recent DB
# depends: db-deploy-i

source ../prod.conf
# Let's roll
# Backup DB
$MYSQLDUMP -u$DB_USER -p$DB_PWD $DB_NAME > $DB_BAK_PATH/$DB_NAME-$TIMESTAMP.bak.sql

# Now move to the move recent DB
echo "Upgrading Live DB..."
$MYSQL  -u$DB_USER -p$DB_PWD $DB_NAME < $DB_DLY_PATH/for_$DB_NAME-$TIMESTAMP.sql 

