## Configuration


. /vagrant/etc/conf.sh 


export ANT_OPTS="-Xms128m -Xmx800m"


cd ${DSPACE_SRC}
$MAVEN  -Denv=$MAVEN_PROFILE -Dskiptests clean 
OUT=$?
if [ $OUT -eq 0 ];then
   echo "Maven clear  successful"
else
   exit $OUT
fi

