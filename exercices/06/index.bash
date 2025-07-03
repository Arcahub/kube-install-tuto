#/usr/bin/env bash

# Add maxPods to the kubelet configuration

unset HISTFILE

# Add maxPods to the kubelet configuration
echo "maxPods: 10" >> /var/lib/kubelet/config.yaml

# Restart the kubelet
sudo systemctl daemon-reload
sudo systemctl restart kubelet

# Create namespace for the exercise
kubectl create namespace exercise-06

# Create a deployment with current hostname as nodeName
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  namespace: exercise-06
spec:
    replicas: 15
    selector:
        matchLabels:
        app: nginx
    template:
        metadata:
        labels:
            app: nginx
        spec:
        nodeName: $(hostname)
        containers:
        - name: nginx
            image: nginx
            ports:
            - containerPort: 80
EOF