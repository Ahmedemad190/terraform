variable "instance_count" {
  description = "Number of instances to create"
  default     = 2
}

variable "ami" {
  description = "Amazon Machine Image ID"
  default     = "ami-0866a3c8686eaeeba"  # Replace with the correct AMI ID for your region
}

variable "instance_type" {
  description = "Instance type to use"
  default     = "t2.micro"
}
variable "instance_count_priv" {
  description = "private creation"
  default = 2
  
}
