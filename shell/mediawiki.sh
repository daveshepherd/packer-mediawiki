#! /bin/bash

set -e

until sudo apt -y install apache2 php php-mysql libapache2-mod-php php-xml php-mbstring php-apcu php-intl imagemagick nfs-common percona-toolkit composer php7.2-curl zip
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


git clone --depth 1 https://github.com/edwardspec/mediawiki-aws-s3.git /tmp/AWS
sudo mv /tmp/AWS /var/www/html/mediawiki/extensions/
cd /var/www/html/mediawiki/extensions/AWS
composer install