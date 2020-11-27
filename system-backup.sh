#!/bin/bash
DATE=$(date +%Y-%m-%d-%H%M%S)
DESTINATION='/backup'
BACKUPFILES='/tmp/system-backup.list'
MYSQLFILE="${DESTINATION}/mariadb-${DATE}.sql"

mysqldump -u root --all-databases > ${MYSQLFILE} 

find ${DESTINATION} -type f -mtime +7 -exec rm -f {} \;

echo '/var/www/phpmyadmin/config.inc.php' >> ${BACKUPFILES}
echo '/var/www/roundcubemail/config/' >> ${BACKUPFILES}
echo '/etc/nginx/pma_pass' >> ${BACKUPFILES}
echo '/etc/nginx/conf.d/' >> ${BACKUPFILES}
echo '/etc/letsencrypt/' >> ${BACKUPFILES}
echo '/etc/nginx/ssl' >> ${BACKUPFILES}
echo '/etc/postfix/' >> ${BACKUPFILES}
echo '/etc/dovecot/' >> ${BACKUPFILES}
echo '/etc/mail/spamassassin/' >> ${BACKUPFILES}
echo '/etc/clamd.d/' >> ${BACKUPFILES}
echo '/etc/proftpd.conf' >> ${BACKUPFILES}
echo '/etc/sysconfig/proftpd' >> ${BACKUPFILES}
echo '/etc/crontab' >> ${BACKUPFILES}
echo '/etc/csf/' >> ${BACKUPFILES}
echo '/etc/php-fpm.d/' >> ${BACKUPFILES}
echo '/etc/php.ini' >> ${BACKUPFILES}
echo '/etc/csf/csf.conf' >> ${BACKUPFILES}
echo '/etc/csf/regex.custom.pm' >> ${BACKUPFILES}
echo '/etc/csf/csf.pignore' >> ${BACKUPFILES}
echo '/etc/opendkim.conf' >> ${BACKUPFILES}
echo '/etc/opendmarc/' >> ${BACKUPFILES}
echo '/etc/opendkim/' >> ${BACKUPFILES}
echo '/etc/opendmarc.conf' >> ${BACKUPFILES}
echo '/etc/opendkim.conf' >> ${BACKUPFILES}
echo '/etc/monitrc' >> ${BACKUPFILES}
echo '/etc/monit.d/' >> ${BACKUPFILES}
echo ${MYSQLFILE} >> ${BACKUPFILES}

tar -czpf "${DESTINATION}/backup-${DATE}.tar.gz" -T ${TMPFILE}
rm -f ${TMPFILE} ${MYSQLFILE} 

rclone copy "${DESTINATION}/backup-${DATE}.tar.gz" ${GOOGLEDRIVE}: 
rclone check "${DESTINATION}/backup-${DATE}.tar.gz" ${GOOGLEDRIVE}: 
rclone delete  ${GOOGLEDRIVE}: --min-age 7d
