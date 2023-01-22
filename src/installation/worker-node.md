# Setting up worker node

On the control plane node create a token to join the worker node to the cluster.

Run this command on the control plane node.

```bash
kubeadm token create --print-join-command
```

Copy the output of the command and run it on the worker node.

```bash
kubeadm join ...
```

## Check that worker node is up

To check that the worker node is up and running you can run the following command on the control plane node:

```bash
kubectl get nodes
```

You should see something like this:

```bash
NAME           STATUS   ROLES                  AGE   VERSION
controlplane   Ready    control-plane,master   10m   v1.25.0
workernode     Ready    <none>                 10m   v1.25.0
```

We can add a label to add the worker role to the node.

```bash
kubectl label node <node-name> node-role.kubernetes.io/worker=worker
```

## What about the CNI ?

For the installation of the control plane node we needed to install a CNI plugin for the node to be ready, but for the worker node we didn't. Can you explain why ?
