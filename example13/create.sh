#!/bin/bash

cat <<- 'EOF' > "mysql-deployment.yaml"
kind: Deployment
apiVersion: extensions/v1beta1
metadata:
  name: mysql
  labels:
    name: mysql-deployment
    app: demo
spec:
  replicas: 1
  # selector identifies the set of Pods that this
  # replication controller is responsible for managing
  selector:
    matchLabels:
     name: mysql
     role: mysqldb
     app: demo
  template:
    spec:
      containers:
        - name: mysql
          image: mysql
          ports:
            - containerPort: 3306
              name: mysql
          env:
          - name: MYSQL_ROOT_PASSWORD
            value: password
          - name: MYSQL_USER
            value: admin
          - name: MYSQL_PASSWORD
            value: password
          - name: MYSQL_DATABASE
            value: wordpress
    metadata:
      labels:
        # Important: these labels need to match the selector above
        # The api server enforces this constraint.
        name: mysql
        role: mysqldb
        app: demo
EOF

cat <<- 'EOF' > "mysql-service.yaml"
apiVersion: v1
kind: Service
metadata: 
  labels: 
    name: mysql
  name: mysql
spec:
  clusterIP: "None"
  ports:
    - port: 3306
      targetPort: 3306
  selector:
    name: mysql 
    app: demo
    role: mysqldb
EOF


cat <<- EOF > "wordpress-deployment.yaml"
kind: Deployment
apiVersion: extensions/v1beta1
metadata:
  name: wordpress
  labels:
    name: wordpress-deployment
    app: demo
spec:
  replicas: 2
  # selector identifies the set of Pods that this
  # replication controller is responsible for managing
  selector:
    matchLabels:
     name: wordpress
     role: frontend
     app: demo
  template:
    spec:
      containers:
        - name: wordpress
          image: wordpress
          env:
          - name: WORDPRESS_DB_PASSWORD
            value: password
          - name: WORDPRESS_DB_USER
            value: admin
          - name: WORDPRESS_DB_HOST
            value: mysql.wp-demo.svc.cluster.local:3306
          ports:
          - containerPort: 80
            name: wordpress
    metadata:
      labels:
        # Important: these labels need to match the selector above
        # The api server enforces this constraint.
        name: wordpress
        role: frontend
        app: demo
EOF

cat <<- EOF > "wordpress-service.yaml"
apiVersion: v1
kind: Service
metadata: 
  labels: 
    name: wordpress
  name: wordpress
spec: 
  ports:
    - port: 80
      targetPort: 80
  selector:
    name: wordpress 
    app: demo
    role: frontend
EOF

cat <<- EOF > "wp-client-deployment.yaml"
kind: Deployment
apiVersion: extensions/v1beta1
metadata:
  name: client
  labels:
    name: client-deployment
    app: demo
spec:
  replicas: 1
  # selector identifies the set of Pods that this
  # replication controller is responsible for managing
  selector:
    matchLabels:
     name: client
     role: clients
     app: demo
  template:
    spec:
      containers:
        - name: client
          image: ltagliamonte/recurling
          env:
          - name: URL
            value: http://wordpress.wp-demo.svc.cluster.local{/,/readme.html,/wp-login.php,/error1,/error2,/wp-includes/js/utils.js,/wp-content/themes/twentyfifteen/screenshot.png,/wp-content/themes/twentyfifteen/style.css,/wp-content/themes/twentysixteen/js/functions.js,/wp-includes/images/down_arrow.gif,/wp-includes/js/jcrop/Jcrop.gif}
    metadata:
      labels:
        # Important: these labels need to match the selector above
        # The api server enforces this constraint.
        name: client
        role: clients
        app: demo
EOF

kubectl create namespace wp-demo
kubectl create -f mysql-deployment.yaml --namespace=wp-demo
kubectl create -f mysql-service.yaml --namespace=wp-demo
kubectl create -f wordpress-deployment.yaml --namespace=wp-demo
kubectl create -f wordpress-service.yaml --namespace=wp-demo
kubectl create -f wp-client-deployment.yaml --namespace=wp-demo
rm mysql-deployment.yaml mysql-service.yaml wordpress-deployment.yaml wordpress-service.yaml wp-client-deployment.yaml

# Sysdig Monitor agent, remove this if not needed!
CLUSTER=`hostname --fqdn`
cat <<- EOF > "sysdig.yaml"
apiVersion: extensions/v1beta1
kind: DaemonSet                     
metadata:
  name: sysdig-agent
  labels:
    app: sysdig-agent
spec:
  template:
    metadata:
      labels:
        name: sysdig-agent
    spec:
      volumes:
      - name: dshm
        emptyDir:
          medium: Memory
      - name: docker-sock
        hostPath:
         path: /var/run/docker.sock
      - name: dev-vol
        hostPath:
         path: /dev
      - name: proc-vol
        hostPath:
         path: /proc
      - name: boot-vol
        hostPath:
         path: /boot
      - name: modules-vol
        hostPath:
         path: /lib/modules
      - name: usr-vol
        hostPath:
          path: /usr
      hostNetwork: true
      hostPID: true
 #    serviceAccount: sysdigcloud                           #OPTIONAL - OpenShift service account for OpenShift
      containers:
      - name: sysdig-agent
        image: sysdig/agent
#        imagePullPolicy: Always                            #OPTIONAL - Always pull the latest container image tag 
        securityContext:
         privileged: true
        env:
        - name: ACCESS_KEY                                  #REQUIRED - replace with your Sysdig Cloud access key
          value: b1ab26a4-ef1a-4e23-b063-1295e17b2f18
        - name: TAGS                                       #OPTIONAL
          value: cluster:${CLUSTER}
        - name: ADDITIONAL_CONF                            #OPTIONAL pass additional parameters to the agent such as authentication example provided here
          value: "k8s_uri: http://localhost:8080\nk8s_autodetect: false"
        volumeMounts:
        - mountPath: /host/var/run/docker.sock
          name: docker-sock
          readOnly: false
        - mountPath: /host/dev
          name: dev-vol
          readOnly: false
        - mountPath: /host/proc
          name: proc-vol
          readOnly: true
        - mountPath: /host/boot
          name: boot-vol
          readOnly: true
        - mountPath: /host/lib/modules
          name: modules-vol
          readOnly: true
        - mountPath: /host/usr
          name: usr-vol
          readOnly: true
        - mountPath: /dev/shm
          name: dshm
EOF
kubectl create -f sysdig.yaml
rm sysdig.yaml
