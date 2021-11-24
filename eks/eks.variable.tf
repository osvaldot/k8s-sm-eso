variable vpc_id {
  type = string
}

variable project {
  type = string
}

variable cidr_block {
  type = string
}

variable subnets {
  type = list
}

variable admin_users {
  type = list
}

variable dev_users {
  type = list
}

variable node_instance_types {
  type = list
}

variable node_desired {
  type = number
}

variable node_min {
  type = number
}

variable node_max {
  type = number
}

variable namespaces {
  type = list
}