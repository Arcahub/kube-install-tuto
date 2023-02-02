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

Now let's try to create a pod, we will first create the manifest to be able to modify it later:

```bash
kubectl run nginx --image=nginx --dry-run=client -o yaml > ~/nginx.yaml
```

And then create it:

```bash
kubectl apply -f ~/nginx.yaml
```

The pod is created but is stuck in `Pending` state:

```bash
kubectl get pods
```

We can see that the pod is waiting for a node to be assigned:

```bash
NAME    READY   STATUS    RESTARTS   AGE
nginx   0/1     Pending   0          42s
```

Now let's deploy a second pod, first edit the manifest file, change the name of the pod, add a `nodeName` field with the name of a worker node as value and finally apply it:

```bash
kubectl apply -f ~/nginx.yaml
```

The second pod will run without a problem while the other is still in pending state:

```bash
kubectl get pods
```

```bash
NAME     READY   STATUS    RESTARTS   AGE
nginx    0/1     Pending   0          14m
nginx2   1/1     Running   0          3m51s
```

Let's restore the scheduler:

```bash
sudo mv /tmp/kube-scheduler.yaml /etc/kubernetes/manifests
```

And now the first pod while be scheduled:

```bash
kubectl get pods
```

```bash
NAME     READY   STATUS    RESTARTS   AGE
nginx    1/1     Running   0          15m
nginx2   1/1     Running   0          4m52s
```

We just proved that scheduling a pod is not magic, it only mean to set the `nodeName` field in the pod spec to assign the pod to a node. Of course the scheduler does not randomly choose a node, it has a logic to choose the best node for the pod and that's why it's an important component of the cluster.

Cleanup:

```bash
kubectl delete pod nginx nginx2
```

## Node selector

Another way to schedule a pod on a specific node is to use a node selector. A node selector is a label that can be applied to a pod. If a node has a label that match the node selector, the scheduler will schedule the pod on that node.

Let's see how it works. First we will add a label to a node:

```bash
kubectl label node k8s-node-1 node-type=worker
```

Now let's create a pod with a node selector:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
  nodeSelector:
    node-type: worker
EOF
```

The pod is successfully created and running:

```bash
kubectl get pods -o wide
```

```bash
NAME      READY   STATUS    RESTARTS   AGE   IP           NODE
nginx     1/1     Running   0          2m    1.1.1.1      k8s-node-1
```

Cleanup:

```bash
kubectl delete pod nginx
```

## Affinity and anti-affinity

Affinity and anti-affinity is a more advanced way to schedule a pod on a specific node. It allows to specify more complex rules to match a node. You can also specify if a rule is required or preferred that means that if the rule is not matched, the pod can still be scheduled on a node that doesn't match the rule.

You can also constrain scheduling based on labels on other pods running on the node rather than on labels on the node itself. This is called inter-pod affinity and anti-affinity.

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
    nodeSelector:
      node-role.kubernetes.io/control-plane: ""
EOF
```

The pod is successfully created and running:

```bash
kubectl get pods
```

```bash
NAME      READY   STATUS    RESTARTS   AGE
nginx     1/1     Running   0          2m
```

Cleanup:

```bash
kubectl delete pod nginx
```

If we try to run the pod on the control plane node without the toleration, the pod will be stuck in `Pending` state:

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
    nodeSelector:
      node-role.kubernetes.io/control-plane: ""
EOF
```

```bash
kubectl get pods
```

```bash
NAME      READY   STATUS    RESTARTS   AGE
nginx     0/1     Pending   0          2m
```

Cleanup:

```bash
kubectl delete pod nginx
```

## Pod topology spread constraints

Pod topology spread constraints allow you to constrain the distribution of pods across your cluster among failure-domains such as regions, zones, nodes, and other user-defined topology domains. This can be used to achieve high availability as well as efficient resource utilization.

To test this feature, create a deployment with 4 replicas that will act the same way as a daemonset. That means that there will one pod per node and since we have only 3 nodes, the last pod will be in pending state.
