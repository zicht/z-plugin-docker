# Docker plugin for `zicht/z` 

Provides a simple wrapper around `docker-compose` with an example for
the `docker-compose.yml` including a version for `php 5.6` and `php 7.1` with sane defaults for other packages such as mysql, nginx, varnish, redis and solr.

## PHP on the CLI
Calling `php` on the docker-image from your local machine:

`docker exec -it local_php_fpm_1 /usr/local/bin/php`

Calling the Symfony `console` on the docker-image from your local machine:

`docker exec -it local_php_fpm_1 /usr/local/bin/php /opt/app/app/console --env=development`

Possibly add these lines in your `bashrc` in an alias.

# Maintainer(s)
* Philip Bergman <philip@zicht.nl>
