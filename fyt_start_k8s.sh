#!/bin/bash

# Run ectd container
echo "Starting ectd container..."
sudo docker run -d --name="etcd" gcr.io/google_containers/etcd:3.0.17 \
                                      --addr=127.0.0.1:4001 \
                                      --bind-addr=0.0.0.0:4001 \
                                      --data-dir=/var/etcd/data 

# Run apiserver container
echo "Starting apiserver container..."
sudo docker run -d --link etcd:etcd --name="apiserver" cockpit/kubernetes:latest kube-apiserver \
                                                         --service-cluster-ip-range=10.0.0.1/24 \
                                                         --insecure-bind-address=0.0.0.0 \
                                                         --etcd_servers=http://etcd:4001

sleep 10

# Run controller-manager container
echo "Starting controller-manager container..."
sudo docker run -d --link apiserver:apiserver --name="controller-manager" cockpit/kubernetes:latest kube-controller-manager --master=http://apiserver:8080                                                                           

# Run scheduler container
echo "Starting scheduler container..."
sudo docker run -d --link apiserver:apiserver --name="scheduler" cockpit/kubernetes:latest kube-scheduler --master=http://apiserver:8080 
                                                                                                                  
# Run kubelet container
echo "Starting kubelet container..."
sudo docker run -d --link apiserver:apiserver --pid=host -v /var/run/docker.sock:/var/run/docker.sock --name="kubelet"  cockpit/kubernetes:latest kubelet \
                                                                                                                      --api_servers=http://apiserver:8080 \
                                                                                                                      --address=0.0.0.0 \
                                                                                                                      --hostname_override=127.0.0.1 \
                                                                                                                      --cluster_dns=10.0.0.10 \
                                                                                                                      --cluster_domain="kubernetes.local" \
                                                                                                                      --pod-infra-container-image="index.alauda.cn/kiwenlau/pause:0.8.0"
                                                                                                   
# Run proxy container
echo "Starting proxy container..."
sudo docker run -d --link apiserver:apiserver --privileged --name="proxy" cockpit/kubernetes:latest kube-proxy --master=http://apiserver:8080 

#Run kubectl container
echo "Starting kubectl container..."                                                                 
sudo docker run -id --link apiserver:apiserver -e "KUBERNETES_MASTER=http://apiserver:8080" --name="kubectl" --hostname="kubectl" cockpit/kubernetes:latest bash 

#Get into the kubectl container
sudo docker exec -it kubectl bash

