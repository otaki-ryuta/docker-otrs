FROM centos:centos6
MAINTAINER Johannes Nickel <jn@znuny.com>
MAINTAINER Ryuta Otaki <otaki.ryuta@classmethod.jp>

RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
RUN yum update -y
RUN yum -y install \
  mysql \
  procmail \
  cronie \
  httpd httpd-devel \
  perl-core \
  mod_perl 
RUN yum -y install \
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
  "perl(YAML::XS)"

#OTRS
RUN rpm -ivh http://ftp.otrs.org/pub/otrs/RPMS/rhel/6/otrs-4.0.5-01.noarch.rpm

#OTRS COPY Configs
ADD Config.pm    /opt/otrs/Kernel/Config.pm
RUN chgrp apache /opt/otrs/Kernel/Config.pm
RUN chmod g+w    /opt/otrs/Kernel/Config.pm

#reconfigure httpd
RUN sed -i "s/mod_perl.c/mod_perl.so/" /etc/httpd/conf.d/zzz_otrs.conf
RUN sed -i "s/error\/noindex.html/otrs\/index.pl/" /etc/httpd/conf.d/welcome.conf

#enable crons
#WORKDIR /opt/otrs/var/cron/
#USER otrs
#CMD ["/bin/bash -c 'for foo in *.dist; do cp $foo `basename $foo .dist`; done'"]

USER root
EXPOSE 80
CMD ["httpd", "-DFOREGROUND"]
