#-----get the executable from helm and create a script file to install helm
sudo curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
sudo chmod 700 get_helm.sh
sudo ./get_helm.sh
#----- Helm needs tiller as backend component and tiller needs some specific access so create cluster-admin role.
kubectl create clusterrolebinding add-on-cluster-admin \
  --clusterrole=cluster-admin \
  --serviceaccount=kube-system:default
#--- initialise the helm
sudo helm init
