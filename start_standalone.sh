echo "Starting ectd container..."
sudo docker run --net=host -d -it -v /var/etcd/data:/var/etcd/data --name="etcd" \
gcr.io/google_containers/etcd:2.2.5 /usr/local/bin/etcd \
--addr=127.0.0.1:4001 \
--bind-addr=0.0.0.0:4001 \
--data-dir=/var/etcd/data

echo "Starting apiserver container..."
sudo docker run -d --name=apiserver --net=host gcr.io/google_containers/kube-apiserver:v1.7.2 kube-apiserver --insecure-bind-address=10.0.0.5 --service-cluster-ip-range=10.0.0.0/16 --etcd-servers=http://10.0.0.5:4001

echo "Starting controller manager container..."
sudo docker run -d --net=host --name=ControllerM gcr.io/google_containers/kube-controller-manager:v1.7.2 kube-controller-manager --master=10.0.0.5:8080

echo "Starting scheduler container..."
sudo docker run -d --net=host --name=scheduler gcr.io/google_containers/kube-scheduler:v1.7.2 kube-scheduler --master=10.0.0.5:8080
