# Integrate external secret management systems in Kubernetes

How to manage our [Kubernetes](https://kubernetes.io) secrets with [AWS Secrets Manager](https://aws.amazon.com/secrets-manager/) 
as a single source of truth with [External Secrets Operator](https://external-secrets.io/) in [AWS Elastic Kubernetes Service](https://aws.amazon.com/eks/)

Note: the project is NOT a production ready code, is a sample code used in [Spakfabrik tech blog](https://tech.sparkfabrik.com/), in 
[Integrate external secrets management systems in Kubernetes](https://tech.sparkfabrik.com/en/blog/integrate-external-secrets-management-systems-in-kubernetes/) post


## Prerequisites

Before we start, let's make sure we meet these requirements:

- An AWS account and an IAM user with administrator permissions
- Docker installed and running on your local machine
- A basic knowledge of Terraform

Copy env.template to .env file and use your IAM user credentials to fill AWS_ACCESS_KEY_ID and
AWS_SECRET_ACCESS_KEY values, then specify the AWS_DEFAULT_REGION.

## Build cli docker image

`$ make build-cli`

## Build

`$ make cli`

`$ terraform init`

`$ terraform validate`

`$ terraform plan`

`$ terraform apply`

## kubectl configuration

Inside the cli

`$ aws eks update-kubeconfig --region REGION --name CLUSTER_NAME`

## Tips

Force secret update

`$ kubectl annotate es externalsecret-example -n example force-sync=$(date +%s) --overwrite`

## Verify secrets

`$ kubectl get secret example-secret -n example -o jsonpath='{.data}'`
`$ echo 'MTIzNDU2' | base64 -d`
