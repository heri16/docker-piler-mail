# docker-piler-mail
Piler email archiver as Docker image (http://mailpiler.org)

## Configure New Installation:
```bash
git clone https://github.com/heri16/docker-piler-mail.git
cp docker-piler-mail/usr/local/etc/piler/piler.conf.dist docker-piler-mail/usr/local/etc/piler/piler.conf
mv docker-piler-mail/usr/local/etc/piler/. /usr/local/etc/piler/
docker run -ti --rm -v /usr/local/etc/piler/:/usr/local/etc/piler:rw,Z heri16/piler-mail
# display_install_intro
# gather_mysql_account
# make_new_key
# make_certificate
```

## Usage in docker-compose.yml:
```yaml
services:
  piler_indexer:
    build: ./docker-piler-mail
    expose:
      - "25"
      - "9306"
    volumes:
      - /usr/local/etc/piler/:/usr/local/etc/piler:ro
      - /var/piler/store/:/var/piler/store:rw
      - /var/piler/sphinx/:/var/piler/sphinx:rw,Z
      - /var/piler/stat/:/var/piler/stat:rw,Z
      - /var/piler/imap/:/var/piler/imap:rw,Z
      - /var/piler/tmp/:/var/piler/tmp:rw,Z
```
