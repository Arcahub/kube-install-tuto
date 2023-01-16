# Static pods

We just installed our Kubernetes cluster, and we can already see some pods running in the `kube-system` namespace. But where did these pods come from ? How did they get created ? How did they get scheduled on the nodes ?

These pods are called static pods. Static pods are pods that are managed directly by the kubelet daemon.

## What are static pods ?

As we said earlier, static pods are pods that are managed directly by the `kubelet` daemon. `kubelet` will watch a specific directory on the host file system. If a file is created in this directory, `kubelet` will try to create a pod based on the file. If the file is deleted, `kubelet` will delete the pod.

The directory that `kubelet` is watching is called the **static pod directory**. The default static pod directory is `/etc/kubernetes/manifests`.

Run the following command to see the content of the static pod directory :

```bash
sudo ls /etc/kubernetes/manifests
```

This command should return the following output :

```bash
etcd.yaml
kube-apiserver.yaml
kube-controller-manager.yaml
kube-scheduler.yaml
```

You can check that these files match the pods that are running in the `kube-system` namespace :

```bash
kubectl get pods --namespace=kube-system
```

You can also have a look at one of these files :

```bash
sudo cat /etc/kubernetes/manifests/kube-apiserver.yaml
```

## Playing with static pods

Let's play a bit with static pods to understand how they work.

Let's try to destroy the `kube-apiserver` pod only with `kubectl` :

```bash
kubectl delete pod kube-apiserver --namespace=kube-system
```

But if you check the pods again, you will see that the `kube-apiserver` pod is still running :

```bash
kubectl get pods --namespace=kube-system
```

Why ? Because `kubelet` is still watching the static pod directory and will recreate the pod if it is deleted.

Let's try to delete the `kube-apiserver` pod file :

```bash
# We only move the file to another location to be able to restore it later, what's important is that the file is deleted from the static pod directory
sudo mv /etc/kubernetes/manifests/kube-apiserver.yaml ~/kube-apiserver.yaml
```

And now, the `kube-apiserver` pod is gone :

```bash
kubectl get pods --namespace=kube-system
```

Let's restore the file :

```bash
sudo mv ~/kube-apiserver.yaml /etc/kubernetes/manifests/kube-apiserver.yaml
```

And now, the `kube-apiserver` pod is back :

```bash
kubectl get pods --namespace=kube-system
```

We can also create a new pod file in the static pod directory :

```bash
sudo tee /etc/kubernetes/manifests/nginx.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  namespace: kube-system
spec:
    containers:
    - name: nginx
        image: nginx
        ports:
        - containerPort: 80
EOF
```

And now, the `nginx` pod is running :

```bash
kubectl get pods --namespace=kube-system
```

Let's clean up :

```bash
sudo rm /etc/kubernetes/manifests/nginx.yaml
```

## Conclusion

In this article, we saw how static pods work and where are located Kubernetes components manifests. Static pod are never used for anything else than managing these components, but you may have to modify their manifest.
