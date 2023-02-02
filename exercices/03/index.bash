#/usr/bin/env bash

# Break api server certificate

unset HISTFILE

# Remplace random data in the certificate by random data
dd if=/dev/urandom of=/etc/kubernetes/pki/apiserver.crt bs=1 count=1000 seek=1000 conv=notrunc

# Restart api server
kubectl delete pod -n kube-system -l component=kube-apiserver