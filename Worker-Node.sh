!#/bin/bash

#Define the Kubernetes version and used CRI-O stream
KUBERNETES_VERSION=v1.30
CRIO_VERSION=v1.30

#Add the Kubernetes repository

curl -fsSL https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/Release.key |
    gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/ /" |
    tee /etc/apt/sources.list.d/kubernetes.list

#Add the CRI-O repository
curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/stable:/$CRIO_VERSION/deb/Release.key |
    gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://pkgs.k8s.io/addons:/cri-o:/stable:/$CRIO_VERSION/deb/ /" |
    tee /etc/apt/sources.list.d/cri-o.list

#Bootstrap a cluster
swapoff -a
modprobe br_netfilter
sysctl -w net.ipv4.ip_forward=1

#Install the packages
apt-get update
apt-get install -y cri-o kubelet kubeadm

#Start CRI-O

systemctl start crio.service
systemctl start kubelet