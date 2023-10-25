#!/bin/bash

# Update package list
sudo apt-get update && sudo apt-get upgrade -y

# Install Docker
sudo apt-get install -y docker.io

# Start Docker service
sudo systemctl start docker

# Enable Docker to start on boot
sudo systemctl enable docker

# Add the ubuntu user to the docker group
sudo usermod -aG docker ubuntu

# Install kubeadm, kubelet, and kubectl
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo swapoff -a

sudo modprobe overlay
sudo modprobe br_netfilter

sudo tee -a /etc/sysctl.conf <<-EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl -p

sudo kubeadm init > output.txt



mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config




curl https://raw.githubusercontent.com/projectcalico/calico/v3.26.3/manifests/calico.yaml -O

kubectl apply -f calico.yaml
export KUBECONFIG=/etc/kubernetes/admin.conf


tail -n 2 output.txt > kubejoin.sh

IFS=',' read -ra ADDR <<< "$KUBE_NODE_IPS"
for ip in "${ADDR[@]}"; do
    echo "$ip" > "/tmp/kube_node_${i}_ip.txt"
    ssh-keyscan $ip >> ~/.ssh/known_hosts
    scp -i /home/ubuntu/.ssh/id_rsa /home/ubuntu/kubejoin.sh ubuntu@$ip:/home/ubuntu/
    # Other operations related to each worker IP...
done


curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

sudo apt-get install git

git clone https://github.com/nidzo11/DevOps.git

# sudo kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/ecr/?ref=master"


