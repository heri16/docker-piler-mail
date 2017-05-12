#!/bin/bash
set -e

pid=0

# SIGTERM-handler
term_handler() {
  if [ $pid -ne 0 ]; then
    /etc/init.d/rc.searchd stop
    /etc/init.d/rc.piler stop
    kill -SIGTERM "$pid"
    wait "$pid"
  fi
  exit 143; # 128 + 15 -- SIGTERM
}

# setup handlers
# on callback, kill the last background process, which is `tail -f /dev/null` and execute the specified handler
#trap 'kill ${!}; my_handler' SIGUSR1
trap 'kill ${!}; term_handler' SIGTERM

# Start crond for piler tasks
if [ -f /usr/local/etc/piler.crontab ]; then
  crontab -u piler /usr/local/etc/piler.crontab
fi
crond
pid="$!"

# Start services
/etc/init.d/rc.piler start
/etc/init.d/rc.searchd start

# wait forever
while true
do
  tail -f /dev/null & wait ${!}
done
