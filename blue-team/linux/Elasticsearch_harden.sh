#!/bin/bash

# Set up field data cache and breaker limit
echo "indices.fielddata.cache.size: 75%
indices.breaker.fielddata.limit: 40%" >> /etc/elasticsearch/elasticsearch.yml

# Update heap size
echo "ES_HEAP_SIZE=31g" >> /etc/sysconfig/elasticsearch

# Seperate out nodes

# Data nodes
echo "node.master: false
node.data: true" >> /etc/elasticsearch/elasticsearch.yml

# Client nodes
echo "node.master: false
node.data: false" >> /etc/elasticsearch/elasticsearch.yml

# Master nodes
echo "node.master: true
node.data: false" >> /etc/elasticsearch/elasticsearch.yml

# Avoid split brain!
echo "discovery.zen.minimum_master_nodes: 2" >> /etc/elasticsearch/elasticsearch.yml

# Enable mlockall 
echo "bootstrap.mlockall: true" >> /etc/elasticsearch/elasticsearch.yml

# Set up authentication
echo "http.basic.enabled: true
http.basic.username: elasticsearch
http.basic.password: <Password>" >> /etc/elasticsearch/elasticsearch.yml

# Start the cluster
service elasticsearch start