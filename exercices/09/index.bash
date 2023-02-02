#/usr/bin/env bash

# Must be run on master node

# Network policy to deny all traffic in the namespace

unset HISTFILE

# Create a namespace for the exercise
kubectl create ns exercise-09

# Create a network policy to deny all traffic in the namespace
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
  namespace: exercise-09
spec:
    podSelector: {}
    policyTypes:
    - Ingress
    - Egress
EOF

# Create a pod with a nginx image
kubectl run -n exercise-09 nginx --image=nginx --restart=Never

# Create a service for the nginx pod
kubectl expose -n exercise-09 pod nginx --port=80 --target-port=80

# Deploy a pod with a busybox image with health check on the nginx service and restart policy set to Always
kubectl run -n exercise-09 busybox --image=busybox --restart=Always -- /bin/sh -c "while true; do wget -q -O- http://nginx; sleep 1; done"
