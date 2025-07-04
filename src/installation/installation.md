# Kubernetes installation with kubeadm

In this section, we will install a Kubernetes cluster using [kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm/).

The following steps are expected to be run on all nodes in the cluster. So first follow ***all*** the steps on the control plane node and then repeat the steps on all worker nodes.

So first ssh on the control plane node and then follow the steps.

## Prepare the node

Before installing Kubernetes components, we need to prepare the node by enabling the required kernel network modules.

```bash
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system
```

[source](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#install-and-configure-prerequisites)

## CRI (Container Runtime Interface)

Kubernetes need a container runtime to run containers. Kubernetes defines an interface called the Container Runtime Interface (CRI). The CRI is an interface which allows Kubernetes to use a wide variety of container runtimes, without the need to recompile Kubernetes.

Kubernetes support multiple CRI implementations, in this course we will use [containerd](https://containerd.io/) that is the default CRI for Kubernetes.

### Installing containerd

To install containerd we will need to add the docker repository to the package manager.

```bash
# Install required packages for https repository
sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl
# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# Add Docker repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# Update package manager index
sudo apt-get update
```

Now we can install containerd.

```bash
sudo apt-get install -y containerd.io
```

Now we need to configure containerd to use the systemd cgroup driver.

```bash
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
```

Find the section `[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]` in the `/etc/containerd/config.toml` file and change the `SystemdCgroup` value to `true`.

Finally, you can restart the containerd service.

```bash
sudo systemctl restart containerd
```

[source](https://docs.docker.com/engine/install/ubuntu/)

### Test containerd installation

To test the installation of containerd we can run the following command.

```bash
sudo ctr images pull docker.io/library/hello-world:latest
sudo ctr run --rm docker.io/library/hello-world:latest hello-world
sudo ctr images rm docker.io/library/hello-world:latest
```

If you see the following output, then the installation is successful.

```bash
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

### Installing kubeadm, kubelet and kubectl

To install kubeadm, kubelet and kubectl we will use ubuntu package manager (apt).

```bash
# Install required packages for https repository
sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl gpg
# Add Kubernetes’s official GPG key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
# Add Kubernetes repository
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
# Update package manager index
sudo apt-get update
# Install kubeadm, kubelet and kubectl with the exact same version or else components could be incompatible
sudo apt-get install -y kubelet=1.32.0-00 kubeadm=1.32.0-00 kubectl=1.32.0-00
# Hold the version of the packages
sudo apt-mark hold kubelet kubeadm kubectl
```

The last line is very important because we don't want the Kubernetes components to be updated automatically by the package manager when running `apt-get upgrade`.
