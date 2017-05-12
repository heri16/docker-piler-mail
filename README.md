# docker-piler-mail
Piler email archiver as docker image (http://mailpiler.org)


## Usage in docker-compose.yml:
```yaml
services:
  piler_indexer:
    build: ./docker-piler-mail
    expose:
      - "26"
      - "9306"
    volumes:
      - /usr/local/etc/:/usr/local/etc:ro
      - /var/piler/store/:/var/piler/store:rw
      - /var/piler/sphinx/:/var/piler/sphinx:rw,Z
      - /var/piler/stat/:/var/piler/stat:rw,Z
      - /var/piler/imap/:/var/piler/imap:rw,Z
      - /var/piler/tmp/:/var/piler/tmp:rw,Z
```

## Example /usr/local/etc/piler.cron:
```cron
### PILERSTART
5,35 * * * * /usr/local/libexec/piler/indexer.delta.sh
30   2 * * * /usr/local/libexec/piler/indexer.main.sh
*/15 * * * * /bin/indexer --quiet tag1 --rotate
*/15 * * * * /bin/indexer --quiet note1 --rotate
30   6 * * * /usr/bin/php /usr/local/libexec/piler/generate_stats.php --webui /var/www/piler
*/5 * * * * /usr/bin/find /var/www/piler/tmp -type f -name i.\* -exec rm -f {} \;
### PILEREND
```
