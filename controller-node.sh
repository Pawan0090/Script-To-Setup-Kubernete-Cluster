!#/bin/bash

#Declare the varibale 
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
apt-get install -y cri-o kubelet kubeadm kubectl

#Start CRI-O
systemctl start crio.service
systemctl start kubelet 

#use the command to install the cluster 
kubeadm init

#export the config file to run the kubernetes command 
export KUBECONFIG=/etc/kubernetes/admin.conf

#cp the config file to perform all the kubenetes command 
cp /etc/kubernetes/admin.conf .kube/config

#Setting up the calcio-Network below command will pull the yaml file 
curl https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/calico.yaml -O

#Apply the manifest using the following command
kubectl apply -f calico.yaml

#command to generate the token
kubeadm token create

#command to print the token neeed to past in the worker-nodes
kubeadm token create --print-join-command

