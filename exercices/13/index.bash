#/usr/bin/env bash

# Must be run on master node

# Disable deployment controller

unset HISTFILE

# Disable deployment controller from kube-controller-manager
sudo sed -i 's#--controllers=\*,bootstrapsigner,tokencleaner#--controllers=*,bootstrapsigner,-deployment,tokencleaner#' /etc/kubernetes/manifests/kube-controller-manager.yaml

# Delete kube-controller-manager pod
kubectl delete pod -n kube-system -l component=kube-controller-manager

# Create a deployment
kubectl create deployment exercise-13 --image=nginx