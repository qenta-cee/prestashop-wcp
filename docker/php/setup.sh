#!/bin/bash

set -xe

apache2-foreground # > /dev/null 2>&1 &

chmod +x /tmp/wait_for_service.sh
/tmp/wait_for_service.sh ${MYSQL_HOST} 3306

cd /var/www/html 
git clone --depth 1 --branch ${PRESTASHOP_VERSION} https://github.com/PrestaShop/PrestaShop.git .

/usr/bin/composer install --no-interaction
npm -g install npm
npm install
chmod +x tools/assets/build.sh
./tools/assets/build.sh

mkdir -p log app/logs
#chmod +w -R admin-dev/autoupgrade app/config app/logs app/Resources/translations cache config download img log mails modules themes translations upload var
chown -R www-data:www-data /var/www/html

php install-dev/index_cli.php --db_server=db --db_password=root --db_name=prestashop --name=ExampleShop --country=de --language=de --firstname=Max --lastname=Musterman --password=admin123 --email=admin@admin.com

mv install-dev __install-dev

tail -f /dev/stdout
