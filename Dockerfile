FROM centos:7
MAINTAINER Johannes Nickel <jn@znuny.com>
MAINTAINER Ryuta Otaki <otaki.ryuta@classmethod.jp>

RUN yum install -y epel-release
RUN yum update -y
RUN yum -y install \
  mariadb \
  procmail \
  cronie \
  httpd httpd-devel \
  perl-core \
  mod_perl \
  "perl(Apache2::Reload)" \
  "perl(Archive::Zip)" \
  "perl(Crypt::Eksblowfish::Bcrypt)" \
  "perl(Crypt::SSLeay)" \
  "perl(Date::Format)" \
  "perl(Encode::HanExtra)" \
  "perl(GD)" \
  "perl(GD::Text)" \
  "perl(GD::Graph)" \
  "perl(JSON::XS)" \
  "perl(IO::Socket::SSL)" \
  "perl(LWP::UserAgent)" \
  "perl(Mail::IMAPClient)" \
  "perl(Net::DNS)" \
  "perl(Net::LDAP)" \
  "perl(PDF::API2)" \
  "perl(URI)" \
  "perl(Template)" \
  "perl(Text::CSV_XS)" \
  "perl(XML::Parser)" \
  "perl(YAML::XS)" \
  "perl(DBD::mysql)"

#OTRS
RUN rpm -ivh http://ftp.otrs.org/pub/otrs/RPMS/rhel/7/otrs-4.0.6-01.noarch.rpm

#OTRS COPY Configs
ADD otrs/Config.pm /opt/otrs/Kernel/Config.pm
RUN chgrp apache   /opt/otrs/Kernel/Config.pm
RUN chmod g+w      /opt/otrs/Kernel/Config.pm

#reconfigure httpd
ADD httpd/zzz_otrs.conf /etc/httpd/conf.d/zzz_otrs.conf
RUN rm /etc/httpd/conf.d/welcome.conf

#enable crons
#WORKDIR /opt/otrs/var/cron/
#USER otrs
#CMD ["/bin/bash -c 'for foo in *.dist; do cp $foo `basename $foo .dist`; done'"]

USER root
EXPOSE 80
CMD ["httpd", "-DFOREGROUND"]
