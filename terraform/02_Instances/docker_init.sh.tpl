#!/bin/bash
set -x
echo "Install docker"
apt-get update
apt-get install docker.io jq -y
usermod -G docker ubuntu

docker login --username ${registry_user} --password ${registry_secret} ${registry_address}
docker pull ${docker_image}
docker run -d --name nginx -p 80:80 -p 8080:8080 ${docker_image}

ipAddresses=$(echo "{\"privateIP\":\"$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)\", \"publicIP\":\"$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)\"}")
echo $ipAddresses
