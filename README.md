# The use of this plugin is now deprecated
This plugin has been deprecated since the removal of the docker-compose default file.
Replace the commands in the plugin by using `docker-compose` (https://github.com/docker/docker.github.io/blob/master/compose/overview.md#common-use-cases) or `docker`

* `z docker:up`
 
This can be done by `docker-compose -p local up -d`
The `-p` provides a prefix so all images are prefixed with `local_`. This is convenient when you want to alias certain `docker exec` calls to an image.

* `z docker:shell php_fpm`

`sudo docker exec -ti local_php_fpm_1 "/bin/bash"`

The `local_` prefix is here visible.

# Docker plugin for `zicht/z` 

Provides a simple wrapper around `docker-compose` with an example for
the `docker-compose.yml` including a version for `php 5.6` and `php 7.1` with sane defaults for other packages such as mysql, nginx, varnish, redis and solr.

# Maintainer(s)
* Philip Bergman <philip@zicht.nl>
