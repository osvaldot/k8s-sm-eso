variable aws_default_region {
  type = string
}

variable project {
  type = string
}

#VPC
variable vpc_cidr_block {
  type = string
}

variable vpc_azs {
  type = list
}

variable vpc_public_subnet_block {
  type = list
}

variable vpc_private_subnet_block {
  type = list
}

# EKS
variable eks_admin_users {
  type = list
}

variable eks_dev_users {
  type = list
}

variable eks_node_instance_types {
  type = list
}

variable eks_node_desired {
  type = number
}

variable eks_node_min {
  type = number
}

variable eks_node_max {
  type = number
}

variable namespaces {
  type = string
}