# Integrate external secret management systems in Kubernetes

Integrate [AWS Secrets Manager](https://aws.amazon.com/secrets-manager/) in [AWS Elastic Kubernetes Service](https://aws.amazon.com/eks/) with [External Secrets Operator](https://external-secrets.io/)

Note: the project is NOT a prodction ready code, this is a sample code used in [Spakfabrik tech post](https://tech.sparkfabrik.com/).


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
