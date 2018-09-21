#! /bin/bash

set -e

attempt=0

while true; do
  sudo apt -y install apache2 php php-mysql libapache2-mod-php php-xml php-mbstring php-apcu php-intl imagemagick nfs-common percona-toolkit composer php-curl zip && break
  if [ $attempt -ge 5 ]; then
    echo "Failed to install packages after several attempts, giving up..."
    exit 1;
  fi
  sleep 5
  echo "Trying again..."
  attempt=$[$attempt+1]
done

MEDIAWIKI_MAJOR_MINOR_VERSION=$(echo ${MEDIAWIKI_VERSION} | sed -E  's/\.[[:digit:]]+$//g')

# install mediawiki
curl -o /tmp/mediawiki.tar.gz https://releases.wikimedia.org/mediawiki/${MEDIAWIKI_MAJOR_MINOR_VERSION}/mediawiki-${MEDIAWIKI_VERSION}.tar.gz
tar -xvzf /tmp/mediawiki.tar.gz
sudo mkdir /var/lib/mediawiki
sudo mv mediawiki-*/* /var/lib/mediawiki
sudo ln -s /var/lib/mediawiki /var/www/html/w

# install AWS mediawiki extension
git clone --depth 1 https://github.com/edwardspec/mediawiki-aws-s3.git /tmp/AWS
sudo mv /tmp/AWS /var/lib/mediawiki/extensions/
cd /var/lib/mediawiki/extensions/AWS
composer install

### Configure apache
sudo sh -c 'cat << EOF > /etc/apache2/sites-available/mediawiki.conf
<VirtualHost *:80>
        RewriteEngine On
        RewriteRule ^/?article(/.*)?\$ %{DOCUMENT_ROOT}/w/index.php [L]
        RewriteRule ^/*\$ %{DOCUMENT_ROOT}/w/index.php [L]

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html
        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF'

sudo a2enmod rewrite
sudo a2dissite 000-default
sudo a2ensite mediawiki