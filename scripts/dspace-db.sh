#!/bin/bash
. /vagrant/etc/conf.sh
export PGPASSWORD=$DB_ADMIN_PASS

# Create DSpace Database and User using standard admin account
cat <<EOF | psql -U $DB_ADMIN -h $DB_HOST -d postgres
CREATE USER $DB_NAME WITH PASSWORD '$DB_PASS';
-- have to be a member of a role before we can give it a db 
GRANT $DB_NAME TO $DB_ADMIN;
CREATE DATABASE $DB_NAME WITH OWNER=$DB_NAME ENCODING='UNICODE';
REVOKE $DB_NAME FROM $DB_ADMIN;
-- probably good to clean up privleges 
EOF
