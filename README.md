# Docker container for RainLoop Webmail CE

[RainLoop Webmail (community edition)](https://www.rainloop.net/) is a free
webmailer licensed under [AGPL v3](http://www.gnu.org/licenses/agpl-3.0.html).

[![](https://images.microbadger.com/badges/version/gmitirol/rainloop.svg)](https://hub.docker.com/r/gmitirol/rainloop)
[![](https://images.microbadger.com/badges/image/gmitirol/rainloop.svg)](https://hub.docker.com/r/gmitirol/rainloop)
[![](https://img.shields.io/docker/stars/gmitirol/rainloop.svg)](https://hub.docker.com/r/gmitirol/rainloop)
[![](https://img.shields.io/docker/pulls/gmitirol/rainloop.svg)](https://hub.docker.com/r/gmitirol/rainloop)

## Docker container

- RainLoop Webmail Community Edition
- Alpine Linux 3.8 with nginx and PHP 7.2; base image [gmitirol/alpine38-php72](https://hub.docker.com/r/gmitirol/alpine38-php72/)
- PHP PDO extensions: SQLite
- PHP Caching extensions: OpCache, APCu
- PHP Directory extensions: LDAP
- Licensed under [GNU Lesser General Public License v3.0](LICENSE)

## Modifications to RainLoop

- Pager option added to display 15 mails/page

## Settings, Options, Parameters

| Description                  | Value                           |
| :--------------------------- | :------------------------------ |
| Webserver port               | `8080`                          |
| Data volume (persistance)    | `/home/project/rainloop/data`   |

## Test run

```bash
docker pull gmitirol/rainloop
docker run -d --name webmail -p 80:8080 --rm gmitirol/rainloop
```
