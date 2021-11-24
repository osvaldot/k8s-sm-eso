# Integrate AWS Secrets Manager in an k8s Cluster with External Secrets Operator

Integrate AWS Secrets Manager in an k8s Cluster with External Secrets Operator

This project IS NOT production ready !

# Prerequisites

AWS account

##

VPC
EKS
ASM
ESO
store

EXAMPLE

## Build

Build the cli image

$ make build-cli

## Create the cluster

$ make cli

$ terraform init

$ terraform validate

$ terraform plan

$ terraform apply

## Using kubectl

$ make cli

$ aws eks update-kubeconfig --region REGION --name CLUSTER_NAME
