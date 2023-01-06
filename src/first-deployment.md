# Creating our first deployment

Now that we have a working cluster, we can deploy our first application. But you should already have deployed something on Kubernetes, right? So to make it more interesting, I will explain you what happens behind the scenes when you run `kubectl create deployment nginx --image=nginx --replicas=3`.

[source](https://github.com/jamiehannaford/what-happens-when-k8s)

## Client side

So let's get started. The firt things happening when you run `kubectl create deployment nginx --image=nginx --replicas=3` is that the client will read the file and perform client side validation. It will check if the file is a valid YAML file and if it contains the required fields. If it doesn't, it will return an error.

Then the client will create an HTTP request for the API server that will contains the YAML object. To do so, it will read the kubeconfig file to get the API server URL and the certificate to authenticate to the API server.

Finally, the client will send the request to the API server.

## API server

When the API server receive the request, it will first authenticate the client using the certificate. Then it will check if the request is authorized by checking the RBAC rules linked to the user. If the request is authorized, it will check if the object is valid. It will check if the object is a valid Kubernetes object and if it contains the required fields. If it doesn't, it will return an error.

As the last defense, the API server will check if the object is valid against the [admission controllers](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#what-are-they). We won't go into details about the admission controllers but they are a set of plugins that can modify or reject objects. For example, the [PodSecurityPolicy](https://kubernetes.io/docs/concepts/policy/pod-security-policy/) admission controller will check if the Pod is compliant with the PodSecurityPolicy.

At this point the request has been fully verified and the API server will store the object in the etcd database.

## Controller manager

Now that the object is stored in the etcd database, the next step is to create the corresponding Kubernetes object. A Deployment is a collection of ReplicaSets and a ReplicaSet is a collection of Pods. So the controller manager will create the ReplicaSet and the Pods and to do so, it will use Kubernetes' built-in controllers.

A controller is a loop that will check if the desired state stored in `etcd` is the same as the current state of the cluster. If it's not, it will try to reconcile the two states. For example, if you have a Deployment with 3 replicas and you delete one of the Pods, the controller will notice that the desired state is 3 Pods and the current state is 2 Pods and it will create a new Pod to reach the desired state.

So after a Deployment is stored in `etcd`, it is detected by the Deployment controller that will detect the `create` event on the Deployment. It will then that there are no ReplicaSets associated with the Deployment and it will create one. It will work similarly for the ReplicaSet and the Pods. If you want to know more about the controllers, you can read the [official documentation](https://kubernetes.io/docs/concepts/architecture/controller/) and this article about [Kubernetes controllers](http://borismattijssen.github.io/articles/kubernetes-informers-controllers-reflectors-stores).

## Scheduler

After all the controllers have done their job, we have a Deployment, a ReplicaSet and a set of Pods stored in `etcd` but nothing is running on the nodes. To be more precise, the Pods are in the `Pending` state. The reason is that the Pods are not scheduled on any node.

The scheduler is responsible for scheduling the Pods on the nodes. It will check the Pod's requirements and try to find a node that can run the Pod. If it finds a node, it will update the Pod's `spec.nodeName` field and the Pod will be scheduled on the node.

For example, if you have a Pod that requires 1 CPU and 1GB of RAM, the scheduler will first filter the nodes with a series of predicates to assure they match the requirements of the Pod. Then it will rank the nodes with a series of priorities to find the best node. For example, it will try to find a node with the lowest number of Pods to reduce the risk of resource contention.

Again, if you want to know more about the scheduler, you can read the [official documentation](https://kubernetes.io/docs/concepts/scheduling/kube-scheduler/).

## Kubelet

At this point, the Pods are scheduled on nodes with the `spec.nodeName` field set but they are still not running. And that's the job of `kubelet`.

As you know `kubelet` is the agent that runs on each node. It is responsible for translating the abstract Pod definition into a running container. To achieve that, it will query the API server to get the list of Pods by filtering on Pods that have the `spec.nodeName` field that correspond to the name of the node where the `kubelet` querying is running. Then it will detect change by comparing with its local cache. If there is a change, it will try to reconcile the two states.

For our example, the `kubelet` will see that the Pod is scheduled on the node and it will try to run it. To do so, it will use the container runtime to run the container. If the container is running, the Pod will be in the `Running` state.

## Conclusion

Well, that's it. This is the whole process that happens when you run `kubectl create deployment nginx --image=nginx --replicas=3`. Of course we can always go deeper and explain what happens in each step but if you have understood this article, you should have a good understanding of how Kubernetes works.
