# Certificates

As we said previously `kubeadm init` generates a set of certificates. All these certificates are stored in `/etc/kubernetes/pki`. This directory is used by Kubernetes to store certificates and keys. But what are these certificates for ?

## PKI (Public Key Infrastructure)

Kubernetes uses a PKI to secure the communication between components. PKI is a set of cryptographic tools that are used to generate, store and distribute certificates. The PKI used by Kubernetes is based on the PKI used by `etcd`. The PKI is composed of 3 main elements:

* Certificate Authority(CA) certificates
* Components certificates
* Users certificates

## Certificate Authority(CA) certificates

The first certificate generated is the CA certificate. CA mean Certificate Authority. It is the root certificate that is used to sign all the other certificates. That means that we can validate a certificate by checking if it has been signed by the CA certificate.

This certificate is stored in `/etc/kubernetes/pki/ca.crt` and the private key in `/etc/kubernetes/pki/ca.key`. The private key is used to sign the other certificates.

## Components certificates

There is a pair of certificate and private key for each component of Kubernetes. The list of components is:

  * kube-apiserver
  * kube-controller-manager
  * kube-scheduler
  * kube-proxy
  * kubelet

## Etcd certificates

Etcd has its own PKI. The list of certificates is:

  * etcd-ca
  * etcd-server
  * etcd-peer
  * etcd-healthcheck-client

## Enable authentication for kubelet (advanced)

The `kubelet` is the agent that runs on each node. It is responsible for starting and stopping containers. It also exposes an API but by default it is not secured. This means that anyone can access the API. Your task is to secure `kubelet` by enabling certificate authentication.

## Certificate management with kubeadm

[source](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-certs/)

Certificates expire after a given time. This time is called the certificate lifetime. The default lifetime for the component's certificates is 1 year and for the CA certificate is 10 years. The rotation of the certificates is done using `kubeadm`.

You can check the expiration date of the certificates using the following command:

```bash
kubeadm certs check-expiration
```

You can renew all the certificates using the following command:

```bash
kubeadm certs renew all
```

You can renew a specific certificate using the following command:

```bash
kubeadm certs renew <certificate-name>
```

Example for the `kube-apiserver` certificate:

```bash
kubeadm certs renew kube-apiserver
```

After renewing the certificates you need to restart the components that use them. To do so you can move the manifests of the static pods like we saw in the previous chapter.

## Conclusion

Certificates are an important part of Kubernetes since they are the reasons we are able to have node to node communications over public networks. In the next chapter we will see in details what happens when we create a deployment.
