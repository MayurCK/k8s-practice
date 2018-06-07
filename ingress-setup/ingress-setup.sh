#!/bin/bash
function printMsg() {
        MSG=$1
        echo "+++++++++++++++++++++++++++++++++++ ${MSG} +++++++++++++++++++++++++"
}
printMsg "Setting up the Ingress"
cat <<EOF | kubectl create -f -
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: traefik-ingress-controller
rules:
- apiGroups:
  - ""
  resources:
  - services
  - endpoints
  - secrets
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - extensions
  resources:
  - ingresses
  verbs:
  - get
  - list
  - watch
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: traefik-ingress-controller
  namespace: kube-system
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: traefik-ingress-controller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: traefik-ingress-controller
subjects:
- kind: ServiceAccount
  name: traefik-ingress-controller
  namespace: kube-system
---
apiVersion: v1
data:
  auth: a3ViZXJuZXRlczokYXByMSRVNDlTVllISiQzNnZVelFhQktTNzRtY3lpT0V6MUkuCg==
kind: Secret
metadata:
  name: traefik-basic-auth
  namespace: kube-system
type: Opaque
---
kind: ConfigMap
apiVersion: v1
metadata:
  name: traefik-cfg
  namespace: kube-system
  labels:
    app: traefik
data:
  traefik.toml: |
    defaultEntryPoints = ["http","ws"]
    InsecureSkipVerify = true
    [entryPoints]
      [entryPoints.http]
      address = ":80"
    # Enable the kubernetes integration
    [kubernetes]
    [web]
    address = ":8080"
    [web.statistics]
    [web.metrics.prometheus]
      buckets=[0.1,0.3,1.2,5.0]
  traefik-acme.toml: |
    defaultEntryPoints = ["http", "https"]
    InsecureSkipVerify = true
    [entryPoints]
      [entryPoints.http]
      address = ":80"
        [entryPoints.http.redirect]
        entryPoint = "https"
      [entryPoints.https]
      address = ":443"
      [entryPoints.https.tls]
    [acme]
    email = "example@example.com"
    storageFile = "acme.json"
    onDemand = true
    onHostRule = true
    caServer = "https://acme-v01.api.letsencrypt.org/directory"
    entryPoint = "https"
    # Enable the kubernetes integration
    [kubernetes]
    [web]
    address = ":8080"
    [web.statistics]
    [web.metrics.prometheus]
    buckets=[0.1,0.3,1.2,5.0]
---
kind: Deployment
apiVersion: apps/v1beta2
metadata:
  name: traefik-ingress-controller
  namespace: kube-system
  labels:
    app: traefik-ingress-controller
spec:
  replicas: 1
  selector:
    matchLabels:
      app: traefik-ingress-controller
  template:
    metadata:
      labels:
        app: traefik-ingress-controller
    spec:
      tolerations:
      - key: beta.kubernetes.io/arch
        value: arm
        effect: NoSchedule
      - key: beta.kubernetes.io/arch
        value: arm64
        effect: NoSchedule
      serviceAccountName: traefik-ingress-controller
      containers:
      - image: luxas/traefik:v1.3.8
        name: traefik-ingress-controller
        resources:
          limits:
            cpu: 800m
            memory: 3000Mi
          requests:
            cpu: 800m
            memory: 3000Mi
        ports:
        - name: http
          containerPort: 80
        - name: web
          containerPort: 8080
        args:
        - --configfile=/etc/traefik/traefik.toml
        volumeMounts:
        - name: traefik-cfg
          mountPath: /etc/traefik/traefik.toml
      volumes:
      - name: traefik-cfg
        configMap:
          name: traefik-cfg
---
apiVersion: v1
kind: Service
metadata:
  name: traefik-ingress-controller
  labels:
    app: traefik-ingress-controller
  namespace: kube-system
spec:
  ports:
  - port: 80
    targetPort: 80
  selector:
    app: traefik-ingress-controller
EOF
echo "Now RUN-- kubectl get svc traefik-ingress-controller -n kube-system and copy clusterIP of service."