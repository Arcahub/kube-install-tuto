#/usr/bin/env bash

# Scale CoreDNS to 0

unset HISTFILE

# Scale down to 0 core-dns pods
kubectl scale deployment -n kube-system coredns --replicas=0

# Create a namespace for the exercise
kubectl create namespace exercise-04

# Deploy an nginx pod
kubectl run -n exercise-04 nginx --image=nginx --restart=Never

# Create a service for the nginx pod
kubectl expose -n exercise-04 pod nginx --port=80 --target-port=80

# Deploy a pod with a busybox image with health check on the nginx service and restart policy set to Always
kubectl run -n exercise-04 busybox --image=busybox --restart=Always -- /bin/sh -c "while true; do wget -q -O- http://nginx; sleep 1; done"