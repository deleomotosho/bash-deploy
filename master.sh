#!/usr/bin/env bash
# about ::
# the master form for deploys and rollbacks.
# there is the part  that sits on one server (staging?)
# and the one on the server that needs to be deployed to (production?)

# Copyright (c) 2012 Dele Omotosho
# GPLv3 : http://www.gnu.org/licenses/gpl-3.0.html

# @variables ==user
# set this accordingly to the path, this primarily calls staging..
SCR_PATH=staging

echo " " 
echo "** ----"
echo "** Welcome to the Deploy System (hit Ctrl+C at anytime to cancel the program) "
echo "** by dele.o | Verivo Software, Inc. | www.verivo.com"
echo "** ----"
echo " "
echo -n "Deploy (d) or Rollback (r): "
read RESPONSE

if [ -z "$RESPONSE" ]; then
  echo "You must choose an options"
  exit 1

else
  if [ "$RESPONSE" == "d" ]; then
     # we want to deploy, call that script .
    . $SCR_PATH/deploy/files-i.sh
    . $SCR_PATH/deploy/db-i.sh
 
  elif [ "$RESPONSE" == "r" ]; then
     # now what do you want to roll back, files or db or both?
     echo -n "What do you want to roll back files (f), database (db) or both (b): "
     read ROLLBACK

     if [ -z "$ROLLBACK" ]; then
       echo -n "you need choose f - files or db - database: "
       read ROLLBACK
     else
       if [ "$ROLLBACK" == "f" ]; then
         . $SCR_PATH/rollback/files-i.sh
    
       elif [ "$ROLLBACK" == "db" ]; then
         . $SCR_PATH/rollback/db-i.sh

       elif [ "$ROLLBACK" == "b" ]; then
         echo "**** Starting with database first ****"
         echo " "
         . $SCR_PATH/rollback/db-i.sh
         echo " "
         echo "**** Now on to the files ****"
         echo " " 
         . $SCR_PATH/rollback/files-i.sh
       fi  
     fi

  fi

fi
