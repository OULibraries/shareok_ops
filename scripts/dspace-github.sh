#!/bin/bash

. /vagrant/etc/conf.sh


# Get the Ouatio DSpace Code
# This assumes that ssh keys with github are working
git clone $DSPACE_GIT $DSPACE_SRC

# Set some Git Setings
git config --global push.default simple


