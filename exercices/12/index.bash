#/usr/bin/env bash

# Must be run on master node

# Remove kube admin

unset HISTFILE

cat <<EOF | kubectl apply --kubeconfig=/etc/kubernetes/admin.conf -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: imposter
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: imposter
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: User
  name: kubernetes-admins
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: imposter
rules:
- apiGroups: [""]
  resources: ["groups"]
  verbs: ["impersonate"]
  resourceNames: ["system:masters"]
- apiGroups: [""]
  resources: ["users"]
  verbs: ["impersonate"]
  resourceNames: ["kubernetes-admins"]
EOF

mkdir -p ~/.kube/

# Setup Client Config
kubeadm kubeconfig user --client-name kubernetes-admins --config=<(kubectl --kubeconfig=/etc/kubernetes/admin.conf -n kube-system get cm kubeadm-config -o go-template='{{ .data.ClusterConfiguration }}') > ~/.kube/config

# Copy modified client config
cp ~/.kube/config /etc/kubernetes/admin.conf