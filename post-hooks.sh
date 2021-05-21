#!/bin/bash
# Variables
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
rootdir="wordpress"
# Deleting default plugins and themes
rm -Rf $rootdir/wp-content/plugins/*
rm -Rf $rootdir/wp-content/themes/*
rm -Rf $rootdir/wp-content/mu-plugins/*

# Installing Must-Use Repository plugins
mkdir -p $rootdir/wp-content/mu-plugins
for file in ./mu-plugins/*
do
  filename=$(basename $file)
  if [ "$filename" != "README.md" ]; then
    ln -s -f /app/mu-plugins/"$filename" $rootdir/wp-content/mu-plugins
  fi
done

# Installing Repository plugins
mkdir -p $rootdir/wp-content/plugins
for file in plugins/*
do
  filename=$(basename $file)
  if [ "$filename" != "README.md" ]; then
    ln -s -f /app/plugins/"$filename" $rootdir/wp-content/plugins
  fi
done

# Installing Memcached
ln -s -f ./plugins/redis-cache/includes/object-cache.php $rootdir/wp-content/

# Move all plugins that are installed via composer to the plugins folder
cp -R -f plugins/* $rootdir/wp-content/plugins

# Cleaning up composer
# rm -Rf wp-content

# Installing themes
mkdir -p $rootdir/wp-content/themes
for file in themes/*
do
  filename=$(basename $file)
  if [ "$filename" != "README.md" ]; then
    ln -s -f /app/themes/"$filename" $rootdir/wp-content/themes/
  fi
done

# Mapping upload folder
# rm -f ../www/wp-content/uploads
# ln -s -f ../../shared/uploads ../www/wp-content/uploads

# Deleting Readme.txt
# rm -f $rootdir/readme.html

#Configuring WP-Super-Cache
if [ ! -f "${rootdir}wp-content/wp-cache-config.php" ]; then
  sed "s|##rootdir##|${SCRIPTDIR}/${rootdir}|g" cacheconfig/wp-cache-config.php > ${rootdir}/wp-content/wp-cache-config.php
  chmod 0666 ${rootdir}/wp-content/wp-cache-config.php
fi
if [ ! -f "${rootdir}wp-content/advanced-cache.php" ]; then
  cp -f cacheconfig/advanced-cache.php ${rootdir}/wp-content/
fi
