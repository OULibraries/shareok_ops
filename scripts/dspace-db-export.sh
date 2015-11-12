#!/bin/bash
. /vagrant/etc/conf.sh
export PGPASSWORD=$DB_PASS

pg_dump --encoding utf8 -ocv -U $DB_NAME_SRC -h $DB_HOST $DB_NAME_SRC > $DB_EXPORT
