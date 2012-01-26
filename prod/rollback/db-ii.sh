#!/usr/bin/env bash
# about ::
# the master form for deploys and rollbacks.
# there is the part  that sits on one server (staging?)
# and the one on the server that needs to be deployed to (production?)

# Copyright (c) 2012 Dele Omotosho
# GPLv3 : http://www.gnu.org/licenses/gpl-3.0.html


# @variaeble ==system
MYSQL=/usr/bin/mysql

# @variables ==user, adjust as needed
DB_USER="root"
DB_PWD="pssstttt!"
DB_NAME="my-production-db"
BAK_PATH=/path/to/database-backups

cd $BAK_PATH
echo "This are the available backups: "; ls

echo -n "Which will you want to roll back to (without 'bak.sql'): "
read SQL_BAK 

# revert from dump, uses the variable from ../rollback/db-i.bak.sql
echo "Rolling back ..."
$MYSQL -u$DB_USER -p$DB_PWD $DB_NAME < $BAK_PATH/$SQL_BAK.bak.sql
