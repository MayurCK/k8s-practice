#Adding the coreos repo for helm
helm repo add coreos https://s3-eu-west-1.amazonaws.com/coreos-charts/stable/
#Create a k8s namespaces
kubectl create ns monitoring 
#install prometheus operator
helm install --name prometheus-operator  coreos/prometheus-operator --namespace monitoring
kubectl create -f /home/hingnekar_mayur/k8s-practice/prometheus-alerting-0.20.0-helm/prometheus-instance-rbac.yaml
kubectl create secret generic alertmanager-alertmanager --from-file=/home/hingnekar_mayur/k8s-practice/prometheus-alerting-0.20.0-helm/alertmanager.yaml -n monitoring
kubectl create -f /home/hingnekar_mayur/k8s-practice/prometheus-alerting-0.20.0-helm/alertmanager-setup.yaml
kubectl create -f /home/hingnekar_mayur/k8s-practice/prometheus-alerting-0.20.0-helm/prometheus-server.yaml
kubectl create -f /home/hingnekar_mayur/k8s-practice/prometheus-alerting-0.20.0-helm/prometheus-rules.yaml
