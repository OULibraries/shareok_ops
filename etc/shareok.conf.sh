# Java Environment 
MAVEN_PROFILE=vagrant
MAVEN=mvn
ANT=ant
TOMCAT=/usr/share/tomcat
DS_CFG=/vagrant/shareok_dspace/amzprod.properties
DS_DB_URL=`cat $DS_CFG | grep ^db.url | cut -d "=" -f 2 | xargs`
export ANT_OPTS="-Xms128m -Xmx800m"

# DSpace Paths
DSPACE_SRC=/vagrant/shareok_dspace
DSPACE_RUN=/srv/shareok/dspace
DSPACE_BACKUP=/var/local/backups/dspace

# DSpace Database Configuration
DB_HOST=localhost
#DB_HOST=`echo $DS_DB_URL | cut -d "/" -f 3 | cut -d ":" -f 1`

DB_ADMIN=libacct
DB_ADMIN_PASS=libacct

# Currently using the same name for user and db 
DB_NAME_SRC='shareok_prod_3x'
DB_NAME=dspace
#DB_NAME=`echo $DS_DB_URL | cut -d "/" -f 4 | xargs`
DB_PASS=dspace
#DB_PASS=`cat $DS_CFG | grep ^db.password | cut -d "=" -f 2 | xargs`

#DB_USER=`cat $DS_CFG | grep ^db.username | cut -d "=" -f 2 | xargs`


DB_EXPORT=/vagrant/downloads/shareokprod-dump.sql
