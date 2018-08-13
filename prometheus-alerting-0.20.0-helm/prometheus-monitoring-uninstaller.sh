helm del --purge helm
kubectl delete -f /home/hingnekar_mayur/k8s-practice/prometheus-alerting-0.20.0-helm/prometheus-instance-rbac.yaml
kubectl delete secret alertmanager-alertmanager -n monitoring
kubectl delete -f /home/hingnekar_mayur/k8s-practice/prometheus-alerting-0.20.0-helm/alertmanager-setup.yaml
kubectl delete -f /home/hingnekar_mayur/k8s-practice/prometheus-alerting-0.20.0-helm/prometheus-server.yaml
kubectl delete -f /home/hingnekar_mayur/k8s-practice/prometheus-alerting-0.20.0-helm/prometheus-rules.yaml
