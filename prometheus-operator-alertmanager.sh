#!/bin/bash
function printMsg() {
        MSG=$1
        echo "+++++++++++++++++++++++++++++++++++ ${MSG} +++++++++++++++++++++++++"
}
helm repo add coreos https://s3-eu-west-1.amazonaws.com/coreos-charts/stable/
printMsg cores repo is added successfully !
helm repo list 
kubectl create ns monitoring
printMsg created namespace 'monitoring' to install prometheus-operator and Alertmanager
helm install coreos/prometheus-operator --name prometheus-operator --namespace monitoring
printMsg installing Alertmanager
helm install coreos/alertmanager --name alertmanager --namespace monitoring
