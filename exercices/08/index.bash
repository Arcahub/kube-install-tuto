#/usr/bin/env bash

# Must be run on master node

# Copy all the static manifest except the kube-scheduler to a new directory, then update the kubelet config to poin to the new location.

unset HISTFILE

mkdir -p /etc/cubernetes/manifests
cp /etc/kubernetes/manifests/* /etc/cubernetes/manifests/
rm /etc/cubernetes/manifests/kube-scheduler.yaml
sed -i 's#staticPodPath: /etc/kubernetes/manifests#staticPodPath: /etc/cubernetes/manifests#' /var/lib/kubelet/config.yaml
systemctl restart kubelet