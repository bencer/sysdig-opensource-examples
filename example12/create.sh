#!/bin/sh

cat <<- 'EOF' > "flask-deployment.yaml"
kind: Deployment
apiVersion: extensions/v1beta1
metadata:
  name: flask
  labels:
    name: flask-deployment
    app: nginx-app
spec:
  replicas: 2
  selector:
    matchLabels:
     name: flask
     role: app
     app: nginx-app
  template:
    spec:
      containers:
        - name: flask
          image: mateobur/flask
    metadata:
      labels:
        name: flask
        role: app
        app: nginx-app
EOF

cat <<- 'EOF' > "nginx-deployment.yaml"
kind: Deployment
apiVersion: extensions/v1beta1
metadata:
  name: nginx
  labels:
    name: nginx-deployment
    app: nginx-app
spec:
  replicas: 0
  selector:
    matchLabels:
     name: nginx
     role: app
     app: nginx-app
  template:
    spec:
      containers:
        - name: nginx
          image: nginx
          volumeMounts:
          - name: "config"
            mountPath: "/etc/nginx/nginx.conf"
            subPath: "nginx.conf"
      volumes:
        - name: "config"
          configMap:
            name: "nginxconfig"
    metadata:
      labels:
        name: nginx
        role: app
        app: nginx-app
EOF

kubectl create namespace nginx-app
kubectl create --namespace=nginx-app configmap nginxconfig --from-file nginx.conf
kubectl create --namespace=nginx-app -f flask-deployment.yaml
kubectl create --namespace=nginx-app -f nginx-deployment.yaml
rm flask-deployment.yaml nginx-deployment.yaml
