#! /bin/bash

set -e

until sudo apt-get -y install apache2 php php-mysql libapache2-mod-php php-xml php-mbstring php-apcu php-intl imagemagick
do
  echo "Try again"
  sleep 5
done

MEDIAWIKI_MAJOR_MINOR_VERSION=$(echo ${MEDIAWIKI_VERSION} | sed -E  's/\.[[:digit:]]+$//g')

curl -o /tmp/mediawiki.tar.gz https://releases.wikimedia.org/mediawiki/${MEDIAWIKI_MAJOR_MINOR_VERSION}/mediawiki-${MEDIAWIKI_VERSION}.tar.gz

tar -xvzf /tmp/mediawiki.tar.gz

sudo mkdir /var/lib/mediawiki

sudo mv mediawiki-*/* /var/lib/mediawiki

sudo ln -s /var/lib/mediawiki /var/www/html/mediawiki