# Create a config for a developper

As a Kubernetes cluster administrator, you will need to create config files for the developpers of your company. This will allow them to access the cluster and deploy their applications.

The first step is to create a certificate for the developper. This certificate will be used to authenticate the developper to the cluster.

The certificate will be signed by the cluster CA. As we previously saw, the cluster CA is the certificate authority that is used to sign the certificates of the cluster components. The cluster CA is created when the cluster is created.

To create a certificate for a developper, you will need to create a certificate signing request (CSR). The CSR will be signed by the cluster CA. The CSR will contain the name of the developper. The name of the developper will be used to create a context for the developper.

Once you have successfully created the certificate, you will need to create a kubeconfig file for the developper. The kubeconfig file will contain the certificate of the developper and the address of the cluster. The kubeconfig file will be used by the developper to access the cluster.

Here is an example of a kubeconfig file for a developper named employee :

```yaml
apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority: CA_LOCATION/ca.crt
    server: https://KUBERNETES_ADDRESS:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: employee
  name: employee
current-context: employee
users:
- name: employee
  user:
    client-certificate: DEVELOPER_CERTIFICATE_LOCATION/employee.crt
    client-key: DEVELOPER_CERTIFICATE_LOCATION/employee.key
```

In the `client-certificate` and `client-key` fields, you will need to replace `DEVELOPER_CERTIFICATE_LOCATION` with the location of the certificate of the developper. You can also directly copy the content of the `employee.crt` and `employee.key` files in the `client-certificate` and `client-key` fields.

Same things for the `certificate-authority` field. You will need to replace `CA_LOCATION` with the location of the cluster CA or you can also directly copy the content of the `ca.crt` file in the `certificate-authority` field.

In the `server` field, you will need to replace `KUBERNETES_ADDRESS` with the address of the cluster.

Once you have successfully created the kubeconfig file, you will need to give it to the developper. The developper will then be able to use the kubeconfig file to access the cluster.

## Concrete example

Let's say that you are the cluster administrator of a cluster named `kubernetes`. You will need to create a certificate for a developper named `employee`. You will then need to create a kubeconfig file for the developper. You will then need to give the kubeconfig file to the developper.

To create the certificate, you will need to ssh into the control plane node. You will then need to run the following command :

```bash
openssl genrsa -out employee.key 2048
```

This command will create the private key of the developper. The private key will be used to sign the certificate signing request of the developper.

Then you will need to run the following command :

```bash
openssl req -new -key employee.key -out employee.csr -subj "/CN=employee"
```

This command will create the certificate signing request of the developper. The certificate signing request will be signed by the cluster CA. The certificate signing request will contain the name of the developper. The name of the developper will be used to create a context for the developper.

Then you will need to run the following command :

```bash
openssl x509 -req -in employee.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out employee.crt -days 500
```

This command will create the certificate of the developper. The certificate will be signed by the cluster CA. The certificate will contain the name of the developper. The name of the developper will be used to create a context for the developper.

Then you will need to run the following command :

```bash
kubectl config set-cluster kubernetes --certificate-authority=/etc/kubernetes/pki/ca.crt --embed-certs=true --server=https://KUBERNETES_ADDRESS:6443 --kubeconfig=employee.kubeconfig
```

This command will create a cluster entry in the kubeconfig file. The cluster entry will contain the address of the cluster. The address of the cluster will be used to access the cluster.

Then you will need to run the following command :

```bash
kubectl config set-credentials employee --client-certificate=employee.crt --client-key=employee.key --embed-certs=true --kubeconfig=employee.kubeconfig
```

This command will create a user entry in the kubeconfig file. The user entry will contain the certificate of the developper. The certificate of the developper will be used to authenticate the developper to the cluster.

Then you will need to run the following command :

```bash
kubectl config set-context employee --cluster=kubernetes --user=employee --kubeconfig=employee.kubeconfig
```

This command will create a context entry in the kubeconfig file. The context entry will contain the name of the developper. The name of the developper will be used to create a context for the developper.

Then you will need to run the following command :

```bash
kubectl config use-context employee --kubeconfig=employee.kubeconfig
```

This command will set the current context of the kubeconfig file to the context of the developper.

Then you will need to run the following command :

```bash
kubectl config view --flatten --minify --kubeconfig=employee.kubeconfig > employee.kubeconfig
```

This command will flatten the kubeconfig file. The flattened kubeconfig file will be easier to read.

Then you will need to give the `employee.kubeconfig` file to the developper. The developper will then be able to use the kubeconfig file to access the cluster.

## Test the kubeconfig file

To test the kubeconfig file, you can use it with the `kubectl` command. You will need to run the following command :

```bash
kubectl get pods --kubeconfig=employee.kubeconfig
```

This command should return the following error :

```bash
Error from server (Forbidden): pods is forbidden: User "employee" cannot list resource "pods" in API group "" in the namespace "default"
```

This error means that the developper is not authorized to list pods in the default namespace. This is normal because we have not given the developper any permissions. We will see how to give the developper some permissions in the next section.

But you can see that we have successfully authenticated against the API server. This means that the kubeconfig file is working.

## Add permissions to the developper

The developper will be able to access the cluster but he will not be able to do anything. The developper will not have any permissions. You will need to give the developper some permissions.

To give the developper some permissions, you will need to create a role. You will then need to create a role binding. You will then need to give the role binding to the developper.

To create the role, you will need to run the following command :

```bash
kubectl create role developer --verb=get,list,watch --resource=pods --namespace=default
```

This command will create a role named `developer`. The role will allow the developper to get, list and watch pods in the default namespace.

To create the role binding, you will need to run the following command :

```bash
kubectl create rolebinding developer --role=developer --user=employee --namespace=default
```

This command will create a role binding named `developer`. The role binding will bind the role `developer` to the developper `employee` in the default namespace.

## Test the permissions

To test the permissions, you can use the kubeconfig file with the `kubectl` command. You will need to run the following command :

```bash
kubectl get pods --kubeconfig=employee.kubeconfig
```

This command should return the following output :

```bash
No resources found in default namespace.
```

This output means that the developper is authorized to list pods in the default namespace.

## Conclusion

In this article, we have seen how to create a kubeconfig file for a developper. We have also seen how to give the developper some permissions.

That was the last article, in the next one I will give you some bonus exercises you can do if you want to go further.
