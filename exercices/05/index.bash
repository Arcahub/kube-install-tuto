#/usr/bin/env bash

# Break CoreDNS configuration

unset HISTFILE

# Remplace cluster.local by invalid-domain.local in the CoreDNS configmap
kubectl -n kube-system get configmap coredns -o yaml | sed 's/cluster.local/invalid-domain/g' | kubectl apply -f -

# Restart CoreDNS
kubectl delete pod -n kube-system -l k8s-app=kube-dns

# Fix CoreDNS configuration
# kubectl -n kube-system get configmap coredns -o yaml | sed 's/invalid-domain/cluster.local/g' | kubectl apply -f -

# Create a namespace for the exercise
kubectl create namespace exercise-05

# Deploy an nginx pod
kubectl run -n exercise-05 nginx --image=nginx --restart=Never

# Create a service for the nginx pod
kubectl expose -n exercise-05 pod nginx --port=80 --target-port=80

# Deploy a pod with a busybox image with health check on the nginx service and restart policy set to Always
kubectl run -n exercise-05 busybox --image=busybox --restart=Always -- /bin/sh -c "while true; do wget -q -O- http://nginx; sleep 1; done"