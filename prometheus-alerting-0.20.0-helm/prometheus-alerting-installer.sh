#Adding the coreos repo for helm
helm repo add coreos https://s3-eu-west-1.amazonaws.com/coreos-charts/stable/
#Create a k8s namespaces
kubectl create ns alerting
#install prometheus operator
helm install --name helm coreos/prometheus-operator --namespace alerting
kubectl create -f prometheus-alerting-0.20.0-helm/promethues-instance-rbac.yaml
kubectl create secret generic alertmanager-alertmanager --from-file=prometheus-alerting-0.20.0-helm/alertmanager.yaml -n alerting
kubectl create -f prometheus-alerting-0.20.0-helm/alertmanager-setup.yaml
kubectl create -f prometheus-alerting-0.20.0-helm/prometheus-server.yaml
kubectl create -f prometheus-alerting-0.20.0-helm/prometheus-rules.yaml
