# Create an EKS Cluster using Terraform

This repository contains Terraform scripts to create an Amazon EKS cluster. The setup includes VPC, subnets, security groups, IAM roles, and the EKS cluster itself.

## Prerequisites

Before you begin, ensure you have the following installed:

- [Terraform](https://www.terraform.io/downloads.html) v1.0 or later
- AWS CLI configured with appropriate credentials
- [kubectl](https://kubernetes.io/docs/tasks/tools/) for interacting with your EKS cluster

## Steps to Deploy

### Step 1: Clone the Repository

```
git clone git@github.com:ravindrasinghh/Kubernetes-Playlist.git
cd Kubernetes-Playlist/Lesson1/
```
### Step 2: Initialize Terraform
- terraform init
- terraform plan
- terraform apply

### Step 3: Access Your EKS Cluster
Once the cluster is created, you can configure kubectl to interact with your EKS cluster using the following command:
```
aws eks --region <region-name> update-kubeconfig --name <eks-cluster-name>
```
You can then verify the cluster connectivity:
```
kubectl get nodes
```

## Troubleshooting
If you encounter any issues, refer to the Terraform documentation or raise an issue in this repository.

