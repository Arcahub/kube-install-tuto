# Undertstanding what we have done

So far, we have installed a Kubernetes cluster. We have also installed some tools to manage our cluster. In this section, we will try to understand what we have done.

You should have a Kubernetes cluster with 3 nodes. One node is the control plane node and the other two are worker nodes.

By running `kubectl get nodes` you should see something like this:

```bash
NAME           STATUS   ROLES                  AGE   VERSION
controlplane   Ready    control-plane,master   10m   v1.25.0
workernode     Ready    worker                 10m   v1.25.0
workernode2    Ready    worker                 10m   v1.25.0
```

## What we have done

Let's review what we have done in the installation section.

### Packages

We installed a bunch of tools. We installed `kubeadm`, `kubectl` and `kubelet`. We also installed `containerd`.

You should already know `kubectl`, it is the command line tool to manage Kubernetes and `kubeadm` is a tool to manage a Kubernetes cluster.

Now let's talk about `kubelet` and `containerd`. We already mentioned `kubelet` in the previous section. It is a service that runs on each node of the cluster and is responsible for running containers. To run containers, it uses a container runtime. In our case, we use `containerd`.

We will explain more about `kubelet` and `containerd` in the [create a deployment](create-a-deployment.md) section.

### Kubeadm init

After installing all of the packages on the control plane node, we ran `kubeadm init` and we ended up with a Kubernetes cluster with only one node in not ready state. That was quite easy right?

Let's explain a bit what kubeadm init does:

- It create all needed certificates and keys that will be used to secure the cluster. (We will talk about that in the [certificates](understanding/certificates.md) section)
- It create all needed configuration files for the control plane components. Just like the configuration file `/etc/kubernetes/admin.conf` we used to connect to the cluster with `kubectl` all components need their own configuration file to interact with the cluster.
- It create a static pod manifest for the control plane components. We will talk about static pods in the [static pods](understanding/static-pods.md) section.

That's the principals steps of `kubeadm init`. If you want more details, you can check the [kubeadm init documentation](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/).

We already explained about the CNI plugin in the [installation](installation.md) section so we will not talk about it here. If you want more details, you can check the [CNI documentation](https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/).

### Kubeadm join

After running `kubeadm init` on the control plane node, we ended up with a Kubernetes cluster with only one node. We need to add the other two nodes to the cluster.

To make a node join the cluster, we need to run `kubeadm join` with a token. The token is a secret that is used to authenticate the node to the cluster. The token is created when we run `kubeadm init` on the control plane node but we can create tokens anytime we want like we did in the [installation](installation.md) section.

In difference to `kubeadm init`, `kubeadm join` does less work since the control plane is already up and running. It will only create a kubelet configuration file and start the kubelet service with a secure identity for the node.
