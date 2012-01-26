## TOC
+ [WTF is this?](#wtf)
+ [Basic Assumptions](#basic-assumptions)
+ [What your system needs](#system-needs)
+ [Useage](#how-to)
+ [Appendix](#appendix)

### WTF is this? {#wtf}
This tool was originally inspired by the need to deploy a wordpress based site in an efficient manner, understanding the way wordpress handles things made it a bit tricky using other great tools like Phing, or Capistrano, wait, Konstantin Kovshenin at theme.fm has an excellent tutorial on using [Cap with WP](http://theme.fm/2011/08/tutorial-deploying-wordpress-with-capistrano-2082/); it was too inflexible in my opinion to be used _*efficiently*_ with wordpress.

Quick fix: build one. Down the line, this will be a full fledged Ruby stuff -- umm, ruby fanciness I hear...

This has a rollback and deploy system between two computers, one acting as a staging/test/dev and the other a production -- this can in fact be extended to deploy or rollback from several units/servers.

Please see the Appendix for list of needed variables to make things hum.

### Basic Assumptions ### {#basic-assumptions}
+ You have some experience using *NIX based commandline tools
   + it relies a lot on *nix tools, cd, ssh, tar, etc
+ You codes are under "Git" source control
+ You don't mind editing this source code, there are a few variables to set to make things work

### What you need on your system ### {#system-needs}
+ Obviously servers or computers running some *nix variant.
+ "Git" on all servers.
+ SSH server & client

### How to Use {#how-to}
`git clone git@github.com:delomos/bash-deploy`
`chmod +x bash-deploy/master.sh`
`./bash-deploy/master.sh`

The directory "prod/" sits on the server being deployed to, and directory "staging" sits on the test/staging server.

### Appendix {#appendix}
 + BAK_PATH: where should the HTTP files be backed up to, before a deploying.
 + HTTP_PATH: the physical path to your www, NOT an http://whatever/whetever; more like, /var/www/vhosts/myawesomesite.com/httpdocs, or somethinglike that (ref HOST_HTTP).
 + SITE_NAME: your site's name, or nickname, this is just used when naming your backup before a migration.
 + SCR_PATH: the [full] path to where this dir/ lives (generally, the folder that houses "master.sh").
 + DB_USER: the username of the database, with enough priviledges.
 + DB_PWD: the password of the DB_USER above.
 + DB_NAME: the database name to migrate with (to/from) (ref DB_NAME).
 + DB_DLY_PATH: the path that newer mysqldumps are being stored (ref SCP_DIR).
 + DB_BAK_PATH: the path that DB backups will be stored. 
 + DLY_PATH: the deploy path on the server (the root of prod/deploy)
 + PATH_SAVE: path to store DB dumps that will be deployed
 + SCP_DIR: see DB_DLY_PATH
 + RMT_USER: an authorized user (who can ssh into the specified box), preferably using keyless ssh
 + RMT_HOST: SSH host IP, or name
 + GIT_BRN: git branch that holds your source code (this is where production pulls from)
 + RMT_DB_NAME: see DB_NAME
 + ADMIN_EMAIL: your email, if you want to get mails of diffs after deployment (optional)? 
 + HOST_HTTP: see HTTP_PATH
 
 ##### Notes on staging/deploy/db-i.sh::clean_db() 
 + STR1 (needle): a string you want to replace in the database
 + STR1_RL: a string you want to replace it with.
 
 ##### Set-up keyless SSH 
`ssh-keygen -t rsa` (accept defaults)
`cat ~/.ssh/id_rsa.pub | ssh -l uname host.myhost cat >> ~/.ssh/authorized_keys`