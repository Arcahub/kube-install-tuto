# Setting up control plane node

To init the control plane node with kubeadm simply ssh on the node and run the following command:

```bash
sudo kubeadm init
```

Wait for it to finish.

## What does kubeadm init do?

The `kubeadm init` command does a lot of things:

- Install the necessary packages on the system
- Create a Kubernetes configuration file
- Create static pods for the control plane components
- Generate certificates and keys for the cluster
- Generate a kubeconfig for the control plane components
- Generate a token to be used by the worker nodes to join the cluster
- Generate a kubeconfig for the admin user

## Setup kubeconfig

To be able to use kubectl we need to setup the kubeconfig file.
This configuration file is created by kubeadm and is located at `/etc/kubernetes/admin.conf`.
This enables us to interact with our Kubernetes cluster, currently with only one node as the admin user.

Run the following commands to copy the configuration file to the default location and change the ownership of the file to the current user:

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

## Check that control plane is up

We now have a control plane node up and running. To check that everything is working, you can run the following command:

```bash
kubectl get nodes
```

You should see something like this:

```bash
NAME           STATUS      ROLES           AGE   VERSION
controlplane   NotReady    control-plane   10m   v1.25.0
```

The control plane node should be in the `NotReady` state yet. This is normal, we will fix this in the next section.

## Install CNI plugin

The control plane node is not ready because the pods are not able to communicate with each other.

If you run the following command:

```bash
kubectl get pods --all-namespaces
```

You will see something like this:

```bash
NAMESPACE     NAME                                       READY   STATUS    RESTARTS   AGE
kube-system   coredns-74ff55c5b-2q2q2                    0/1     Pending   0          10m
kube-system   coredns-74ff55c5b-4q4q4                    0/1     Pending   0          10m
kube-system   etcd-controlplane                          1/1     Running   0          10m
kube-system   kube-apiserver-controlplane                1/1     Running   0          10m
kube-system   kube-controller-manager-controlplane       1/1     Running   0          10m
kube-system   kube-proxy-2q2q2                           1/1     Running   0          10m
kube-system   kube-scheduler-controlplane                1/1     Running   0          10m
```

You can see that the `coredns` pods are not ready and are in the `Pending` state. This is because the pods are waiting for a network to be available.

To fix this, we need to install a [Container Network Interface (CNI) plugin](https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/). A CNI plugin is a network plugin that will allow pods to communicate with each other.

We will use [Weave Net](https://www.weave.works/oss/net/) in this course.

```bash
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
```

Wait for the weave-net pods to be ready:

```bash
kubectl -n kube-system wait pod -l name=weave-net --for=condition=Ready --timeout=-1s
kubectl get pods -l name=weave-net -n kube-system
```

## Check that control plane node is ready

To check that everything is working you can run the following command:

```bash
kubectl get nodes
```

You should see something like this:

```bash
NAME           STATUS   ROLES    AGE   VERSION
controlplane   Ready    master   10m   v1.25.0
```

The control plane node should be in the `Ready` state now.

We can also check that the `coredns` pod is now running:

```bash
kubectl get pods --all-namespaces
```

You should see something like this:

```bash
NAMESPACE     NAME                                       READY   STATUS    RESTARTS   AGE
kube-system   coredns-74ff55c5b-2q2q2                    1/1     Running   0          10m
kube-system   etcd-controlplane                          1/1     Running   0          10m
kube-system   kube-apiserver-controlplane                1/1     Running   0          10m
kube-system   kube-controller-manager-controlplane       1/1     Running   0          10m
kube-system   kube-proxy-2q2q2                           1/1     Running   0          10m
kube-system   kube-scheduler-controlplane                1/1     Running   0          10m
```

## Join worker nodes

In the next section, we will make our worker nodes join the cluster.
