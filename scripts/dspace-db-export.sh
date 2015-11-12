#!/bin/bash
. /vagrant/etc/conf.sh
export PGPASSWORD=$DB_ADMIN_PASS

pg_dump --encoding utf8 -ocv -U $DB_NAME -h $DB_HOST $DB_NAME > $DB_EXPORT
