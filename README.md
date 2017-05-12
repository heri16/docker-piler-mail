# docker-piler-mail
Piler email archiver as Docker image (http://mailpiler.org)

## Configure New Installation:
```bash
docker run -ti --rm -v /usr/local/etc/piler/:/usr/local/etc/piler:rw heri16/piler-mail
# gather_webserver_data
# gather_mysql_account
# gather_sphinx_data
# gather_smtp_relay_data
# make_cron_entries
# make_new_key
```

## Usage in docker-compose.yml:
```yaml
services:
  piler_indexer:
    build: ./docker-piler-mail
    expose:
      - "26"
      - "9306"
    volumes:
      - /usr/local/etc/piler/:/usr/local/etc/piler:ro
      - /var/piler/store/:/var/piler/store:rw
      - /var/piler/sphinx/:/var/piler/sphinx:rw,Z
      - /var/piler/stat/:/var/piler/stat:rw,Z
      - /var/piler/imap/:/var/piler/imap:rw,Z
      - /var/piler/tmp/:/var/piler/tmp:rw,Z
```
