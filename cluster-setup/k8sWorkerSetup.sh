#!/bin/bash
function printMsg() {
        MSG=$1
        echo "+++++++++++++++++++++++++++++++++++ ${MSG} +++++++++++++++++++++++++"
}
sudo setenforce 0
sudo sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
printMsg "Opening ports in firewall"
sudo firewall-cmd --add-port=10250/tcp
sudo firewall-cmd --add-port=10255/tcp
sudo firewall-cmd --add-port=30000-32767/tcp
sudo firewall-cmd --add-port=6783/tcp
printMsg "Opening ports in firewall done successfully !!"
sudo modprobe br_netfilter
sudo echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
printMsg "Kubernetes repo is created successfully !!"
sudo yum -y install conntrack
printMsg "conntrack is installed successfully !!"
sudo yum install -y docker
sudo systemctl restart docker && sudo systemctl enable docker
printMsg "docker is installed successfully !!" 
sudo yum install kubeadm-1.8.1 kubelet-1.8.1 kubectl-1.8.1 kubernetes-cni-0.5.1 -y
sudo systemctl restart kubelet && sudo systemctl enable kubelet
printMsg "Disabling Swap"
sudo swapoff -a
printMsg "Done now add the node to cluster using join token you got from master"