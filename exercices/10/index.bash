#/usr/bin/env bash

# Must be run on master node

# Taint all worker nodes

unset HISTFILE

# Taint all worker nodes
kubectl taint nodes --all node-role.kubernetes.io/master='':NoSchedule

# Run pod
kubectl create deployment nginx-exercise-10 --image=nginx --replicas=3