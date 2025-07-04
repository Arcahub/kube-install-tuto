# Upgrading cluster version

I voluntarily made you install Kubernetes 1.32.0. This is because I wanted to show you how to upgrade a cluster. In this section, we will upgrade our cluster to Kubernetes 1.33.0.

## Upgrade control plane

To upgrade the control plane, we will use the `kubeadm upgrade` command. This command will upgrade the control plane components and the kubelet.

We will first upgrade `kubeadm` itself.

We need to switch the Kubernetes package repository to the next minor version. To do this, we will edit the Kubernetes APT repository file.

```bash
sudo nano /etc/apt/sources.list.d/kubernetes.list
```

You should see a single line with the URL that contains your current Kubernetes minor version. For example, if you're using v1.32, you should see this:

```bash
deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /
```

Change the version in the URL to the next available minor release, for example:

```bash
deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /
```

Save the file and exit your text editor.

```bash
sudo apt-mark unhold kubeadm && \
sudo apt update && sudo apt remove -y kubeadm && sudo apt install -y kubeadm=1.33.2-1.1 && \
sudo apt-mark hold kubeadm
```

Now we can check if the upgrade is available.

```bash
sudo kubeadm upgrade plan
```

If you see the following output then you can upgrade your cluster.

```bash
[upgrade/config] Making sure the configuration is correct:
[upgrade/config] Reading configuration from the cluster...
[upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
[preflight] Running pre-flight checks.
[upgrade] Making sure the cluster is healthy:
[upgrade/health] Checking API Server health: Healthy
[upgrade/health] Checking Node health: All Nodes are healthy
[upgrade/health] Checking Static Pod manifests exists on disk: All manifests exist on disk
[upgrade/health] Checking if control plane is Static Pod-hosted or Self-Hosted: Static Pod-hosted
[upgrade/health] Checking Static Pod manifests directory is empty: The directory is not empty
[upgrade/config] The configuration was checked to be correct:
[upgrade/config]      COMPONENT                 CURRENT        AVAILABLE
[upgrade/config]      API Server                v1.32.6        v1.33.2
[upgrade/config]      Controller Manager        v1.32.6        v1.33.2
[upgrade/config]      Scheduler                 v1.32.6        v1.33.2
[upgrade/config]      Kube Proxy                v1.32.6        v1.33.2
[upgrade/config]      CoreDNS                   1.8.0          1.8.0
[upgrade/config]      Etcd                      3.4.13-0       3.4.13-0
[upgrade/versions] Cluster version: v1.32.6
[upgrade/versions] kubeadm version: v1.33.2
[upgrade/versions] Latest stable version: v1.33.2
[upgrade/versions] Latest version in the v1.32 series: v1.32.6
[upgrade/versions] Latest experimental version: v1.34.0-alpha.0

Components that must be upgraded manually after you have upgraded the control plane with 'kubeadm upgrade apply':
COMPONENT   CURRENT       AVAILABLE
Kubelet     1 x v1.32.6   v1.33.2
```

Now we can upgrade the cluster.

```bash
kubeadm upgrade apply v1.33.2
```

If the upgrade is successful, you should see the following output.

```bash
[upgrade/successful] SUCCESS! Your cluster was upgraded to "v1.33.x". Enjoy!

[upgrade/kubelet] Now that your control plane is upgraded, please proceed with upgrading your kubelets if you haven't already done so.
```

Before upgrading `kubelet`, we need to drain the control plane node.

```bash
kubectl drain <controlplane-node-name> --ignore-daemonsets
```

You can now upgrade `kubelet`

```bash
sudo apt-mark unhold kubelet && \
sudo apt update && sudo apt remove -y kubelet && sudo apt install -y kubelet=1.33.2-1.1 && \
sudo apt-mark hold kubelet
```

Restart `kubelet`

```bash
sudo systemctl daemon-reload
sudo systemctl restart kubelet
```

Uncordon the control plane node

```bash
kubectl uncordon controlplane
```

## Upgrade worker nodes

To upgrade the worker nodes the steps are similar to the control plane.

First upgrade `kubeadm`

Again first, we need to switch the Kubernetes package repository to the next minor version. To do this, we will edit the Kubernetes APT repository file.

```bash
sudo nano /etc/apt/sources.list.d/kubernetes.list
```

You should see a single line with the URL that contains your current Kubernetes minor version. For example, if you're using v1.32, you should see this:

```bash
deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /
```

Change the version in the URL to the next available minor release, for example:

```bash
deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /
```

Save the file and exit your text editor.

```bash
sudo apt-mark unhold kubeadm && \
sudo apt update && sudo apt remove -y kubeadm && sudo apt install -y kubeadm=1.33.2-1.1 && \
sudo apt-mark hold kubeadm
```

Then upgrade the node

```bash
sudo kubeadm upgrade node
```

If the upgrade is successful, you should see the following output.

```bash
[upgrade/successful] SUCCESS! Your node was upgraded to "v1.33.x". Enjoy!
```

Before upgrading `kubelet`, we need to drain the worker node, so go on the controlplane and run:

```bash
kubectl drain <worker-node-name> --ignore-daemonsets
```

You can now upgrade `kubelet`

```bash
sudo apt-mark unhold kubelet && \
sudo apt update && sudo apt remove -y kubelet && sudo apt install -y kubelet=1.33.2-1.1 && \
sudo apt-mark hold kubelet
```

Restart `kubelet`

```bash
sudo systemctl daemon-reload
sudo systemctl restart kubelet
```

Uncordon the worker node

```bash
kubectl uncordon <worker-node-name>
```

## Check that cluster is up

To check that the cluster is up and running you can run the following command on the control plane node:

```bash
kubectl get nodes
```

You should see something like this:

```bash
NAME            STATUS   ROLES                  AGE   VERSION
controlplane    Ready    control-plane,master   10m   v1.33.2
workernode      Ready    worker                 10m   v1.33.2
workernode2     Ready    worker                 10m   v1.33.2
```
