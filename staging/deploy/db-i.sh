
#!/usr/bin/env bash
# about ::
# the master form for deploys and rollbacks.
# there is the part  that sits on one server (staging?)
# and the one on the server that needs to be deployed to (production?)

# Copyright (c) 2012 Dele Omotosho
# GPLv3 : http://www.gnu.org/licenses/gpl-3.0.html

# dumps mysql based on the input and cleans up the output

source ../staging.conf

# ++++ Let's Rock and Roll  ++++
echo -n "What database would you like to dump: "
read DB_NAME

if [ -z "$DB_NAME"  ]; then
   echo " "
   echo "Error: You must enter the database to dump!" 
   echo " "
   exit 1
fi


## clean the dump, prep it with values that will be deployed
## looks in the dir specified above, specifically the most recently dumped SQL
clean_dump(){
$GREP -rl $STR1 $PATH_SAVE/*.sql | $XARGS $SED -i s/$STR1/$STR1_RL/g ; $GREP -rl $STR2 $PATH_SAVE/*.sql | $XARGS $SED -i s/$STR2/$STR2_RL/g; 
}

# pretty straight-forward
send_db() { 
echo "Sending to server ..."
$SCP $CUR_DUMP $RMT_USER@$RMT_HOST:$SCP_DIR
}

# this totally assumes that  ssh is passwordless
# see above for our to set that up 
migrate_db(){
SCRIPT=/home/pyxis/verivo.com/deploy/deploy

$SSH -l $RMT_USER $RMT_HOST exec $SCRIPT/db-ii.sh
echo "Done..."
}

# now email diffs is any
send_diffs(){
echo "Which of these will you want to check the diff against: "
$LS -1 $PATH_SAVE/
echo -n ":: "
read PRE_DUMP #assumes the input will be entered with .sql extension

if [ -z "$PRE_DUMP" ]; then
  echo -n "please select a database: "
  read $PRE_DUMP
fi


if  $DIFF $PATH_SAVE/$PRE_DUMP $PATH_SAVE/for_$RMT_DB_NAME-$TIMESTAMP.sql > /dev/null; then
  echo "No Change in DB"
  echo "Migration Complete :)"
else
 $DIFF -iwy --suppress-common-lines --speed-large-files $PATH_SAVE/$PRE_DUMP $CUR_DUMP | mail -s "Changes in DB Migration $CUR_DUMP" $ADMIN_EMAIL
  echo "Email Sent to $ADMIN_EMAIL ..."
  echo "Migration Complete :)" 
fi

}

# dump selected DB
$MYSQLDUMP --skip-comments -u$DB_USER -p$DB_PWD $DB_NAME > $PATH_SAVE/for_$RMT_DB_NAME-$TIMESTAMP.sql
echo "Dumping done..."
CUR_DUMP="$PATH_SAVE/for_$RMT_DB_NAME-$TIMESTAMP.sql" #save that file  

# now let's:
clean_dump

# and then:
send_db

# now let's migrate the DB
migrate_db

# and finally, show confirmation, 
# and/or send Emails
echo -n "Do you want to email the diff (y or leave blank for no): "
read EMAIL_DIFF

if [ "$EMAIL_DIFF" == "y" ]; then
 send_diffs
else 
 echo "Migration Complete :)"
fi



