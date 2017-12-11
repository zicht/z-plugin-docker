# The use of this plugin is now deprecated
This plugin has been deprecated since the removal of the docker-compose default file.
Replace the commands in the plugin by using `docker-compose` (https://github.com/docker/docker.github.io/blob/master/compose/overview.md#common-use-cases) or `docker`

* `z docker:up` => `docker-compose up -d`

Examples of docker-compose files are available in https://github.com/zicht/docker/tree/master/_project_templates

# Docker plugin for `zicht/z` 

Provides a simple wrapper around `docker-compose` with an example for
the `docker-compose.yml` including a version for `php 5.6` and `php 7.1` with sane defaults for other packages such as mysql, nginx, varnish, redis and solr.

# Maintainer(s)
* Philip Bergman <philip@zicht.nl>
