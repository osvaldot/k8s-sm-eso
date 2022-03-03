## General
aws_default_region = "eu-west-1"

cluster = "eso-cluster"

## VPC
vpc_cidr_block = "10.30.0.0/16"
vpc_azs = [ "eu-west-1a", "eu-west-1b" ]
vpc_public_subnet_block = [ "10.30.1.0/24", "10.30.2.0/24" ]
vpc_private_subnet_block = [ "10.30.3.0/24", "10.30.4.0/24" ]

## EKS settings
eks_node_instance_types = [ "t3.medium" ]
eks_node_desired = 2
eks_node_min = 2
eks_node_max = 5
# IAM users that will have access to the cluster (the user creating the cluster will always be admin)
eks_admin_users = ["osvaldo"]
eks_dev_users = []

project = "example"
