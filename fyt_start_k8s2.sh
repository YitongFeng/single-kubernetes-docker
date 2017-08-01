#!/bin/bash

# Run ectd container
echo "Starting ectd container..."
sudo docker run -d --net=host --restart=always --name=etcd -v /var/etcd/data:/var/etcd/data gcr.io/google_containers/etcd:3.0.17  /usr/local/bin/etcd --addr=127.0.0.1:4001 --bind-addr=0.0.0.0:4001 --data-dir=/var/etcd/data
# sudo docker run -d --net=host --restart=always --name=etcd -v /var/etcd/data:/var/etcd/data  kubernetes/etcd:2.0.5  /usr/local/bin/etcd --addr=192.168.2.143:4001 --bind-addr=0.0.0.0:4001 --data-dir=/var/etcd/data

export ARCH=amd64
sudo docker run -d -it \
    --volume=/sys:/sys:rw \
    --volume=/var/lib/docker/:/var/lib/docker:rw \
    --volume=/var/lib/kubelet/:/var/lib/kubelet:rw,shared \
    --volume=/var/run:/var/run:rw \
    --net=host \
    --pid=host \
    --privileged \
    --name=hyperkube \
    gcr.io/google_containers/hyperkube:v1.7.2


# sudo docker run -d --net=host --privileged gcr.io/google_containers/hyperkube:v1.7.2 /hyperkube proxy --master=http://127.0.0.1:8080 --v=2
