#
# Load a copy of the SHAREOK db and then upgrade it 
#
. /vagrant/etc/conf.sh
export PGPASSWORD=$DB_PASS

# Remove existing DB and install fresh export
sudo -u tomcat $DSPACE_RUN/bin/dspace database clean
psql -U $DB_NAME -h $DB_HOST $DB_NAME < $DB_EXPORT

# Upgrade Database
sudo -u tomcat $DSPACE_RUN/bin/dspace database migrate

# Remove deprecated Database Browse Tables
sudo -u tomcat $DSPACE_RUN/bin/dspace index-db-browse -f -d

# Delete contents of legacy browse table
cat <<EOF | psql -U $DB_NAME -h $DB_HOST $DBNAME
DELETE FROM COMMUNITIES2ITEM
EOF


# update the discovery index with the new data
sudo -u tomcat $DSPACE_RUN/bin/dspace  index-discovery -b
