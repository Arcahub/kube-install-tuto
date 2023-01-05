# Infrastructure provisionning

To deploy our Kubernetes cluster we need to have some VMs available. To do this in this course we will be using [Scaleway](https://www.scaleway.com).

At the root of this repository you will find a `terraform` folder. It contains the source [Terraform](https://www.terraform.io/) files that will provide our infrastructure.

## TL;DR

To install the infrastructure you will need to have a scaleway account and the [Scaleway CLI](https://github.com/scaleway/scaleway-cli) installed and [setup](https://github.com/scaleway/scaleway-cli)

With the Scaleway CLI setup you can then run the following command from the root of the repository:

```bash
    cd terraform
    terraform init
    terraform plan
    terraform apply
```

Terraform will ask you to validate the creation of the infrastructure, press `yes` and wait for the infrastructure to be created.

To connect to the instances follow the instructions in the [last section of this page](#connection-to-the-instances)

## Step by step

## Connection to the instances

To connect to the instances we will use the public gateway that is configured with a ssh bastion.

To get the ips of the instances and the public gateway you can run the following command to get outputs from terraform:

```bash
    terraform output
```

To connect with ssh to any instance you can use the following command:

```bash
ssh -J bastion@<public gateway_ip>:61000 root@<instance_ip>
```
