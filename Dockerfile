FROM centos:7
RUN yum -y update && yum -y install epel-release

RUN yum -y install mysql-devel openssl-devel tre-devel tcp_wrappers-devel memcached-devel tre tcp_wrappers memcached catdoc libpst libzip sysstat poppler-utils unrtf tnef gcc make which cronie && \
  mkdir -p /usr/src/xlhtml-sj-mod && \
  curl -L https://bitbucket.org/jsuto/piler/downloads/xlhtml-0.5.1-sj-mod.tar.gz  | tar --strip-components=1 -xzC /usr/src/xlhtml-sj-mod && \
  cd /usr/src/xlhtml-sj-mod && ./configure && make && make install && \
  yum -y install http://sphinxsearch.com/files/sphinx-2.2.11-1.rhel7.x86_64.rpm && \
  groupadd -g 1001 piler && useradd -u 1001 -g piler -m -s /bin/sh -d /var/piler piler && usermod -L piler && \
  mkdir -p /usr/src/piler && \
  curl -L https://bitbucket.org/jsuto/piler/downloads/piler-1.2.0.tar.gz  | tar --strip-components=1 -xzC /usr/src/piler && \
  cd /usr/src/piler && ./configure --localstatedir=/var --with-database=mysql --enable-tcpwrappers --enable-memcached && make && make install && \
  echo /usr/local/lib > /etc/ld.so.conf.d/local.conf && ldconfig && \
  #cp /usr/local/etc/piler/sphinx.conf.dist /usr/local/etc/piler/sphinx.conf && \
  #ln -sf /usr/local/etc/piler/sphinx.conf /etc/sphinx/sphinx.conf && \
  #cp ./init.d/rc.searchd /etc/init.d/rc.searchd && chmod +x /etc/init.d/rc.searchd && chkconfig --add rc.searchd && \
  sed -e'/load_default_values$/q' ./util/postinstall.sh > /tmp/postinstall.sh && \
  cd /tmp && echo $'make_cron_entries\ncrontab -u $PILERUSER $CRON_TMP\nclean_up_temp_stuff' >> postinstall.sh && sh postinstall.sh && rm postinstall.sh && \
  yum -y remove mysql-devel openssl-devel tre-devel tcp_wrappers-devel memcached-devel gcc make && yum -y autoremove

#VOLUMES ["/usr/local/etc/piler/", "/var/piler/"]

#EXPOSE 25/tcp 9306/tcp

ADD run.sh /sbin/run.sh

CMD ["/sbin/run.sh"]
