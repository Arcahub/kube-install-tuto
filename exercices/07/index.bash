#/usr/bin/env bash

# Must be run on master node

# Break etcd pod health check

unset HISTFILE

# Update etcd static pod manifest to change liveneess probe to an invalid command
sed -i 's$path: /health$path: /not-healthy$g' /etc/kubernetes/manifests/etcd.yaml

# Every 8 times the liveneess probe will fail, the etcd pod will be restarted and so interacttion with the etcd cluster will be broken.
# For example, the kubectl command will fail.