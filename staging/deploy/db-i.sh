
#!/usr/bin/env bash
# about ::
# the master form for deploys and rollbacks.
# there is the part  that sits on one server (staging?)
# and the one on the server that needs to be deployed to (production?)

# Copyright (c) 2012 Dele Omotosho
# GPLv3 : http://www.gnu.org/licenses/gpl-3.0.html

# dumps mysql based on the input and cleans up the output



# @variables: SYSTEM a.k.a dependencies
TIMESTAMP=$(date +%a.%F)
MYSQL=/usr/bin/mysql
MYSQLDUMP=/usr/bin/mysqldump
GREP=/bin/grep
SED=/bin/sed
XARGS=/usr/bin/xargs
SCP=/usr/bin/scp
SSH=/usr/bin/ssh
DIFF=/usr/bin/diff
LS=/bin/ls
MAIL=/usr/bin/mail

# == set this accordingly ==
DB_USER="root"   #for the local DB user
DB_PWD="pssttttt!" #db password
PATH_SAVE=//path/where/deploy/db
SCP_DIR=/path/that/exist/deploy/db #!!!important ==>  these path must exist on the hosts, scripts does not check


# it is best to have password-less access to machines that would want to use this,
# assuming you already generated a key: 

RMT_USER="root"
RMT_HOST="8.8.8.8" 
RMT_DB_NAME="my-production-db"
ADMIN_EMAIL="you@something.com"

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
#site_url
  STR1="needle" 	#find this
  STR1_RL="pin" 		#replace with this

  STR2="american"
  STR2_RL="african-heritage"

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



