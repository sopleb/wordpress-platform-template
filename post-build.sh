#!/bin/bash
# Variables
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
rootdir="wordpress"

# Configuring Wordpress
 cp -f siteconfig/wp-config.php $rootdir/wp-config.php

# Deleting Readme.txt
rm -f $rootdir/readme.html
