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
                    ->children()
                        ->arrayNode('defaults')
                            ->children()
                                ->arrayNode('compose')
                                    ->children()
                                        ->scalarNode('name')->isRequired()->end()
                                        ->scalarNode('file')->defaultValue(__DIR__ . '/docker-compose-default.yml')->end()
                                    ->end()
                                ->end()
                            ->end()
                        ->end()
                        ->arrayNode('containers')->prototype('scalar')->end()->end()
                    ->end()
                ->end()
            ->end()
        ;
    }
}