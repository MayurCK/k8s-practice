echo "Installing apache server for ingress entry point."
sudo yum install httpd -y
echo "done successfully."
kubectl create -f ingress-setup/haproxy-ingress.yaml
echo "created haproxy succesfully."
sudo ./helm/helm-installer.sh
echo "successfully installed helm."
./prometheus-alerting-0.20.0-helm/prometheus-alerting-installer.sh

