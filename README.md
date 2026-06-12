# Food-Store-Deployment

This folder contains the Kubernetes deployment manifests and Terraform used to create the EKS cluster, install the ingress controller, and install Argo CD.

## What gets created

- EKS cluster and managed node group
- VPC and subnets for Kubernetes workloads
- NGINX ingress controller for app ingress
- Argo CD exposed through nginx ingress
- Service deployment manifests for auth, catalog, order, and ws services

## Prerequisites

Make sure you have:

- AWS CLI configured with credentials
- Terraform installed
- kubectl installed
- Access to the target AWS account and region

## Temporary Argo CD hostname

Use a temporary hostname until your real domain is ready:

- `argocd.local.pizzaria.store`

When your real domain is available later, update:

- `terraform/variables.tf`
- `terraform/terraform.tfvars`

Then re-run Terraform.

## Terraform workflow

From the Terraform folder:

```bash
cd /Users/mo-jasim/Desktop/DevOps/pizza-app/Food-Store-Deployment/terraform
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

If you want to destroy the cluster later:

```bash
terraform destroy
```

## Kubernetes access

After Terraform finishes, update kubeconfig:

```bash
aws eks update-kubeconfig --name pizza-app-eks --region ap-south-1
```

Verify the cluster:

```bash
kubectl cluster-info
kubectl get nodes
```

## Check Argo CD and ingress controller

```bash
kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx
kubectl get pods -n argocd
kubectl get svc -n argocd
```

## Access Argo CD locally

Use port-forward:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:80
```

Then open:

```bash
http://localhost:8080
```

## Get the Argo CD admin password

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d
```

## Deploy application manifests

```bash
kubectl apply -f /Users/mo-jasim/Desktop/DevOps/pizza-app/Food-Store-Deployment/auth-service/
kubectl apply -f /Users/mo-jasim/Desktop/DevOps/pizza-app/Food-Store-Deployment/catalog-service/
kubectl apply -f /Users/mo-jasim/Desktop/DevOps/pizza-app/Food-Store-Deployment/order-service/
```

## Notes

- Terraform state files should not be committed.
- The root `.gitignore` already excludes `.terraform/`, `*.tfstate`, and `.terraform.lock.hcl`.
- If you later switch Argo CD to the real `pizzaria.store` domain, only update the hostname variables and apply Terraform again.
