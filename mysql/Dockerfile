FROM mysql:5.6

COPY mysqld.cnf /etc/mysql/conf.d/

ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 3306
CMD ["mysqld"]
