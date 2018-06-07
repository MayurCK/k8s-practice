#!/bin/bash
function printEcho() {
        MSG=$1
        echo "+++++++++++++++++++++++++++++++++++ ${MSG} +++++++++++++++++++++++++"
}
printEcho "Cleaning up k8s cluster"
sudo kubeadm reset
cd $HOME/.kube
sudo rm -rf config
printEcho "Done"
echo 
printEcho "removing kubeadm kubelet kubectl kubernetes-cni"
sudo yum remove kubeadm kubelet kubectl kubernetes-cni -y
printEcho "Done"
echo
printEcho "removing conntrack"
sudo yum remove conntrack -y
printEcho "clean up is finished successfully"