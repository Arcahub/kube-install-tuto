# Understanding Kubernetes Components

Before starting any work, let's review how Kubernetes is designed and what are the components that compose it.

## Kubernetes Architecture

[source](https://kubernetes.io/docs/concepts/overview/components/)

Kubernetes is a distributed system composed of multiple components. The following diagram shows the architecture of a Kubernetes cluster.

![Kubernetes Architecture](./images/components-of-kubernetes.svg)

The Kubernetes cluster consists of two types of resources:

- The **control plane** coordinates the cluster
- The **worker nodes** are the machines that run applications

A basic Kubernetes cluster has two worker nodes and one control plane node. The control plane manages the worker nodes and the pods running on the worker nodes through the Kubernetes API.

## Kubernetes Control Plane

As we said earlier, the control plane is responsible for managing the worker nodes and the pods running on the worker nodes. The control plane consists of the following components:

- [kube-apiserver](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/)
- [etcd](https://etcd.io/)
- [kube-scheduler](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-scheduler/)
- [kube-controller-manager](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-controller-manager/)

We will go through each of these components in the following sections.

### kube-apiserver

The kube-apiserver is the component that exposes the Kubernetes API. The API server is the front end for the Kubernetes control plane. The API server is responsible for retrieving and updating data in the cluster. The API server is the only component that talks to the etcd cluster. The API server is responsible for:

- Exposing the Kubernetes API
- Authenticating requests
- Authorizing requests
- Scheduling pods
- Managing the cluster state

### etcd

etcd is a distributed key-value store that provides a reliable way to store data across a cluster of machines. It's used by Kubernetes as backing store for all cluster data. The etcd cluster is used by the API server to store the state of the cluster.

### kube-scheduler

The kube-scheduler is responsible for scheduling pods on worker nodes. The scheduler watches for newly created pods that have no node assigned. For every pod that the scheduler discovers, the scheduler becomes responsible for finding the best node for that pod to run on. The scheduler reaches this decision taking into account the resources available on the node and any relevant constraints. The scheduler makes the decision based on a set of predefined policies. The default scheduler provided with Kubernetes is `default-scheduler`. You can create your own scheduler and use it instead of the default scheduler. The default scheduler looks at the following factors when scheduling a pod:

- Node affinity
- Node anti-affinity
- Pod affinity
- Pod anti-affinity
- Taints and tolerations
- Node and pod resource requests and limits
- Node conditions
- Pod priority
- Inter-pod affinity and anti-affinity
- Node labels

### kube-controller-manager

The kube-controller-manager is a daemon that embeds the core control loops shipped with Kubernetes. In Kubernetes, a control loop is a non-terminating loop that regulates the state of the cluster. The controller manager runs all the control loops in separate processes. The following controllers are included in the kube-controller-manager:

- Node Controller: Responsible for noticing and responding when nodes go down.
- Replication Controller: Responsible for maintaining the correct number of pods for every replication controller object in the system.
- Endpoints Controller: Populates the Endpoints object (that is, joins Services & Pods).
- Service Account & Token Controllers: Create default accounts and API access tokens for new namespaces.

## Kubernetes Worker Nodes

The worker nodes are the machines that run applications. The worker nodes consist of the following components:

- [kubelet](https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/)
- [kube-proxy](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-proxy/)

### kubelet

The kubelet is the primary "node agent" that runs on each node. The kubelet takes a set of PodSpecs that are provided through various mechanisms and ensures that the containers described in the PodSpecs are running and healthy. The kubelet doesn't manage containers which were not created by Kubernetes.

### kube-proxy

The kube-proxy is responsible for network proxying. The kube-proxy maintains network rules on the nodes. These network rules allow network communication to your Pods from network sessions inside or outside your cluster. The kube-proxy uses the operating system packet filtering layer if there is one available. Otherwise, kube-proxy forwards the traffic itself. The kube-proxy is responsible for:

- Load balancing connections across the different Pods
- Maintaining network rules on the nodes
- Forwarding traffic to the right Pod
