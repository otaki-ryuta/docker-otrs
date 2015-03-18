#!/bin/bash
#service mysqld start &
#wait
#mysql -uroot -e "CREATE DATABASE otrs;CREATE USER 'otrs'@'localhost' IDENTIFIED BY 'otrs';GRANT ALL PRIVILEGES ON otrs.* TO 'otrs'@'localhost' WITH GRANT OPTION;"&
#wait
#mysql -f -u root otrs < /opt/otrs/scripts/database/otrs-schema.mysql.sql &
#wait
#mysql -f -u root otrs < /opt/otrs/scripts/database/otrs-initial_insert.mysql.sql &
#wait
#/opt/otrs/bin/otrs.SetPassword.pl --agent root@localhost root &
#wait
#/opt/otrs/bin/otrs.RebuildConfig.pl &
#wait
/opt/otrs/bin/Cron.sh start otrs &
#wait
#curl -o Znuny4OTRS-Repo.opm http://portal.znuny.com/api/addon_repos/public/1420
#/opt/otrs/bin/otrs.PackageManager.pl -a install -p Znuny4OTRS-Repo.opm &
#wait
#service httpd start
#wait
service cron start
#exec /usr/sbin/sshd -D

# change Config.pm whether OTRS_ENV value
case ${OTRS_ENV} in
  develop)
    DB_HOST=${MYSQL_PORT_3306_TCP_ADDR}
    DB_USER=root
    DB_PASS=${MYSQL_ENV_MYSQL_ROOT_PASSWORD}
  ;;
  production)
    DB_HOST=${RDS_HOSTNAME}
    DB_USER=${RDS_USERNAME}
    DB_PASS=${RDS_PASSWORD}
  ;;
esac
sed -i \
  -e "s/__DB_HOST__/${DB_HOST}/g" \
  -e "s/__DB_USER__/${DB_USER}/g" \
  -e "s/__DB_PASS__/${DB_PASS}/g" \
  /opt/otrs/Kernel/Config.pm

carton exec starman --preload-app -MDBD::mysql -MKernel::System::Ticket --listen :80 ./bin/cgi-bin/app.psgi
