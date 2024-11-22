# vpc module  variables
variable "vpc_cidr"{}

# subnet module variables
variable "pub_subnet"{
    type              = list(object({
    subnets_cidr      = string
    availability_zone = string
  }))
}

variable "priv_subnet"{
    type              = list(object({
    subnets_cidr      = string
    availability_zone = string
  }))
}
