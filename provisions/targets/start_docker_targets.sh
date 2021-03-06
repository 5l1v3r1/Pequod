#!/bin/bash
# kill any running docker containers, in case we provision while vm is running
docker rm $(docker ps -aq) 
#pushd /home/vagrant/.scripts/targets/docker_socket/
pushd /home/vagrant/.scripts/targets/docker_socket/
echo "Setting up docker socket target..."
docker build . -t docker_sock_mount
popd
echo "Starting up docker target: docker_sock_mount..."
docker run -d -v /var/run/docker.sock:/var/run/docker.sock:ro --name docker_sock_mount docker_sock_mount
pushd /home/vagrant/.scripts/targets/docker_php_app/
# leave off ro here, like a fool. So that we can make changes to the folder on the root.
docker build . -t docker_php_app
docker run -d -v /home/vagrant/.scripts/targets/docker_php_app/app:/app -v /var/run/docker.sock:/var/run/docker.sock -p 8000:8000 --name docker_sock_mount --name scma docker_php_app
popd
# pushd /home/ahab/.scripts/targets/docker_status_page/
# docker build . -t docker_status_page
# popd
# docker run -p 5000:5000 -d -v /var/run/docker.sock:/var/run/docker.sock:ro --name docker_status_page docker_status_page