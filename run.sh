#!/bin/bash -e
[ -n "$DEBUG" ] && set -x

pid=0

# SIGTERM-handler
term_handler() {
  if [ -n "$pid" ] && [ $pid -ne 0 ]; then
    /etc/init.d/rc.searchd stop
    /etc/init.d/rc.piler stop
    kill -SIGTERM "$pid"
    wait "$pid"
  fi
  exit 143; # 128 + 15 -- SIGTERM
}

# First-time config
if [ ! -f /usr/local/etc/piler/sphinx.conf ]; then
  yum install -y mysql openssl
  sed -e'/load_default_values$/q' /usr/src/piler/util/postinstall.sh > /tmp/postinstall.sh
  cd /usr/src/piler
  (set +e
    source /tmp/postinstall.sh
    rm -rf ./webui
    preinstall_check
    display_install_intro
    gather_mysql_account
    make_new_key
    show_summary
    execute_post_install_tasks
    clean_up_temp_stuff
  )
  exit
fi

# setup handlers
# on callback, kill the last background process, which is `tail -f /dev/null` and execute the specified handler
#trap 'kill ${!}; my_handler' SIGUSR1
trap 'kill ${!}; term_handler' SIGTERM

# Start crond for piler tasks
if [ -f /usr/local/etc/piler/crontab.piler ]; then
  crontab -u piler /usr/local/etc/piler/crontab.piler
fi
crond
pid="$!"

# Start services
/etc/init.d/rc.piler start
/etc/init.d/rc.searchd start || su piler -c "indexer --all --config /usr/local/etc/piler/sphinx.conf"

# wait forever
while true
do
  tail -f /dev/null & wait ${!}
done
