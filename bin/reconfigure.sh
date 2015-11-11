## Configuration

. /vagrant/etc/conf.sh


cd ${DSPACE_SRC}/dspace/target/dspace-installer

if [ -d ${DSPACE_RUN} ];then
        $ANT -Doverwrite=true update clean_backups
else
    echo "CAN'T RECONFIGURE, no dspace install dir"
fi

OUT=$?
if [ $OUT -eq 0 ];then
   echo "ANT Update successful"
else
   exit $OUT
fi
