#!/usr/bin/env bash

name=my-cluster
nodes=2
registry_name=k3d-my-registry
max="$(($nodes-1))"

k3d cluster delete $name
k3d registry delete $registry_name

k3d cluster create $name -a $nodes \
    -p 8080:80@loadbalancer \
    -p "8443:443@loadbalancer" \
    --api-port 6443 \
    --registry-create $registry_name:0.0.0.0:5000 \
    -e "HTTP_PROXY=$http_proxy@server:0" \
    -e "HTTPS_PROXY=$http_proxy@server:0" \
    -e "http_proxy=$http_proxy@server:0" \
    -e "https_proxy=$http_proxy@server:0" \
    -e "NO_PROXY=$registry_name,$no_proxy@server:0" \
    -e "HTTP_PROXY=$http_proxy@agent:0-$max" \
    -e "HTTPS_PROXY=$http_proxy@agent:0-$max" \
    -e "http_proxy=$http_proxy@agent:0-$max" \
    -e "https_proxy=$http_proxy@agent:0-$max" \
    -e "NO_PROXY=$registry_name,$no_proxy@agent:0-$max" 
