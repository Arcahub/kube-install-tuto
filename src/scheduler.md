# Playing with the scheduler

In the last section we quickly saw that the scheduler assign the field `nodeName` in pod spec to make the pod run by `kubelet`. In this section we will play with the scheduler to see how it works.

## Manual scheduling

We can manually schedule a pod by setting the `nodeName` field in the pod spec. But first to be sure that the `scheduler` won't do anythinh for us, we will remove the `scheduler` from the cluster:

```bash
sudo mv /etc/kubernetes/manifests/kube-scheduler.yaml /tmp
```

You can check that the scheduler is not running anymore:

```bash
kubectl get pods -n kube-system
```

Now let's try to create a pod like we would normally do:

```bash
kubectl run nginx --image=nginx
```

The pod is created but is stuck in `Pending` state:

```bash
kubectl get pods
```

Let's check the pod description:

```bash
kubectl describe pod nginx
```

We can see that the pod is waiting for a node to be assigned:

```bash
// TODO
```

Now let's try to schedule the pod manually by updating the pod spec:

```bash
kubectl patch pod nginx -p '{"spec":{"nodeName":"<worker-node-name>"}}'
```

The pod should be running now:

```bash
kubectl get pods
```

Let's restore the scheduler:

```bash
sudo mv /tmp/kube-scheduler.yaml /etc/kubernetes/manifests
```

We just proved that scheduling a pod is not magic, it only mean to set the `nodeName` field in the pod spec to assign the pod to a node. Of course the scheduler does not randomly choose a node, it has a logic to choose the best node for the pod and that's why it's an important component of the cluster.

## Node affinity

Another way to schedule a pod on a specific node is to use node affinity. A node affinity is a rule that can be applied to a pod. If a node match the rule, the scheduler will schedule the pod on that node unless the pod has a node affinity that does not match that rule.

## Taints and tolerations

One of the most important feature of the scheduler is the ability to schedule pods on specific nodes. This is done by using taints and tolerations. A taint is a label that can be applied to a node. A toleration is a label that can be applied to a pod. If a node has a taint, the scheduler will not schedule any pod on it unless the pod has a toleration for that taint.

Let's see how it works. By default we can't schedule a pod on the control plane node, that's because the control plane node has a taint:

```bash
kubectl describe node <control-plane-node-name> | grep Taints
```

Let's try to create a pod that won't run on worker nodes but only on the control plane node:

```bash
cat<<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
    containers:
    - name: nginx
      image: nginx
    tolerations:
    - key: node-role.kubernetes.io/master
      operator: Equal
      value: ""
    - key: node-role.kubernetes.io/control-plane
      operator: Equal
      value: ""
EOF
```
