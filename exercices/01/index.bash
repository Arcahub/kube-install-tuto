#/usr/bin/env bash

# Run on any node, break kubelet by changing the path to kubelet binary, make the node appear as NotReady and can't be scheduled on

unset HISTFILE

sed -i 's$/usr/bin/kubelet$/usr/bin/local/kubelet$' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

systemctl daemon-reload
systemctl restart kubelet