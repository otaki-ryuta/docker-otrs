FROM yuuk1/perl:5.20.1

MAINTAINER Ryuta Otaki <otaki.ryuta@classmethod.jp>

RUN apt-get update && \
    apt-get install -yqq --no-install-recommends \
      cron \
      fonts-ipafont-gothic \
      fonts-ipafont-mincho \
      libgd2-xpm-dev \
      libmysqlclient-dev \
      libssl-dev \
      mysql-client-5.5 \
      procmail \
    && \
    apt-get clean && \
    rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# download OTRS 
RUN curl -sL https://github.com/OTRS/otrs/archive/rel-4_0_6.tar.gz | tar -zxf - && mv otrs-rel-* /opt/otrs
ENV APPROOT /opt/otrs
WORKDIR /opt/otrs

COPY cpanfile $APPROOT/cpanfile
RUN carton install

#OTRS COPY Configs
ADD Config.pm  /opt/otrs/Kernel/Config.pm
#RUN chgrp apache   /opt/otrs/Kernel/Config.pm
#RUN chmod g+w      /opt/otrs/Kernel/Config.pm

#enable crons
RUN mkdir /opt/otrs/var/tmp/
WORKDIR /opt/otrs/var/cron/
RUN useradd -s /bin/false -d /opt/otrs otrs && chown otrs /opt/otrs/var/cron/* /opt/otrs/var/cron 
USER otrs
RUN bash -c 'for foo in *.dist; do cp $foo `basename $foo .dist`; done'
WORKDIR /opt/otrs
USER root

EXPOSE 80

ADD run.sh /run.sh
CMD ["/run.sh"]
