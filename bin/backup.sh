#!/bin/bash

. /vagrant/etc/conf.sh


## DSpace Daily backup. 1 week retention.
# ${DSPACE_RUN} location of DSpace
# ${DSPACE_BACKUP} backup destination
OWNER=root:wheel                                # unix owner and group of the backups. owner can write, group can read.

#You should not have to change anything below this line

CAT=/bin/cat
CHMOD=/bin/chmod
CHOWN=/bin/chown
CUT=/bin/cut
GREP=/bin/grep
GZIP=/bin/gzip
MKDIR=/bin/mkdir
TAR=/bin/tar
PGDUMP=/usr/bin/pg_dump
PRINTF=/usr/bin/printf
XARGS=/usr/bin/xargs
SUDO=''
if (( $EUID != 0 )); then
    SUDO='/usr/bin/sudo'
fi

## Read useful values out of the config file

DS_CFG=${DSPACE_RUN}/config/dspace.cfg                   # DSpace Config File
DS_DB_URL=`$SUDO $CAT $DS_CFG | $SUDO $GREP ^db.url | $SUDO $CUT -d "=" -f 2 | $SUDO $XARGS`
DS_DB_HOST=`$SUDO echo $DS_DB_URL | $SUDO $CUT -d "/" -f 3 | $SUDO $CUT -d ":" -f 1`
DS_DB_PORT=`$SUDO echo $DS_DB_URL | $SUDO $CUT -d "/" -f 3 | $SUDO $CUT -d ":" -f 2`
DS_DB=`$SUDO echo $DS_DB_URL | $SUDO $CUT -d "/" -f 4 | $SUDO $XARGS`
DS_USER=`$SUDO $CAT $DS_CFG | $SUDO $GREP ^db.username | $SUDO $CUT -d "=" -f 2 | $SUDO $XARGS`
DS_PASS=`$SUDO $CAT $DS_CFG | $SUDO $GREP ^db.password | $SUDO $CUT -d "=" -f 2 | $SUDO $XARGS`
DS_ASSET=`$SUDO $CAT $DS_CFG | $SUDO $GREP ^assetstore.dir | $SUDO $CUT -d "=" -f 2 | $SUDO $XARGS`

## We definitely want a file backup the DSpace directory.
## If asset store is outside the main ojs directory, we'll add that to the backup as well.
DIRECTORIES=${DSPACE_RUN}
if [[ $DS_ASSET != ${DSPACE_RUN}/* ]]; then
        DIRECTORIES="$DIRECTORIES $DS_ASSET"
fi

PATH=/usr/local/bin:/usr/bin:/bin
TIMEDIR=${DSPACE_BACKUP}/last-full                    # where to store time of full backup
DOW=`date +%a`                                  # Day of the week e.g. Mon
DOM=`date +%d`                                  # Date of the Month e.g. 27
DM=`date +%d%b`                                 # Date and Month e.g. 27Sep

# Make destination dirs if they don't exist
$SUDO $MKDIR -p ${DSPACE_BACKUP};
$SUDO $MKDIR -p $TIMEDIR;

# Daily DB dump
export PGPASSWORD=$DS_PASS
$SUDO $PGDUMP -U $DS_USER -h $DS_DB_HOST -p $DS_DB_PORT -Fc $DS_DB  > ${DSPACE_BACKUP}/$HOSTNAME-$DOW.psql

# # Weekly full backup
# if [ $DOW = "Sun" ]; then
#         NEWER=""
#         NOW=`date +%d-%b`
# 
#         # Update full backup date
#         $SUDO echo $NOW > $TIMEDIR/$HOSTNAME-full-date
#         $SUDO $TAR $NEWER -czf ${DSPACE_BACKUP}/$HOSTNAME-$DOW.tar.gz $DIRECTORIES
# 
# # Make incremental backup - overwrite last weeks
# else
# 
#         # Get date of last full backup
#         NEWER="--newer `$SUDO $CAT $TIMEDIR/$HOSTNAME-full-date`"
#         $SUDO $TAR $NEWER -czf ${DSPACE_BACKUP}/$HOSTNAME-$DOW.tar.gz $DIRECTORIES
# fi

# Set permissions for backups to root-writeable and wheel readable
$SUDO $CHOWN -R $OWNER ${DSPACE_BACKUP}
$SUDO $CHOWN -R $OWNER $TIMEDIR
$SUDO $CHMOD 750 ${DSPACE_BACKUP}
$SUDO $CHMOD 750 $TIMEDIR
$SUDO $CHMOD 650 ${DSPACE_BACKUP}/$HOSTNAME-$DOW.tar.gz
$SUDO $CHMOD 650 ${DSPACE_BACKUP}/$HOSTNAME-$DOW.psql
$SUDO $CHMOD 650 $TIMEDIR/$HOSTNAME-full-date
