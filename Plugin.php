<?php

namespace Zicht\Tool\Plugin\Docker;

use \Symfony\Component\Config\Definition\Builder\ArrayNodeDefinition;
use \Zicht\Tool\Plugin as BasePlugin;
use \Zicht\Tool\Container\Container;

/**
* rsync plugin
*/
class Plugin extends BasePlugin
{
    /**
    * Configures the rsync parameters
    *
    * @param \Symfony\Component\Config\Definition\Builder\ArrayNodeDefinition $rootNode
    * @return mixed|void
    */
    public function appendConfiguration(ArrayNodeDefinition $rootNode)
    {
        $rootNode
            ->children()
                ->arrayNode('docker')
                    ->addDefaultsIfNotSet()
                    ->children()
                        ->scalarNode('cmd')->end()
                        ->scalarNode('name_prefix')->defaultValue('')->end()
                        ->scalarNode('image_source')->defaultValue(__DIR__ . '/images')->end()
                        ->scalarNode('image_dir')->defaultValue('docker-images')->end()
                        ->arrayNode('containers')->prototype('scalar')->end()->end()
                        ->arrayNode('images')->prototype('scalar')->end()->end()
                        ->arrayNode('ports')->prototype('scalar')->end()->end()
                        ->arrayNode('links')
                            ->performNoDeepMerging()
                            ->prototype('array')
                                ->prototype('scalar')->end()
                            ->end()
                        ->end()
                        ->arrayNode('volumes')->prototype('array')->prototype('scalar')->end()->end()->end()
                    ->end()
                ->end()
            ->end()
        ;
    }


    public function setContainer(Container $container)
    {
        $container->method('docker.image', function(Container $c, $containerName) {
            return $c->resolve('docker.images.' . $containerName);
        });
        $container->method('docker.run.ports', function(Container $c, $containerName) {
            if ($val = $c->resolve('docker.ports.' . $containerName)) {
                return ' -p ' . $val . ':' . $val;
            }
        });
        $container->method('docker.run.links', function(Container $c, $containerName) {
            if (!$c->has('docker.links.' . $containerName)) {
                return '';
            }
            $ret = '';

            $links = array_intersect(
                $c->get(array('docker', 'containers')),
                $c->get(array('docker', 'links', $containerName)) ?: array()
            );
            foreach ($links as $l) {
                $ret .= sprintf(' --link %s:%s', $l, $l);
            }
            return $ret;
        });
        $container->method('docker.run.volumes', function($c, $containerName) {
            $ret = '';
            $volume = $c->resolve('docker.volumes.' . $containerName, false);
            if ($volume) {
                foreach ($volume as $l) {
                    $ret .= sprintf(' -v %s:%s', $l, $l);
                }
            }
            return $ret;
        });
        $container->method('docker.container_name', function ($c, $containerName) {
            return $c->resolve('docker.name_prefix') . $containerName;
        });
        $container->decl('docker.container_names', function ($c) {
            $ret = array();
            foreach ($c->resolve('docker.containers') as $containerName) {
                $ret[]= $c->call($c->resolve(array('docker', 'container_name')), $containerName);
            }
            return $ret;
        });
    }
}